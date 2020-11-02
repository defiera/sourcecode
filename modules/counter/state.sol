pragma solidity >=0.5.1 <0.7.0;

import "../../core/KContract.sol";

import "../controller/interface.sol";
import "../relationship/interface.sol";

import "./interface.sol";

contract CounterState is CounterModulesInterface, KState(0x20c16688) {
    
    
    CounterModulesInterface[] public submodules;

    
    ControllerDelegate _CTL;
}
