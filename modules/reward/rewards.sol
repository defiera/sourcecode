pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract Reward is RewardState, KContract {

    constructor(Hosts host) public {
        _KHost = host;
    }

    
    function OWNER_SetCTL(ControllerDelegate ctl) external KOwnerOnly {
        _CTL = ctl;
    }

    function RewardInfo(address) external readonly returns (uint, uint, uint) {
        super.implementcall();
    }

    
    function CTL_ClearHistoryDelegate(address) external readwrite {
        super.implementcall();
    }

    
    function CTL_AddReward(address, uint, CounterModulesInterface.AwardType) external readwrite {
        super.implementcall();
    }

    
    function CTL_CreatedOrderDelegate(address, uint) external readwrite {
        super.implementcall();
    }

    
    function CTL_CreatedAwardOrderDelegate(address, uint) external readwrite returns (bool) {
        super.implementcall();
    }

    function Import(address, uint, uint, uint) external {
        super.implementcall();
    }
}
