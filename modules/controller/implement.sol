pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract ControllerImpl is ControllerState {

    function order_PushProducerDelegate() external {}

    function order_PushConsumerDelegate() external returns (uint) {}

    function order_HandleAwardsDelegate(address, uint, CounterModulesInterface.AwardType) external {}

    function order_PushBreakerToBlackList(address) external {}

    function order_DepositedAmountDelegate() external {}

    function order_ApplyProfitingCountDown() external returns (bool) {}

    function order_AppendTotalAmountInfo(address, uint, uint) external {}

    function order_IsVaild(address) external returns (bool) {}


    function CreateOrder(uint, uint) external returns (CreateOrderError) {}

    function CreateDefragmentationOrder(uint) external returns (uint) {}

    function CreateAwardOrder(uint) external payable returns (CreateOrderError) {}


    function GetOrder(address, uint) external returns (uint, uint, OrderInterface) {}

    function GetAwardOrder(address, uint) external returns (uint, uint, OrderInterface) {}

    function IsBreaker(address) external returns (bool) {}

    function ResolveBreaker() external payable {}


    function QueryOrders(address, OrderInterface.OrderType, uint, uint, uint) external returns (uint, uint, OrderInterface[] memory, uint[] memory, OrderInterface.OrderStates[] memory, uint96[] memory) {}

    function OwnerGetSeekInfo() external KOwnerOnly returns (uint, uint, uint, uint, uint) {}

    function OwnerGetOrder(QueueName, uint) external returns (OrderInterface) {}

    function OwnerGetOrderList(QueueName, uint, uint) external returns (OrderInterface[] memory, uint[] memory, uint[] memory) {}

    function OwnerUpdateOrdersTime(OrderInterface[] calldata, uint) external {}

    function ImportLinkedOrder(address, uint, address, uint, OrderInterface.OrderType) external {}

    function ImportOrder(address, uint, OrderInterface.OrderStates, bool) external returns (OrderInterface) {}

    function ForceGetAndToHelp() external {}
}
