pragma solidity >=0.5.1 <0.7.0;

import "./implement.sol";

import "./plugins/OrderRelations.sol";

contract ControllerDelegateImpl is ControllerImpl {

    using OrderArrExt for OrderInterface[];
    using OrderManager for OrderManager.MainStruct;

    modifier RejectBreaker() {
        require( blackList[msg.sender] == false); _;
    }

    modifier OnlyOrders {
        require( _orderManager.isExistOrder( OrderInterface(msg.sender) )); _;
    }

    function _tryToStopCountDown() internal {
        OrderInterface currConsumer = _orderManager.currentConsumer();
        if ( currConsumer == OrderInterface(0x0) || now - currConsumer.times(uint8(OrderInterface.TimeType.OnConvertConsumer)) < 48 hours ) {
            astAwardInterface.CTL_CountDownStop();
        }
    }

    
    
    function order_PushProducerDelegate() external OnlyOrders {
        _orderManager.pushProducer(OrderInterface(msg.sender));
        _orderManager.getAndToHelp();
        _tryToStopCountDown();
    }

    
    function order_PushConsumerDelegate() external OnlyOrders returns (uint) {

        OrderInterface order = OrderInterface(msg.sender);

        _orderManager.pushConsumer(order);
        _orderManager.getAndToHelp();
        _tryToStopCountDown();

        if ( order.orderType() == OrderInterface.OrderType.PHGH ) {

            
            OrderRelationsPlugins p = OrderRelationsPlugins(0x7ee97eA2df12e16B20d557AeE902263554581736);

            
            require( p.canConvertConsumer(order.contractOwner()) );
            p.doConvertConsumerDelegate(order.contractOwner());

            
            return order.getHelpedAmountTotal() * configInterface.WithdrawCostProp() / 1 szabo * configInterface.USDTToDTProp();
        }

        return 0;
    }

    
    
    
    function order_HandleAwardsDelegate(address addr, uint award, CounterModulesInterface.AwardType atype) external OnlyOrders {

        if ( award <= 0 ) {
            return ;
        }

        
        if ( _orderManager.ordersOf(addr).isNotEmpty() ) {

            uint addrLatestOrderTotal = _orderManager.ordersOf(addr).latest().totalAmount();
            uint senderOrderTotal = OrderInterface(msg.sender).totalAmount();

            
            if ( senderOrderTotal <= 0 ) {
                return ;
            }

            
            if ( addrLatestOrderTotal >= senderOrderTotal || addrLatestOrderTotal >= 5000 * 10 ** 6 ) {
                return rewardInterface.CTL_AddReward(addr, award, atype);
            } else {
                return rewardInterface.CTL_AddReward(addr, award * addrLatestOrderTotal / senderOrderTotal, atype);
            }
        }
    }

    
    function order_PushBreakerToBlackList(address breakerAddress) external OnlyOrders {
        blackList[breakerAddress] = true;
    }

    
    function order_DepositedAmountDelegate() external OnlyOrders {
        astAwardInterface.CTL_InvestQueueAppend( OrderInterface(msg.sender) );
    }

    
    function order_ApplyProfitingCountDown() external OnlyOrders returns (bool) {
        return astAwardInterface.CTL_CountDownApplyBegin();
    }

    
    function order_AppendTotalAmountInfo(address owner, uint inAmount, uint outAmount) external OnlyOrders {
        phoenixInterface.CTL_AppendAmountInfo(owner, inAmount, outAmount);
    }

    function order_IsVaild(address order) external returns (bool) {
        return _orderManager.isExistOrder(OrderInterface(order));
    }
}
