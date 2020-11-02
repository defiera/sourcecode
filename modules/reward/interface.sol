pragma solidity >=0.5.1 <0.7.0;

import "../counter/interface.sol";

import "../controller/interface.sol";

interface RewardInterface {

    struct DepositedInfo {
        
        uint rewardAmount;
        
        uint totalDeposit;
        
        uint totalRewardedAmount;
    }

    
    event Log_Award(address indexed owner, CounterModulesInterface.AwardType indexed atype, uint time, uint amount );

    
    event Log_Withdrawable(address indexed owner, uint time, uint amount );

    
    function RewardInfo(address owner) external returns (uint rewardAmount, uint totalDeposit, uint totalRewardedAmount);

    
    function CTL_ClearHistoryDelegate(address breaker) external;

    
    function CTL_AddReward(address owner, uint amount, CounterModulesInterface.AwardType atype) external;

    
    function CTL_CreatedOrderDelegate(address owner, uint amount) external;

    
    function CTL_CreatedAwardOrderDelegate(address owner, uint amount) external returns (bool);

    function Import(address sender, uint rewardAmount, uint totalRewardedAmount, uint totalDeposit ) external;
}
