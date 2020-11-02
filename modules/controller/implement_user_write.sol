pragma solidity >=0.5.1 <0.7.0;

import "./implement.sol";

import "./plugins/OrderRelations.sol";

contract ControllerUserWriteImpl is ControllerImpl {

    using OrderArrExt for OrderInterface[];
    using OrderManager for OrderManager.MainStruct;

    modifier RejectBreaker() {
        require( blackList[msg.sender] == false); _;
    }

    
    modifier Pauseable() {
        require( astAwardInterface.pauseable() == false ); _;
    }

    
    function CreateOrder(uint total, uint amount) external RejectBreaker Pauseable returns (CreateOrderError code) {

        bool isNewPlayer = !_orderManager.ordersOf(msg.sender).isNotEmpty();

        
        require( relationInterface.GetIntroducer(msg.sender) != address(0x0) );

        
        require( depositedLimitMapping[now / 1 days * 1 days] + total <= configInterface.DepositedUSDMaxLimit() || isNewPlayer );

        
        if (
            total <= 0 ||
            total < amount ||
            total > configInterface.OrderAmountMaxLimit() ||
            
            total % configInterface.OrderAmountGranularity() != 0 ||
            
            
            total > ( _orderManager.ordersOf(msg.sender).length + 1) * configInterface.OrderAmountAppendQuota()

        ) {
            return CreateOrderError.InvaildParams;
        }


        if ( total < configInterface.OrderAmountMinLimit() ) {
            return CreateOrderError.LessThanMinimumLimit;
        }


        if ( amount < total * configInterface.OrderPaymentedMinPart() / 1 szabo ) {
            return CreateOrderError.LessThanMinimumPaymentPart;
        }

        
        if ( !isNewPlayer ) {

            OrderInterface latestOrder = _orderManager.ordersOf(msg.sender).latest();

            

            if ( !(now - latestOrder.times(uint8(OrderInterface.TimeType.OnCreated)) >= configInterface.OrderCreateInterval() )) {
                return CreateOrderError.LessThanOrderCreateInterval;
            }

            
            if ( latestOrder.totalAmount() >= 1000 * 10 ** 6 ) {

                if ( total < latestOrder.totalAmount() ) {
                    return CreateOrderError.LessThanFrontOrder;
                }
            } else {

                if ( total <= latestOrder.totalAmount()) {
                    return CreateOrderError.LessThanFrontOrder;
                }
            }

            
            latestOrder.CTL_SetNextOrderVaild();

            

        }

        
        
        OrderRelationsPlugins(0x7ee97eA2df12e16B20d557AeE902263554581736).createdOrderDelegate(msg.sender);

        
        if ( !isNewPlayer ) {
            depositedLimitMapping[now / 1 days * 1 days] += total;
        }

        
        uint divisor = 1;
        {
            (uint tin, uint tout) = phoenixInterface.GetInoutTotalInfo(msg.sender);
            if ( tout > tin ) {

                
                uint principal = 0;

                OrderInterface [] memory orders = _orderManager.ordersOf(msg.sender);
                for ( uint i = orders.length - 1; i >= 0; i-- ) {

                    
                    if ( uint(orders[i].orderState()) < 7 ) {
                        principal += orders[i].totalAmount();
                    }

                    if ( i == 0 ) {
                        break;
                    }
                }

                uint p = (tout - tin + principal) / principal;
                
                
                
                if ( p >= 1 && p < 2 ) {
                    
                    divisor = 2;
                } else if ( p >= 2 && p < 4 ) {
                    
                    divisor = 4;
                } else if ( p >= 4) {
                    
                    divisor = 8;
                }
            }
        }

        
        Order o = new Order(
            msg.sender,
            OrderInterface.OrderType.PHGH,
            _orderManager.ordersOf(msg.sender).length,
            total,
            
            divisor,
            ERC20Interface(address(usdtInterface)),
            configInterface,
            counterInterface,
            _KHost
        );

        
        _orderManager.pushOrder(msg.sender, o);

        
        usdtInterface.operatorSend(msg.sender, address(o), amount, "", "");

        
        o.OrderStateCheck();

        
        rewardInterface.CTL_CreatedOrderDelegate(msg.sender, total);

        return CreateOrderError.NoError;
    }

    
    
    
    
    function CreateDefragmentationOrder(uint l) external RejectBreaker Pauseable returns (uint) {

        uint pseek = _orderManager._producerSeek;
        uint totalAmount = 0;

        
        for ( uint i = 0; pseek < _orderManager._producerOrders.length && i < l; (pseek++, i++) ) {

            OrderInterface producer = _orderManager._producerOrders[pseek];

            uint producerBalance = _orderManager.usdtInterface.balanceOf( address(producer) );

            if ( producerBalance > 0 ) {
                totalAmount += producerBalance;
            }
        }

        
        pseek = _orderManager._producerSeek;

        
        
        Order o = new Order(
            address(this),
            OrderInterface.OrderType.OnlyPH,
            0,
            totalAmount,
            1.00 szabo,
            ERC20Interface(address(usdtInterface)),
            configInterface,
            counterInterface,
            _KHost
        );

        for ( uint i = 0; pseek < _orderManager._producerOrders.length && i < l; (pseek++, i++) ) {

            OrderInterface producer = _orderManager._producerOrders[pseek];

            uint producerBalance = _orderManager.usdtInterface.balanceOf( address(producer) );

            if ( producerBalance > 0 ) {
                producer.CTL_ToHelp(o, producerBalance);
                o.CTL_GetHelpDelegate(producer, producerBalance);
            }

            
            
            
            _orderManager._producerSeek = (pseek + 1);
        }

        
        _orderManager.pushOrder(address(this), o);

        
        _orderManager.pushProducer(o);

        return totalAmount;
    }

    
    
    
    function CreateAwardOrder(uint amount) external payable RejectBreaker Pauseable returns (CreateOrderError code) {

        
        require( amount > 0 );

        
        require( amount % configInterface.OrderAmountGranularity() == 0);

        
        uint cost = amount * configInterface.WithdrawCostProp() / 1 szabo * configInterface.USDTToDTProp();

        
        require( msg.value >= cost );

        
        require( _safeSendEther(address(0), msg.value) );

        
        
        require( rewardInterface.CTL_CreatedAwardOrderDelegate(msg.sender, amount), "InsufficientQuota" );

        
        Order o = new Order(
            msg.sender,
            OrderInterface.OrderType.OnlyGH,
            0,
            amount,
            0,
            ERC20Interface(address(usdtInterface)),
            configInterface,
            counterInterface,
            _KHost
        );

        
        _orderManager.pushAwardOrder(msg.sender, o);

        
        _orderManager.getAndToHelp();

        return CreateOrderError.NoError;
    }
}
