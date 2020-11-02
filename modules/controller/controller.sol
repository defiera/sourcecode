pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract Controller is ControllerState, KContract {

    constructor(
        ERC777Interface usdInc,
        ConfigInterface confInc,
        RewardInterface rewardInc,
        CounterModulesInterface counterInc,
        AssertPoolAwardsInterface astAwardInc,
        PhoenixInterface phInc,
        RelationshipInterface rlsInc,
        Hosts host
    ) public {
        _KHost = host;
        usdtInterface = usdInc;

        configInterface = confInc;
        rewardInterface = rewardInc;
        counterInterface = counterInc;
        astAwardInterface = astAwardInc;
        phoenixInterface = phInc;
        relationInterface = rlsInc;

        OrderManager.init(_orderManager, usdInc);
    }

    
    
    
    

    
    
    function order_PushProducerDelegate() external readwrite {
        super.implementcall(1);
    }

    
    function order_PushConsumerDelegate() external readwrite returns (uint) {
        super.implementcall(1);
    }

    
    function order_HandleAwardsDelegate(address, uint, CounterModulesInterface.AwardType) external readwrite {
        super.implementcall(1);
    }

    
    function order_PushBreakerToBlackList(address) external readwrite {
        super.implementcall(1);
    }

    
    function order_DepositedAmountDelegate() external readwrite {
        super.implementcall(1);
    }

    
    function order_ApplyProfitingCountDown() external readwrite returns (bool) {
        super.implementcall(1);
    }

    function order_AppendTotalAmountInfo(address, uint, uint) external readwrite {
        super.implementcall(1);
    }

    
    function order_IsVaild(address) external readonly returns (bool) {
        super.implementcall(1);
    }

    
    function GetOrder(address, uint) external readonly returns (uint, uint, OrderInterface) {
        super.implementcall(3);
    }

    
    function GetAwardOrder(address, uint) external readonly returns (uint, uint, OrderInterface) {
        super.implementcall(3);
    }

    
    function CreateOrder(uint, uint) external readonly returns (CreateOrderError) {
        super.implementcall(4);
    }

    
    function CreateDefragmentationOrder(uint) external readwrite returns (uint) {
        super.implementcall(4);
    }

    
    function CreateAwardOrder(uint) external payable readwrite returns (CreateOrderError) {
        super.implementcall(4);
    }

    function IsBreaker(address) external readonly returns (bool) {
        super.implementcall(3);
    }

    function ResolveBreaker() external payable readwrite {
        super.implementcall(3);
    }

    
    
    
    
    function QueryOrders(address, OrderInterface.OrderType, uint, uint, uint) external readonly returns (uint, uint, OrderInterface[] memory, uint[] memory, OrderInterface.OrderStates[] memory, uint96[] memory) {
        super.implementcall(2);
    }

    
    function OwnerGetSeekInfo() external readonly returns (uint, uint, uint, uint, uint) {
        super.implementcall(2);
    }

    
    function OwnerGetOrder(QueueName, uint) external readonly returns (OrderInterface) {
        super.implementcall(2);
    }

    function OwnerGetOrderList(QueueName, uint, uint) external readonly returns (OrderInterface[] memory, uint[] memory, uint[] memory) {
        super.implementcall(2);
    }

    function OwnerUpdateOrdersTime(OrderInterface[] calldata, uint) external readwrite {
        super.implementcall(2);
    }

    
    
    function ImportLinkedOrder(address, uint, address, uint, OrderInterface.OrderType) external readwrite {
        super.implementcall(2);
    }

    function ImportOrder(address, uint, OrderInterface.OrderStates, bool) external readwrite returns (OrderInterface) {
        super.implementcall(2);
    }

    function ForceGetAndToHelp() external {
        super.implementcall(2);
    }

    function () external payable {

    }
}
