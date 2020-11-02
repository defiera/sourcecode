pragma solidity >=0.5.1 <0.7.0;

import "../../order/interface.sol";
import "../../../core/interface/ERC777Interface.sol";

library OrderManager {

    using OrderManager for OrderManager.MainStruct;

    struct MainStruct {

        
        OrderInterface[] _orders;

        
        OrderInterface[] _producerOrders;
        
        uint _producerSeek;

        
        OrderInterface[] _consumerOrders;
        
        uint _consumerSeek;

        
        mapping(address => OrderInterface[]) _ownerOrdersMapping;

        
        mapping(address => OrderInterface[]) _ownerAwardOrdersMapping;

        
        mapping(address => bool) _orderExistsMapping;

        ERC777Interface usdtInterface;
    }

    function init(MainStruct storage self, ERC777Interface usdtInc) internal {
        self.usdtInterface = usdtInc;
    }

    function clearHistory(MainStruct storage self, address owner) internal {

        
        OrderInterface[] storage orders = self._ownerOrdersMapping[owner];
        for ( uint i = 0; i < orders.length; i++ ) {
            delete orders[i];
        }
        orders.length = 0;

        
        OrderInterface[] storage awardOrders = self._ownerAwardOrdersMapping[owner];
        for ( uint i = 0; i < awardOrders.length; i++ ) {
            delete awardOrders[i];
        }
        awardOrders.length = 0;
    }

    
    function pushAwardOrder(MainStruct storage self, address owner, OrderInterface order ) internal {

        self._orders.push(order);

        self._ownerAwardOrdersMapping[owner].push(order);

        
        self._consumerOrders.push(order);

        
        self._orderExistsMapping[address(order)] = true;
    }

    
    function pushOrder(MainStruct storage self, address owner, OrderInterface order ) internal {

        self._orders.push(order);

        self._ownerOrdersMapping[owner].push(order);

        
        self._orderExistsMapping[address(order)] = true;
    }

    
    function ordersOf(MainStruct storage self, address owner) internal view returns (OrderInterface[] storage) {
        return self._ownerOrdersMapping[owner];
    }

    function awardOrdersOf(MainStruct storage self, address owner) internal view returns (OrderInterface[] storage) {
        return self._ownerAwardOrdersMapping[owner];
    }

    
    function isExistOrder(MainStruct storage self, OrderInterface order) internal view returns (bool) {
        return self._orderExistsMapping[address(order)];
    }

    
    function pushProducer(MainStruct storage self, OrderInterface order ) internal {
        require( self.isExistOrder(order), "InvalidOperation" );
        self._producerOrders.push(order);
    }

    
    function pushConsumer(MainStruct storage self, OrderInterface order ) internal {
        require( self.isExistOrder(order), "InvalidOperation" );
        self._consumerOrders.push(order);
    }

    
    function currentConsumer(MainStruct storage self) internal view returns (OrderInterface) {

        
        if ( self._consumerSeek < self._consumerOrders.length ) {
            return self._consumerOrders[self._consumerSeek];
        }
        return OrderInterface(0x0);
    }

    
    function getAndToHelp(MainStruct storage self) internal {

        uint pseek = self._producerSeek;
        uint cseek = self._consumerSeek;

        for ( ; cseek < self._consumerOrders.length; cseek++ ) {

            
            OrderInterface consumerOrder = self._consumerOrders[cseek];

            
            
            
            
            
            if (
                consumerOrder.getHelpedAmount() >= consumerOrder.getHelpedAmountTotal() ||
                consumerOrder.orderState() != OrderInterface.OrderStates.Profiting
            ) {
                self._consumerSeek = (cseek + 1);
                continue;
            }

            uint consumerDalte = consumerOrder.getHelpedAmountTotal() - consumerOrder.getHelpedAmount();

            for ( ; pseek < self._producerOrders.length; pseek++ ) {

                OrderInterface producer = self._producerOrders[pseek];

                uint producerBalance = self.usdtInterface.balanceOf( address(producer) );

                
                if ( producerBalance <= 0 ) {
                    self._producerSeek = pseek;
                    continue;
                }
                
                else if ( producerBalance > consumerDalte ) {

                    
                    producer.CTL_ToHelp(consumerOrder, consumerDalte);
                    consumerOrder.CTL_GetHelpDelegate(producer, consumerDalte);

                    
                    
                    consumerDalte = 0;

                    break; 
                }
                
                else if ( producerBalance < consumerDalte ) {

                    
                    producer.CTL_ToHelp(consumerOrder, producerBalance);
                    consumerOrder.CTL_GetHelpDelegate(producer, producerBalance);
                    consumerDalte -= producerBalance;

                    
                    continue; 
                }
                
                else {

                    
                    producer.CTL_ToHelp(consumerOrder, producerBalance);
                    consumerOrder.CTL_GetHelpDelegate(producer, producerBalance);

                    
                    
                    

                    
                    ++pseek; break; 
                }
            }

            
            if ( consumerOrder.orderState() == OrderInterface.OrderStates.Done ) {
                self._consumerSeek = (cseek + 1);
            }
        }
    }
}
