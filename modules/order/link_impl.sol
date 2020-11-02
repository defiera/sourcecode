pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract OrderLink is OrderState {

    constructor(
        address laddress,
        uint amount,
        uint ctime,
        OrderType ortype
    ) public {
        isLink = true;
        orderType = ortype;
        linkedOrderAddress = laddress;
        totalAmount = amount;
        orderState = OrderStates.Done;
        times[uint8(TimeType.OnCreated)] = ctime;

        _CTL = ControllerDelegate(msg.sender);
    }

    function CTL_SetNextOrderVaild() external {}

    function ForzonPropEveryDay() external returns (uint) {}

    function CurrentProfitInfo() external returns (OrderInterface.ConvertConsumerError, uint, uint) {}

    function DoConvertToConsumer() external payable returns (bool) {}

    function UpdateTimes(uint) external {}

    function PaymentStateCheck() external returns (OrderStates) {}

    function OrderStateCheck() external returns (OrderInterface.OrderStates) {}

    function ApplyProfitingCountDown() external returns (bool, bool) {}

    function CTL_GetHelpDelegate(OrderInterface, uint) external {}

    function CTL_ToHelp(OrderInterface, uint) external returns (bool) {}

    function () external payable {}
}
