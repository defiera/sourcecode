pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract CounterRecommend is CounterRecommendState, KContract {

    constructor(RelationshipInterface rltInc, Hosts host) public {
        _KHost = host;
        RLTInterface = rltInc;
    }

    
    function InitSet_AuthorizedAddress(address addr) external KOwnerOnly {
        authorizedAddress = addr;
    }

    
    function WhenOrderCreatedDelegate(OrderInterface) external readonly returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    
    function WhenOrderFrozenDelegate(OrderInterface) external readonly returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    
    function WhenOrderDoneDelegate(OrderInterface) external readonly returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    
    function SetAwardProp(uint) external readwrite {
        super.implementcall();
    }

    
    function Import(address, bool) external readwrite {
        super.implementcall();
    }
}
