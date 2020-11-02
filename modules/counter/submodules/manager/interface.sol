pragma solidity >=0.5.1 <0.7.0;

interface CounterManagerInterface {

    
    function InfomationOf(address owner) external returns (
        
        bool isvaild,
        
        uint vaildMemberTotal,
        
        uint selfAchievements,
        
        uint dlevel
    );

    
    function UpgradeDLevel() external returns (uint origin, uint current);

    
    function PaymentDLevelOne() external returns (bool);

    
    function SetRecommendAwardProp(uint l, uint p) external;

    
    function SetDLevelAwardProp(uint dl, uint p) external;

    
    function SetDLevelSearchDepth(uint depth) external;

    
    function SetDlevel1DepositedNeed(uint need) external;

    
    function SetDLevel1Prices(uint prices) external;

    
    function ImportDLevel(
        address sender,
        uint8 lv,
        uint selfAchievement,
        uint vaildMemberTotal
    ) external;
}
