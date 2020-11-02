pragma solidity >=0.5.1 <0.7.0;

import "../../../../core/KContract.sol";
import "../../../relationship/interface.sol";
import "../../interface.sol";
import "./interface.sol";

contract CounterRecommendState is CounterModulesInterface, CounterRecommendInterface, KState(0xcf0f35b8) {

    
    address public authorizedAddress;

    
    RelationshipInterface public RLTInterface;

    
    uint public awardProp = 0.1 szabo;

    
    mapping(address => bool) public existedMapping;
}
