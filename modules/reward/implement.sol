pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract RewardImpl is RewardState {

    modifier ControllerOnly {
        require( _CTL == ControllerDelegate(msg.sender), "InvalidOperation");
        _;
    }

    function RewardInfo(address owner) external returns (uint rewardAmount, uint totalDeposit, uint totalRewardedAmount) {

        DepositedInfo memory info = rewardMapping[owner];

        return (info.rewardAmount, info.totalDeposit, info.totalRewardedAmount);
    }

    
    function CTL_ClearHistoryDelegate(address breaker) external ControllerOnly {
        delete rewardMapping[breaker];
    }

    
    function CTL_AddReward(address owner, uint amount, CounterModulesInterface.AwardType atype) external ControllerOnly {

        rewardMapping[owner].rewardAmount += amount;

        emit Log_Award(owner, atype, now, amount);
    }

    
    function CTL_CreatedOrderDelegate(address owner, uint amount) external ControllerOnly {
        rewardMapping[owner].totalDeposit += (amount / 2);
    }

    
    function CTL_CreatedAwardOrderDelegate(address owner, uint amount) external ControllerOnly returns (bool) {

        DepositedInfo storage info = rewardMapping[owner];

        
        if ( info.totalRewardedAmount + amount > info.totalDeposit ) {
            return false;
        }

        if ( info.rewardAmount >= amount ) {
            info.rewardAmount -= amount;
            info.totalRewardedAmount += amount;
            return true;
        }

        return false;
    }

    function Import(address sender, uint rewardAmount, uint totalRewardedAmount, uint totalDeposit ) external KOwnerOnly {
        rewardMapping[sender].rewardAmount = rewardAmount;
        rewardMapping[sender].totalRewardedAmount = totalRewardedAmount;
        rewardMapping[sender].totalDeposit = totalDeposit;
    }

}
