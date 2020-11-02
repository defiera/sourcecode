pragma solidity >=0.5.1 <0.7.0;

import "../../../core/interface/ERC777Interface.sol";
import "../../../core/KContract.sol";

import "../../controller/interface.sol";
import "../../order/interface.sol";
import "../../phoenix/interface.sol";

import "../interface.sol";
import "./interface.sol";

contract AssertPoolAwardsState is AssertPoolAwardsInterface, KState(0xd0affae8) {

    
    
    
    
    bool public isInCountdowning = false;

    
    uint public countdownTime = 36 hours;

    
    uint public additionalAmountMin = 100 * 10 ** 6;

    
    uint public additionalTime = 1800;

    
    uint public deadlineTime;

    
    bool public death = false;

    
    
    
    OrderInterface[] public investOrdersQueue;

    
    uint public luckyDoyTotalCount = 300;

    
    uint public defualtProp = 3;

    
    uint public propMaxLimit = 0.02 szabo;

    
    mapping(uint => uint) public specialRewardsDescMapping;

    
    mapping(uint => uint) public specialPropMaxlimitMapping;

    
    mapping(address => LuckyDog) public luckydogMapping;

    AssertPoolInterface internal apInterface;
    ControllerDelegate internal _CTL;
    ERC777Interface internal usdtInterface;
    PhoenixInterface internal phInterface;
}
