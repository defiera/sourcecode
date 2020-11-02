pragma solidity >=0.5.1 <0.7.0;

interface ConfigInterface {

    enum Keys {
        
        WaitTime,
        
        PaymentCountDownSec,
        
        ForzenTimesMin,
        
        ForzenTimesMax,
        
        ProfitPropP1,
        
        ProfitPropTotalP2,
        
        OrderCreateInterval,
        
        OrderAmountAppendQuota,
        
        OrderAmountMinLimit,
        
        OrderAmountMaxLimit,
        
        OrderPaymentedMinPart,
        
        OrderAmountGranularity,
        
        WithdrawCostProp,
        
        USDTToDTProp,
        
        DepositedUSDMaxLimit,
        
        ResolveBreakerDTAmount
    }

    function GetConfigValue(Keys k) external view returns (uint);
    function SetConfigValue(Keys k, uint v) external;

    
    function WaitTime() external view returns (uint);

    
    function PaymentCountDownSec() external view returns (uint);

    
    function ForzenTimesMin() external view returns (uint);

    
    function ForzenTimesMax() external view returns (uint);

    
    function ProfitPropP1() external view returns (uint);

    
    function ProfitPropTotalP2() external view returns (uint);

    
    function OrderCreateInterval() external view returns (uint);

    
    function OrderAmountAppendQuota() external view returns (uint);

    
    function OrderAmountMinLimit() external view returns (uint);

    
    function OrderAmountMaxLimit() external view returns (uint);

    
    function OrderPaymentedMinPart() external view returns (uint);

    
    function OrderAmountGranularity() external view returns (uint);

    
    function WithdrawCostProp() external view returns (uint);

    
    function USDTToDTProp() external view returns (uint);

    
    function DepositedUSDMaxLimit() external view returns (uint);

    
    function ResolveBreakerDTAmount() external view returns (uint);
}
