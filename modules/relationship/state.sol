pragma solidity >=0.5.1 <0.7.0;

import "../../core/KContract.sol";

import "../controller/interface.sol";

import "./interface.sol";

contract RelationshipState is RelationshipInterface, KState(0x954ff62d) {
    
    address public constant rootAddress = address(0xdead);
    
    uint public totalAddresses;
    
    mapping ( address => address ) internal _recommerMapping;
    
    mapping ( address => address[] ) internal _recommerList;
    
    mapping ( bytes6 => address ) internal _shortCodeMapping;
    
    mapping ( address => bytes6 ) internal _addressShotCodeMapping;
    
    mapping ( address => bytes16 ) internal _nickenameMapping;
    
    mapping ( address => uint ) internal _depthMapping;
}
