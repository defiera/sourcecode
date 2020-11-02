pragma solidity >=0.5.1 <0.7.0;

import "../order/interface.sol";
import "../counter/interface.sol";


interface ControllerInterface_User_Write {

    enum CreateOrderError {
        
        NoError,
        
        LessThanMinimumLimit,
        
        LessThanMinimumPaymentPart,
        
        LessThanFrontOrder,
        
        LessThanOrderCreateInterval,
        
        InvaildParams,
        
        CostInsufficient
    }

    
    function CreateOrder(uint total, uint amount) external returns (CreateOrderError code);

    
    
    
    function CreateAwardOrder(uint amount) payable external returns (CreateOrderError code);

    
    function CreateDefragmentationOrder(uint l) external returns (uint totalAmount);
}


interface ControllerInterface_User_Read {

    
    function IsBreaker(address owner) external returns (bool);

    
    function ResolveBreaker() external payable;

    
    function GetOrder(address owner, uint index) external returns (uint total, uint id, OrderInterface order);

    
    function GetAwardOrder(address owner, uint index) external returns (uint total, uint id, OrderInterface order);
}

interface ControllerDelegate {

    
    function order_PushProducerDelegate() external;

    
    function order_PushConsumerDelegate() external returns (uint);

    
    function order_HandleAwardsDelegate(address addr, uint award, CounterModulesInterface.AwardType atype ) external;

    
    function order_PushBreakerToBlackList(address breakerAddress) external;

    
    function order_DepositedAmountDelegate() external;

    
    function order_ApplyProfitingCountDown() external returns (bool);

    
    function order_AppendTotalAmountInfo(address owner, uint inAmount, uint outAmount) external;

    
    function order_IsVaild(address orderAddress) external returns (bool);
}

interface ControllerInterface_Onwer {

    function QueryOrders(
        
        address owner,
        
        OrderInterface.OrderType orderType,
        
        uint orderState,
        
        uint offset,
        
        uint size
    ) external returns (
        
        uint total,
        
        uint len,
        
        OrderInterface[] memory orders,
        
        uint[] memory totalAmounts,
        
        OrderInterface.OrderStates[] memory states,
        
        uint96[] memory times
    );

    
    
    
    
    
    
    
    
    
    function OwnerGetSeekInfo() external returns (uint total, uint ptotal, uint ctotal, uint pseek, uint cseek);

    
    enum QueueName {
        
        Producer,
        
        Consumer,
        
        Main
    }
    function OwnerGetOrder(QueueName qname, uint seek) external returns (OrderInterface);

    
    function OwnerGetOrderList(QueueName qname, uint offset, uint size) external
    returns (
        
        OrderInterface[] memory orders,
        
        uint[] memory times,
        
        uint[] memory totalAmounts
    );

    
    function OwnerUpdateOrdersTime(OrderInterface[] calldata orders, uint targetTimes) external;

    
    
    function ImportLinkedOrder(address owner, uint amount, address targetContractAddress, uint ctime, OrderInterface.OrderType ortype) external;

    
    function ForceGetAndToHelp() external;

    
    function ImportOrder(address sender, uint total, OrderInterface.OrderStates state, bool isProducer ) external returns (OrderInterface);
}


contract ControllerInterface is ControllerInterface_User_Write, ControllerInterface_User_Read, ControllerInterface_Onwer {}
