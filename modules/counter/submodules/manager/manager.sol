pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract CounterManager is CounterManagerState, KContract {

    constructor(
        RelationshipInterface rltInc,
        ERC777Interface usdtInc,
        Hosts host
    ) public {
        RLTInterface = rltInc;
        usdtInterface = usdtInc;
        _KHost = host;
    }

    
    function InitSet_AuthorizedAddress(address addr) external KOwnerOnly {
        authorizedAddress = addr;
    }

    
    function InfomationOf(address) external readonly returns (bool, uint, uint, uint) {
        super.implementcall();
    }

    
    function UpgradeDLevel() external readwrite returns (uint, uint) {
        super.implementcall();
    }

    
    function PaymentDLevelOne() external readwrite returns (bool) {
        super.implementcall();
    }

    
    function WhenOrderCreatedDelegate(OrderInterface) external readwrite returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    
    function WhenOrderFrozenDelegate(OrderInterface) external readwrite returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    
    function WhenOrderDoneDelegate(OrderInterface) external readwrite returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    
    function SetRecommendAwardProp(uint, uint) external readwrite {
        super.implementcall();
    }

    
    function SetDLevelAwardProp(uint, uint) external readwrite {
        super.implementcall();
    }

    
    function SetDLevelSearchDepth(uint) external readwrite {
        super.implementcall();
    }

    
    function SetDlevel1DepositedNeed(uint) external readwrite {
        super.implementcall();
    }

    
    function SetDLevel1Prices(uint) external readwrite {
        super.implementcall();
    }

    
    function ImportDLevel(address, uint8, uint, uint) external readwrite {
        super.implementcall();
    }
}
