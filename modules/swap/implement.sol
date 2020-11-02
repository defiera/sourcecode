pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

interface LimitInterface {
    
    function exchangeLimit(address owner) external returns (uint);

    function shouldChange(address owner, uint amountOfUSD) external returns (bool);

    function didChangeDelegate(address owner, uint amountOfUSD) external;
}

contract SwapImpl is SwapState {

    modifier pluginsExt_Limit(uint amount) {
        require(
            LimitInterface(0xEa99B088715798a4Fe27cA0C7699644bbF5a91c8).exchangeLimit(msg.sender) >= amount
        );
        _;
        LimitInterface(0xEa99B088715798a4Fe27cA0C7699644bbF5a91c8).didChangeDelegate(msg.sender, amount);
    }

    function Doswaping(uint amount) external pluginsExt_Limit(amount) returns (DoswapingError code, uint tokenAmount) {

        
        tokenAmount = amount * swapInfo.prop;

        
        if ( swapInfo.current + tokenAmount > swapInfo.total  ) {
            return (DoswapingError.SwapBalanceInsufficient, 0);
        }

        
        if ( usdtInterface.balanceOf(msg.sender) < amount ) {
            return (DoswapingError.BalanceInsufficient, 0);
        }

        
        swapInfo.current += tokenAmount;
        swapedTotalSum += tokenAmount;

        
        usdtInterface.operatorSend(msg.sender, address(astPool), amount, "", "");
        astPool.Auth_RecipientDelegate(amount);

        
        require( _safeSendEther(msg.sender, tokenAmount) );

        emit Log_Swaped(msg.sender, now, amount, tokenAmount);

        return (DoswapingError.NoError, tokenAmount);
    }

    function OwnerUpdateSwapInfo(uint total, uint prop) external KOwnerOnly {

        swapInfo.roundID ++;
        swapInfo.total = total;
        swapInfo.current = 0;
        swapInfo.prop = prop;

        emit Log_UpdateSwapInfo(now, msg.sender, total, prop);
    }

}
