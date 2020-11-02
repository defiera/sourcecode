pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract Relationship is RelationshipState, KContract {

    constructor( Hosts host ) public {

        _KHost = host;

        address defaultAddr = address(0xdead);

        
        
        _shortCodeMapping[0x305844454144] = defaultAddr;
        _addressShotCodeMapping[defaultAddr] = 0x305844454144;

        
        _recommerMapping[defaultAddr] = address(0xdeaddead);
    }

    
    
    
    
    function GetIntroducer(address) external readonly returns (address) {
        super.implementcall();
    }

    
    function RecommendList(address) external readonly returns (address[] memory, uint) {
        super.implementcall();
    }

    
    function ShortCodeToAddress(bytes6) external readonly returns (address) {
        super.implementcall();
    }

    
    function AddressToShortCode(address) external readonly returns (bytes6) {
        super.implementcall();
    }

    
    function AddressToNickName(address) external readonly returns (bytes16) {
        super.implementcall();
    }

    
    function Depth(address) external readonly returns (uint) {
        super.implementcall();
    }

    
    
    
    
    function RegisterShortCode(bytes6) external readwrite returns (bool) {
        super.implementcall();
    }

    
    function UpdateNickName(bytes16) external readwrite {
        super.implementcall();
    }

    
    function AddRelation(address) external readwrite returns (AddRelationError) {
        super.implementcall();
    }

    
    function AddRelationEx(address, bytes6, bytes16) external readwrite returns (AddRelationError) {
        super.implementcall();
    }

    
    function Import(address, address, bytes6, bytes16) external readwrite {
        super.implementcall();
    }
}
