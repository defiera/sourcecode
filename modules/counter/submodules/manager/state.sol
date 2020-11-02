pragma solidity >=0.5.1 <0.7.0;

import "../../../../core/interface/ERC777Interface.sol";
import "../../../../core/KContract.sol";
import "../../../relationship/interface.sol";

import "../../interface.sol";
import "./interface.sol";

contract CounterManagerState is CounterModulesInterface, CounterManagerInterface, KState(0x722a41a7) {

    
    address public authorizedAddress;

    
    RelationshipInterface public RLTInterface;

    
    uint[] public awardProp = [
        0.20 szabo, 
        0.10 szabo, 
        0.05 szabo, 
        0.03 szabo, 
        0.03 szabo, 
        0.03 szabo, 
        0.03 szabo, 
        0.03 szabo, 
        0.03 szabo, 
        0.03 szabo, 
        0.03 szabo, 
        0.03 szabo, 
        0.05 szabo, 
        0.10 szabo, 
        0.20 szabo  
    ];

    
    uint[] public dlevelAwarProp = [
        uint(0.000 szabo),
        uint(0.005 szabo),
        uint(0.005 szabo),
        uint(0.005 szabo),
        uint(0.005 szabo),
        uint(0.005 szabo)
    ];

    
    uint public dlvDepthMaxLimit = 512;

    
    uint public dlv1DepositedNeed = 10000 * 10 ** 6;

    
    uint public dlv1Prices = 100 * 10 ** 6;

    
    ERC777Interface internal usdtInterface;

    
    mapping(address => bool) internal vaildAddressMapping;

    
    mapping(address => uint) internal vaildAddressCountMapping;

    
    mapping(address => uint) internal selfAchievementMapping;

    
    mapping(address => uint8) internal dlevelMapping;

    
    mapping(address => uint8) internal dlevelMemberMaxMapping;

    
    mapping(address => bool) internal depositedGreatThanD1;

    
    mapping(address => bool) internal depositedGreatThan5000USD;
}
