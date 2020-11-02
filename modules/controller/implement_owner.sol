pragma solidity >=0.5.1 <0.7.0;

import "./implement.sol";

import "../order/link_impl.sol";

contract ControllerOwnerImpl is ControllerImpl {

    using OrderArrExt for OrderInterface[];
    using OrderManager for OrderManager.MainStruct;

    
    
    
    
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
    ) {
        OrderInterface[] memory source;

        
        if ( orderType == OrderInterface.OrderType.PHGH ) {
            source = _orderManager.ordersOf(owner);
        } else if ( orderType == OrderInterface.OrderType.OnlyGH ) {
            source = _orderManager.awardOrdersOf(owner);
        } else if ( orderType == OrderInterface.OrderType.OnlyPH ) {
            source = _orderManager.ordersOf(address(this));
        } else {
            source = _orderManager.ordersOf(owner);
        }

        
        require( offset < source.length );

        
        
        
        
        
        
        
        
        
        
        
        
        for ( uint i = 0; i < source.length; i++ ) {
            if ( uint(source[i].orderState()) <= 0 ) {
                continue;
            }

            
            uint bcode = 1 << (uint(source[i].orderState()) - 1);
            if ( orderState & bcode == bcode  ) {
                ++total;
            }
        }

        
        if ( offset + size > source.length - 1 ) {
            len = source.length - offset;
        } else {
            len = size;
        }

        
        orders = new OrderInterface[](len);
        totalAmounts = new uint[](len);
        states = new OrderInterface.OrderStates[](len);
        times = new uint96[](len);

        for (
            (uint s, uint i) = (0, offset);
            i < offset + len;
            (s++, i++)
        ) {
            if ( uint(source[i].orderState()) <= 0 ) {
                continue;
            }

            
            uint bcode = 1 << (uint(source[i].orderState()) - 1);
            if ( orderState & bcode == bcode  ) {
                orders[s] = source[i];
                totalAmounts[s] = source[i].totalAmount();
                states[s] = source[i].orderState();

                times[s] |= (uint96(source[i].times(uint8(OrderInterface.TimeType.OnCreated))) << 64);
                times[s] |= (uint96(source[i].times(uint8(OrderInterface.TimeType.OnCountDownStart))) << 32);
                times[s] |= (uint96(source[i].times(uint8(OrderInterface.TimeType.OnUnfreezing))));
            }
        }
    }

    function OwnerGetSeekInfo() external KOwnerOnly returns (uint total, uint ptotal, uint ctotal, uint pseek, uint cseek) {
        return (
            _orderManager._orders.length,
            _orderManager._producerOrders.length,
            _orderManager._consumerOrders.length,
            _orderManager._producerSeek,
            _orderManager._consumerSeek
        );
    }

    
    function OwnerGetOrder(QueueName qname, uint seek) external KOwnerOnly returns (OrderInterface) {
        if ( qname == QueueName.Producer ) {
            return _orderManager._producerOrders[seek];
        } else if ( qname == QueueName.Consumer ) {
            return _orderManager._consumerOrders[seek];
        } else if ( qname == QueueName.Main ) {
            return _orderManager._orders[seek];
        }
        return OrderInterface(0x0);
    }

    
    function OwnerGetOrderList(QueueName qname, uint offset, uint size) external KOwnerOnly
    returns (
        
        OrderInterface[] memory orders,
        
        uint[] memory times,
        
        uint[] memory totalAmounts
    ) {
        OrderInterface[] memory source;

        
        if ( qname == QueueName.Producer ) {
            source = _orderManager._producerOrders;
        } else if ( qname == QueueName.Consumer ) {
            source = _orderManager._consumerOrders;
        } else if ( qname == QueueName.Main ) {
            source = _orderManager._orders;
        }

        orders = new OrderInterface[](size);
        times = new uint[](size);
        totalAmounts = new uint[](size);

        for (
            (uint i, uint j) = (0, offset);
            j < offset + size && j < source.length;
            (j++, i++)
        ) {
            orders[i] = source[j];
            totalAmounts[i] = source[j].totalAmount();
            times[i] = source[j].times( uint8(OrderInterface.TimeType.OnCountDownStart));
        }
    }

    
    function OwnerUpdateOrdersTime(OrderInterface[] calldata orders, uint targetTimes) external KOwnerOnly {
        for (uint i = 0; i < orders.length; i++) {
            orders[i].UpdateTimes(targetTimes);
        }
    }

    function ImportLinkedOrder(
        address owner,
        uint amount,
        address targetContractAddress,
        uint ctime,
        OrderInterface.OrderType orderType
    ) external KOwnerOnly {

        OrderLink o = new OrderLink(
            targetContractAddress,
            amount,
            ctime,
            orderType
        );

        if ( orderType == OrderInterface.OrderType.PHGH ) {
            _orderManager.pushOrder(owner, OrderInterface(o));
        } else {
            _orderManager.pushAwardOrder(owner, OrderInterface(o));
        }
    }

    
    function ForceGetAndToHelp() external KOwnerOnly {
        _orderManager.getAndToHelp();
    }

    function ImportOrder(address sender, uint total, OrderInterface.OrderStates state, bool isProducer ) external KOwnerOnly returns (OrderInterface) {
        
        Order o = new Order(
            sender,
            OrderInterface.OrderType.PHGH,
            _orderManager.ordersOf(sender).length,
            total,
            0.5 szabo,
            ERC20Interface(address(usdtInterface)),
            configInterface,
            counterInterface,
            _KHost
        );

        
        _orderManager.pushOrder(sender, o);

        
        o.OrderStateCheck();

        
        if ( state == OrderInterface.OrderStates.Profiting ) {
            _orderManager.pushConsumer(o);
        }

        
        if ( isProducer ) {
            _orderManager.pushProducer(o);
        }

        return o;
    }
}
