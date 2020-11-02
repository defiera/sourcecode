pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract Swap is SwapState, KContract {

    constructor(
        ERC777Interface usdInc,
        AssertPoolInterface astPoolInc,
        Hosts host
    ) public {
        _KHost = host;
        usdtInterface = usdInc;
        astPool = astPoolInc;

        
        
        
        
        
        
        swapInfo = Info(
            1, 
            500000 ether, 
            0, 
            20 * 10 ** 12 
        );
    }

    
    function Doswaping(uint) external readwrite returns (DoswapingError, uint) {
        super.implementcall();
    }

    
    function OwnerUpdateSwapInfo(uint, uint) external readwrite {
        super.implementcall();
    }

    function () external payable {

    }
}
