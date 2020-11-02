pragma solidity >=0.5.1 <0.7.0;

import "../../core/KContract.sol";

import "../controller/interface.sol";

import "./interface.sol";

contract RewardState is RewardInterface, KState(0x4c4465d6) {
    
    ControllerDelegate internal _CTL;
    
    mapping(address => DepositedInfo) public rewardMapping;
}
