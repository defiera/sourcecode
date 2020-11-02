pragma solidity >=0.5.1 <0.7.0;

import "./implement.sol";

contract ControllerUserReadImpl is ControllerImpl {

    using OrderArrExt for OrderInterface[];
    using OrderManager for OrderManager.MainStruct;

    modifier RejectBreaker() {
        require( blackList[msg.sender] == false); _;
    }
    
    function GetOrder(address owner, uint index) external returns (
        uint total,
        uint id,
        OrderInterface order
    ) {
        if ( _orderManager.ordersOf(owner).length <= 0 ) {
            return (0, 0, OrderInterface(0x0));
        }
        return (
            _orderManager.ordersOf(owner).length,
            index,
            _orderManager.ordersOf(owner)[index]
        );
    }

    
    function GetAwardOrder(address owner, uint index) external returns (
        uint total,
        uint id,
        OrderInterface order
    ) {
        return (
            _orderManager.awardOrdersOf(owner).length,
            index,
            _orderManager.awardOrdersOf(owner)[index]
        );
    }

    
    function IsBreaker(address owner) external returns (bool) {

        if ( blackList[owner] ) {
            return true;
        }

        
        OrderInterface[] memory orderHistory = _orderManager.ordersOf(owner);

        for (uint i = 0; i < orderHistory.length; i++) {
            if ( orderHistory[i].orderState() == OrderInterface.OrderStates.PaymentPart ) {
                if ( now > orderHistory[i].times(uint8(OrderInterface.TimeType.OnCountDownEnd)) ) {
                    return true;
                }
            }
        }

        return false;
    }

    
    function ResolveBreaker() external payable {

        uint cost = configInterface.ResolveBreakerDTAmount();

        
        require( msg.value >= cost );

        
        require( _safeSendEther(address(0), msg.value) );

        
        _orderManager.clearHistory(msg.sender);

        
        rewardInterface.CTL_ClearHistoryDelegate(msg.sender);

        
        phoenixInterface.CTL_ClearHistoryDelegate(msg.sender);

        
        blackList[msg.sender] = false;
    }
}
