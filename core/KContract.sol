pragma solidity >=0.5.1 <0.7.0;

import "./KHost.sol";

contract KOwnerable {

    address[] public _KContractOwners;

    constructor() public {
        _KContractOwners.push(msg.sender);
    }

    modifier KOwnerOnly() {
        bool exist = false;
        for ( uint i = 0; i < _KContractOwners.length; i++ ) {
            if ( _KContractOwners[i] == msg.sender ) {
                exist = true;
                break;
            }
        }
        require(exist); _;
    }

    modifier KDAODefense() {
        uint256 size;
        address payable safeAddr = msg.sender;
        assembly {size := extcodesize(safeAddr)}
        require( size == 0, "DAO_Warning" );
        _;
    }

    modifier DAODefense() {
        uint256 size;
        address payable safeAddr = msg.sender;
        assembly {size := extcodesize(safeAddr)}
        require( size == 0, "DAO_Warning" );
        _;
    }

    function _safeSendEther(address payable to, uint etherValue) internal returns (bool) {
        uint256 size;
        assembly {size := extcodesize(to)}
        if ( size > 0 ) {
            return false;
        }
        to.transfer(etherValue);
        return true;
    }
}

contract KState is KOwnerable {

    uint public _CIDXX;

    Hosts public _KHost;

    constructor(uint cidxx) public {
        _CIDXX = cidxx;
    }

}

contract KContract is KState {

    modifier readonly {_;}

    modifier readwrite {_;}

    function implementcall() internal {
        (bool s, bytes memory r) = _KHost.getImplement(_CIDXX).delegatecall(msg.data);
        require(s);
        assembly {
            return( add(r, 0x20), returndatasize )
        }
    }

    function implementcall(uint subimplID) internal {
        (bool s, bytes memory r) = _KHost.getImplementSub(_CIDXX, subimplID).delegatecall(msg.data);
        require(s);
        assembly {
            return( add(r, 0x20), returndatasize )
        }
    }


    function _D(bytes calldata, uint m) external KOwnerOnly returns (bytes memory) {
        implementcall(m);
    }
}
