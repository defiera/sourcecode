pragma solidity >=0.5.1 <0.7.0;

contract Hosts {

    address public owner;

    mapping(uint => mapping(uint => address)) internal impls;

    mapping(uint => uint) internal time;

    constructor() public {
        owner = msg.sender;
    }

    modifier restricted() {
        if (msg.sender == owner) _;
    }

    function latestTime(uint CIDXX) external view restricted returns (uint) {
        return time[CIDXX];
    }

    function setImplement(uint CIDXX, address implementer) external restricted {

        time[uint(CIDXX)] = now;

        impls[uint(CIDXX)][0] = implementer;
    }

    function setImplementSub(uint CIDXX, uint idx, address implementer) external restricted {
        time[uint(CIDXX)] = now;
        impls[uint(CIDXX)][idx] = implementer;
    }

    function getImplement(uint CIDXX) external view returns (address) {
        return impls[uint(CIDXX)][0];
    }

    function getImplementSub(uint CIDXX, uint idx) external view returns (address) {
        return impls[uint(CIDXX)][idx];
    }

}
