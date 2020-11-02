pragma solidity >=0.5.1 <0.7.0;

import "../../core/KContract.sol";
import "./interface.sol";

contract Config is ConfigInterface, KOwnerable {

    mapping(uint => uint) public configMapping;

    constructor() public {

        
        configMapping[uint(Keys.WaitTime)] = 5 days;

        
        configMapping[uint(Keys.PaymentCountDownSec)] = 72 hours;

        
        configMapping[uint(Keys.ForzenTimesMin)] = 7 days;

        
        configMapping[uint(Keys.ForzenTimesMax)] = 30 days;

        
        configMapping[uint(Keys.ProfitPropP1)] = 0.01 szabo;

        
        configMapping[uint(Keys.ProfitPropTotalP2)] = 0.1 szabo;

        
        configMapping[uint(Keys.OrderCreateInterval)] = 72 hours;

        
        configMapping[uint(Keys.OrderAmountAppendQuota)] = 2000 * 10 ** 6;

        
        configMapping[uint(Keys.OrderAmountMinLimit)] = 100 * 10 ** 6;

        
        configMapping[uint(Keys.OrderAmountMaxLimit)] = 10000 * 10 ** 6;

        
        configMapping[uint(Keys.OrderAmountGranularity)] = 10 * 10 ** 6;

        
        configMapping[uint(Keys.OrderPaymentedMinPart)] = 0.5 szabo;

        
        configMapping[uint(Keys.WithdrawCostProp)] = 0.02 szabo;

        
        
        
        
        
        configMapping[uint(Keys.USDTToDTProp)] = 20 * 10 ** 12;

        
        configMapping[uint(Keys.DepositedUSDMaxLimit)] = 30000 * 10 ** 6;

        
        configMapping[uint(Keys.ResolveBreakerDTAmount)] = 1000 ether;
    }

    function GetConfigValue(Keys k) external view returns (uint) {
        return configMapping[uint(k)];
    }

    function SetConfigValue(Keys k, uint v) external KOwnerOnly {
        configMapping[uint(k)] = v;
    }

    
    function WaitTime() external view returns (uint) {
        return configMapping[uint(Keys.WaitTime)];
    }

    
    function PaymentCountDownSec() external view returns (uint) {
        return configMapping[uint(Keys.PaymentCountDownSec)];
    }

    
    function ForzenTimesMin() external view returns (uint) {
        return configMapping[uint(Keys.ForzenTimesMin)];
    }

    
    function ForzenTimesMax() external view returns (uint) {
        return configMapping[uint(Keys.ForzenTimesMax)];
    }

    
    function ProfitPropP1() external view returns (uint) {
        return configMapping[uint(Keys.ProfitPropP1)];
    }

    
    function ProfitPropTotalP2() external view returns (uint) {
        return configMapping[uint(Keys.ProfitPropTotalP2)];
    }

    
    function OrderCreateInterval() external view returns (uint) {
        return configMapping[uint(Keys.OrderCreateInterval)];
    }

    
    function OrderAmountAppendQuota() external view returns (uint) {
        return configMapping[uint(Keys.OrderAmountAppendQuota)];
    }

    
    function OrderAmountMinLimit() external view returns (uint) {
        return configMapping[uint(Keys.OrderAmountMinLimit)];
    }

    
    function OrderAmountMaxLimit() external view returns (uint) {
        return configMapping[uint(Keys.OrderAmountMaxLimit)];
    }

    
    function OrderPaymentedMinPart() external view returns (uint) {
        return configMapping[uint(Keys.OrderPaymentedMinPart)];
    }

    
    function OrderAmountGranularity() external view returns (uint) {
        return configMapping[uint(Keys.OrderAmountGranularity)];
    }

    
    function WithdrawCostProp() external view returns (uint) {
        return configMapping[uint(Keys.WithdrawCostProp)];
    }

    
    function USDTToDTProp() external view returns (uint) {
        return configMapping[uint(Keys.USDTToDTProp)];
    }

    
    function DepositedUSDMaxLimit() external view returns (uint) {
        return configMapping[uint(Keys.DepositedUSDMaxLimit)];
    }

    
    function ResolveBreakerDTAmount() external view returns (uint) {
        return configMapping[uint(Keys.ResolveBreakerDTAmount)];
    }
}
