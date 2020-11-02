pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract PhoenixImpl is PhoenixState {

    modifier ControllerOnly {
        require( _CTL == ControllerDelegate(msg.sender), "InvalidOperation");
        _;
    }

    function GetInoutTotalInfo(address owner) external returns (uint totalIn, uint totalOut) {
        return (inoutMapping[dataStateVersion][owner].totalIn, inoutMapping[dataStateVersion][owner].totalOut);
    }

    
    function SettlementCompensate() external returns (uint total) {

        
        for (uint i = 0; i < dataStateVersion; i++) {

            InoutTotal storage info = inoutMapping[i][msg.sender];

            
            if ( info.totalOut < info.totalIn ) {
                total += (info.totalIn - info.totalOut) * compensateProp;
            }

            info.totalOut = 0;
            info.totalIn = 0;
        }

        
        if ( total > 0 ) {

            Compensate storage c = compensateMapping[msg.sender];
            c.total += total;

            if ( c.latestWithdrawTime == 0 ) {
                c.latestWithdrawTime = now;
            }

            emit Log_CompensateCreated(msg.sender, now, total);
        }
    }

    function WithdrawCurrentRelaseCompensate() external returns (uint amount) {

        Compensate storage c = compensateMapping[msg.sender];
        if ( c.total == 0 || c.currentWithdraw >= c.total ) {
            return 0;
        }

        
        uint deltaDay = (now - c.latestWithdrawTime) / 1 days;
        if ( deltaDay > 0 ) {
            amount = c.total * compensateRelaseProp / 1 szabo * deltaDay;
        }

        if ( (amount + c.currentWithdraw) > c.total ) {
            amount = c.total - c.currentWithdraw;
        }

        if ( amount > 0 ) {

            c.currentWithdraw += amount;
            c.latestWithdrawTime = now;

            
            require( _safeSendEther(msg.sender, amount) );

            emit Log_CompensateRelase(msg.sender, now, amount);
        }

    }

    function CTL_AppendAmountInfo(address owner, uint inAmount, uint outAmount) external ControllerOnly {
        inoutMapping[dataStateVersion][owner].totalIn += inAmount;
        inoutMapping[dataStateVersion][owner].totalOut += outAmount;
    }

    function CTL_ClearHistoryDelegate(address breaker) external ControllerOnly {
        inoutMapping[dataStateVersion][breaker] = InoutTotal(0, 0);
    }

    function ASTPoolAward_PushNewStateVersion() external {
        require(msg.sender == address(_ASTPoolAwards));
        dataStateVersion++;
    }

    
    function SetCompensateRelaseProp(uint p) external KOwnerOnly {
        compensateRelaseProp = p;
    }

    
    function SetCompensateProp(uint p) external KOwnerOnly {
        compensateProp = p;
    }

    function Import(address sender, uint totalIn, uint totalOut) external KOwnerOnly {
        inoutMapping[dataStateVersion][sender].totalIn += totalIn;
        inoutMapping[dataStateVersion][sender].totalOut += totalOut;
    }
}
