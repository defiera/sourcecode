pragma solidity >=0.5.1 <0.7.0;

import "../order/interface.sol";

interface CounterModulesInterface {

    enum AwardType {
        
        Recommend,
        
        Admin,
        
        Manager,
        
        Grow
    }

    
    struct InvokeResult {
        uint len;
        address[] addresses;
        uint[] awards;
        AwardType[] awardTypes;
    }

    
    

    function WhenOrderCreatedDelegate(OrderInterface)
    external returns (uint, address[] memory, uint[] memory, AwardType[] memory);

    
    function WhenOrderFrozenDelegate(OrderInterface)
    external returns (uint, address[] memory, uint[] memory, AwardType[] memory);

    
    function WhenOrderDoneDelegate(OrderInterface)
    external returns (uint, address[] memory, uint[] memory, AwardType[] memory);
}

interface CounterInterface {

    function SubModuleCIDXXS() external returns (uint[] memory);

    function AddSubModule(CounterModulesInterface moduleInterface) external;

    function RemoveSubModule(CounterModulesInterface moduleInterface) external;
}
