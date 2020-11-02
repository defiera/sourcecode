pragma solidity >=0.5.1 <0.7.0;

import "../../order/interface.sol";

interface AssertPoolAwardsInterface {

    struct LuckyDog {
        uint award;
        uint time;
        bool canwithdraw;
    }

    
    event Log_Luckdog(address indexed who, uint indexed awardsTotal);

    
    function pauseable() external returns (bool);

    
    function IsLuckDog(address owner) external returns (bool isluckDog, uint award, bool canwithdrawable);

    
    function WithdrawLuckAward() external returns ( uint award );

    
    function CTL_InvestQueueAppend(OrderInterface o) external;

    
    function CTL_CountDownApplyBegin() external returns (bool);

    
    function CTL_CountDownStop() external returns (bool);

    
    function OwnerDistributeAwards() external;

    
    function SetCountdownTime(uint time) external;
    
    function SetAdditionalAmountMin(uint min) external;
    
    function SetAdditionalTime(uint time) external;
    
    function SetLuckyDoyTotalCount(uint count) external;
    
    function SetDefualtProp(uint multi) external;
    
    function SetPropMaxLimit(uint limit) external;
    
    function SetSpecialProp(uint n, uint p) external;
    
    function SetSpecialPropMaxLimit(uint n, uint p) external;

}
