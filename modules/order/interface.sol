pragma solidity >=0.5.1 <0.7.0;

interface OrderInterface {

    
    event Log_HelpTo(address indexed owner, OrderInterface indexed order, uint amount, uint time);

    
    event Log_HelpGet(address indexed other, OrderInterface indexed order, uint amount, uint time);

    
    enum OrderType {
        
        PHGH,
        
        OnlyPH,
        
        OnlyGH,
        
        Linked
    }

    enum OrderStates {
        
        Unknown,
        
        Created,
        
        PaymentPart,
        
        PaymentCountDown,
        
        TearUp,
        
        Frozen,
        
        Profiting,
        
        Done
    }

    enum TimeType {
        
        OnCreated,
        
        OnPaymentFrist,
        
        OnPaymentSuccess,
        
        OnProfitingBegin,
        
        OnCountDownStart,
        
        OnCountDownEnd,
        
        OnConvertConsumer,
        
        OnUnfreezing,
        
        OnDone
    }

    enum ConvertConsumerError {
        
        Unkown,
        
        NoError,
        
        NotFrozenState,
        
        LessMinFrozen,
        
        NextOrderInvaild,
        
        IsBreaker,
        
        IsFinalStateOrder
    }

    
    
    
    
    function times(uint8) external view returns (uint);

    
    function totalAmount() external view returns (uint);

    
    function toHelpedAmount() external view returns (uint);

    
    function getHelpedAmount() external view returns (uint);

    
    function getHelpedAmountTotal() external view returns (uint);

    
    function paymentPartMinLimit() external view returns (uint);

    
    function orderState() external view returns (OrderStates state);

    
    function contractOwner() external view returns (address);

    
    function orderIndex() external view returns (uint);

    
    function orderType() external view returns (OrderType);

    
    function isLink() external view returns (bool);

    
    function linkedOrderAddress() external view returns (address);

    
    function blockRange(uint t) external view returns (uint);

    
    
    

    
    function CurrentProfitInfo() external returns (OrderInterface.ConvertConsumerError, uint, uint);

    
    
    
    
    function ApplyProfitingCountDown() external returns (bool canApply, bool applyResult);

    
    function DoConvertToConsumer() external payable returns (bool);

    
    function UpdateTimes(uint target) external;

    
    function PaymentStateCheck() external returns (OrderStates state);

    
    function OrderStateCheck() external returns (OrderStates state);

    
    function CTL_GetHelpDelegate(OrderInterface helper, uint amount) external;

    
    function CTL_ToHelp(OrderInterface who, uint amount) external returns (bool);

    
    function CTL_SetNextOrderVaild() external;
}
