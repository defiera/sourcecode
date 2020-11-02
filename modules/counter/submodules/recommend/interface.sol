pragma solidity >=0.5.1 <0.7.0;

interface CounterRecommendInterface {

    function SetAwardProp(uint p) external;

    
    function Import(address sender, bool isExisted) external;
}
