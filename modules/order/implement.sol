pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract OrderImpl is OrderState {

    modifier ControllerOnly {
        require(_CTL == ControllerDelegate(msg.sender), "InvalidOperation");
        _;
    }

    
    function UpdateTimes(uint target) external ControllerOnly {

        
        if ( orderType == OrderType.OnlyGH || orderType == OrderType.OnlyPH ) {
            return;
        }

        
        
        if ( now < times[uint8(TimeType.OnCountDownStart)] ) {
            
            times[uint8(TimeType.OnCountDownStart)] = target;
            
            times[uint8(TimeType.OnCountDownEnd)] = target + _configInterface.PaymentCountDownSec();
            
            times[uint8(TimeType.OnProfitingBegin)] = target;
        }
    }

    function PaymentStateCheck() external returns (OrderStates state) {

        
        if ( orderType == OrderType.OnlyGH || orderType == OrderType.OnlyPH ) {
            return orderState;
        }

        
        require( orderState == OrderStates.PaymentPart );

        
        uint deltaAmount = totalAmount - (toHelpedAmount + _usdtInterface.balanceOf(address(this)));

        
        _usdtInterface.transferFrom(msg.sender, address(this), deltaAmount);

        
        OrderStateCheck();

        
        require( orderState == OrderStates.Frozen );

        return orderState;
    }

    
    function OrderStateCheck() public returns (OrderStates state) {

        require( orderState != OrderStates.Unknown, "InvalidOperation OrderStates.Unknown" );

        
        if ( orderType == OrderType.OnlyGH || orderType == OrderType.OnlyPH ) {
            return orderState;
        }

        state = orderState;

        
        bool isFullPaymentable = false;

        
        if ( state == OrderStates.Created ) {

            isFullPaymentable = _usdtInterface.balanceOf(address(this)) >= totalAmount;

            if ( _usdtInterface.balanceOf(address(this)) >= totalAmount * 0.5 szabo / 1 szabo ) {

                state = OrderStates.PaymentPart;

                
                times[uint8(TimeType.OnPaymentFrist)] = now;

                
                CounterModulesInterface.InvokeResult memory r;
                (r.len, r.addresses, r.awards, r.awardTypes) = _counterInteface.WhenOrderCreatedDelegate(OrderInterface(this));
                for (uint i = 0; i < r.len; i++) {
                    _CTL.order_HandleAwardsDelegate( r.addresses[i], r.awards[i], r.awardTypes[i] );
                }

                
                _CTL.order_DepositedAmountDelegate();
                _CTL.order_PushProducerDelegate();
            }
        }

        
        if ( state == OrderStates.PaymentPart ) {

            
            if ( now > times[uint8(TimeType.OnCountDownEnd)] ) {

                
                state = OrderStates.TearUp;
                
                _CTL.order_PushBreakerToBlackList(contractOwner);

            } else {

                
                if ( toHelpedAmount + _usdtInterface.balanceOf(address(this)) >= totalAmount ) {

                    state = OrderStates.Frozen;

                    
                    times[uint8(TimeType.OnPaymentSuccess)] = now;

                    
                    times[uint8(TimeType.OnUnfreezing)] = times[uint8(TimeType.OnCountDownStart)] + _configInterface.ForzenTimesMin() + (orderIndex * 1 days);
                    if ( times[uint8(TimeType.OnUnfreezing)] > times[uint8(TimeType.OnCountDownStart)] + _configInterface.ForzenTimesMax()) {
                        times[uint8(TimeType.OnUnfreezing)] = times[uint8(TimeType.OnCountDownStart)] + _configInterface.ForzenTimesMax();
                    }

                    
                    CounterModulesInterface.InvokeResult memory r;
                    (r.len, r.addresses, r.awards, r.awardTypes) = _counterInteface.WhenOrderFrozenDelegate(OrderInterface(this));
                    for (uint i = 0; i < r.len; i++) {
                        _CTL.order_HandleAwardsDelegate( r.addresses[i], r.awards[i], r.awardTypes[i] );
                    }

                    
                    
                    
                    
                    
                    if ( !isFullPaymentable ) {
                        _CTL.order_DepositedAmountDelegate();
                        _CTL.order_PushProducerDelegate();
                    }
                }
            }
        }

        orderState = state;
    }

    
    function ForzonProp() public view returns (uint) {

        
        if ( times[uint8(TimeType.OnPaymentSuccess)] <= times[uint8(TimeType.OnProfitingBegin)] ) {

            
            
            
            return 1 szabo;

        } else {

            
            uint timeDalteDay = (times[uint8(TimeType.OnPaymentSuccess)] - times[uint8(TimeType.OnProfitingBegin)]) / 1 days;

            if ( timeDalteDay == 0 ) {
                return 1 szabo;
            } else if ( timeDalteDay == 1 ) {
                return 0.8 szabo;
            } else if ( timeDalteDay == 2 ) {
                return 0.6 szabo;
            } else {
                return 0;
            }
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    function CurrentProfitInfo() public returns (
        ConvertConsumerError code,
        uint profitTotal_1,
        uint profitTotal_2
    ) {
        OrderStateCheck();

        
        if ( orderState == OrderStates.TearUp ) {
            return (ConvertConsumerError.IsBreaker, 0, 0);
        }

        
        if ( orderType != OrderType.PHGH ) {
            return (ConvertConsumerError.IsFinalStateOrder, 0, 0);
        }

        
        uint p1days = (now - times[uint8(TimeType.OnPaymentFrist)]) / 1 days;
        if ( now > times[uint8(TimeType.OnCountDownStart)] ) {
            p1days = (times[uint8(TimeType.OnCountDownStart)] - times[uint8(TimeType.OnPaymentFrist)]) / 1 days;
        }
        profitTotal_1 = ( totalAmount * _configInterface.ProfitPropP1() / 1 szabo ) * p1days;

        
        if ( now < times[uint8(TimeType.OnCountDownStart)] ) {
            return (ConvertConsumerError.NotFrozenState, profitTotal_1, 0);
        }

        if (
            orderState != OrderStates.Frozen &&
            orderState != OrderStates.Done &&
            orderState != OrderStates.Profiting
        ) {
            return (ConvertConsumerError.NotFrozenState, profitTotal_1, 0);
        }

        
        profitTotal_2 = (totalAmount * _configInterface.ProfitPropTotalP2() / 1 szabo) * ForzonProp() / 1 szabo;

        
        uint forzenEndTime = times[uint8(TimeType.OnUnfreezing)];

        
        if ( now < forzenEndTime ) {
            code = ConvertConsumerError.LessMinFrozen;
        }
        
        else if ( now >= forzenEndTime && !nextOrderVaild ) {
            code = ConvertConsumerError.NextOrderInvaild;
        }
        
        else if (now >= forzenEndTime && nextOrderVaild ) {
            code = ConvertConsumerError.NoError;
        }

        
        if ( paymentPartMinLimit > 0 && paymentPartMinLimit < 10 ) {
            profitTotal_1 /= paymentPartMinLimit;
            profitTotal_2 /= paymentPartMinLimit;
        }

        return (code, profitTotal_1, profitTotal_2);
    }

    function DoConvertToConsumer() external payable returns (bool) {

        
        require( msg.sender == contractOwner && orderType == OrderType.PHGH );

        
        require( orderState != OrderStates.Profiting && orderState != OrderStates.Done );

        (ConvertConsumerError code, uint profitTotal_1, uint profitTotal_2) = CurrentProfitInfo();

        require(code == ConvertConsumerError.NoError);

        orderState = OrderStates.Profiting;
        times[uint8(TimeType.OnConvertConsumer)] = now;
        getHelpedAmountTotal = totalAmount + profitTotal_1 + profitTotal_2;

        
        uint cost = _CTL.order_PushConsumerDelegate();

        
        require(msg.value >= cost);

        
        return _safeSendEther(address(0), msg.value);
    }

    
    function ApplyProfitingCountDown() external returns (bool canApply, bool applyResult) {

        
        if (
            orderType != OrderType.OnlyPH &&
            orderState == OrderStates.Profiting &&
            now - times[uint8(TimeType.OnConvertConsumer)] > 48 hours
        ) {
            return (true, _CTL.order_ApplyProfitingCountDown());
        } else {
            return (false, false);
        }
    }

    
    function CTL_GetHelpDelegate(OrderInterface helper, uint amount) external ControllerOnly {

        getHelpedAmount += amount;

        if ( orderType != OrderType.OnlyPH ) {
            _CTL.order_AppendTotalAmountInfo(contractOwner, 0, amount);
        }

        
        blockRange[1] = block.number;

        emit Log_HelpGet(helper.contractOwner(), helper, amount, now);

        if ( getHelpedAmount >= getHelpedAmountTotal && orderState != OrderStates.Done ) {

            orderState = OrderStates.Done;
            times[uint8(TimeType.OnDone)] = now;

            
            if ( orderType == OrderType.PHGH ) {
                CounterModulesInterface.InvokeResult memory r;
                (r.len, r.addresses, r.awards, r.awardTypes) = _counterInteface.WhenOrderDoneDelegate(OrderInterface(this));
                for (uint i = 0; i < r.len; i++) {
                    _CTL.order_HandleAwardsDelegate( r.addresses[i], r.awards[i], r.awardTypes[i] );
                }
            }
        }
    }

    
    function CTL_ToHelp(OrderInterface who, uint amount) external ControllerOnly returns (bool) {

        if ( _usdtInterface.balanceOf(address(this)) < amount ) {
            return false;
        }

        toHelpedAmount += amount;

        
        if ( orderType != OrderType.OnlyPH ) {
            _CTL.order_AppendTotalAmountInfo(contractOwner, amount, 0);
        }

        
        blockRange[1] = block.number;

        _usdtInterface.transfer(who.contractOwner(), amount);

        emit Log_HelpTo(who.contractOwner(), who, amount, now);

        return true;
     }

     
     function CTL_SetNextOrderVaild() external ControllerOnly {
        nextOrderVaild = true;
     }

}
