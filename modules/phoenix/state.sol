pragma solidity >=0.5.1 <0.7.0;

import "../../core/KContract.sol";

import "../controller/interface.sol";
import "../assertpool/awards/interface.sol";
import "./interface.sol";

contract PhoenixState is PhoenixInterface, KState(0x4eb1d593) {

    
    mapping(uint => mapping(address => InoutTotal)) public inoutMapping;

    
    mapping(address => Compensate) public compensateMapping;

    
    
    uint public dataStateVersion = 0;

    
    uint public compensateRelaseProp = 0.01 szabo;

    
    uint public compensateProp = 1 * 10 ** 12;

    
    ControllerDelegate internal _CTL;

    
    AssertPoolAwardsInterface internal _ASTPoolAwards;
}
