pragma solidity >=0.4.22 <0.7.0;

library Times {

    function Now() public view returns (uint) {
        
        return now;
    }

    function OneDay() public pure returns (uint256) {
        return 1 days;
    }

    function OneMonth() public pure returns (uint256) {
        return 30 * OneDay();
    }

    
    function TodayZeroGMT8() public view returns (uint256) {
        return Now() / OneDay() * OneDay();
    }

    function DayZeroGMT8(uint gmtTime) public pure returns (uint256) {
        
        return gmtTime / OneDay() * OneDay();
    }

}
