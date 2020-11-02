pragma solidity >=0.5.1 <0.7.0;

contract OrderRelationsPlugins {

    
    
    mapping( address => mapping(uint => bool) ) public createdOrderMapping;

    address contractOwner;

    constructor() public {
        contractOwner = msg.sender;
    }

    modifier authOnly() {
        
        require(
            msg.sender == address(0x1580e10b3e6d8F9bA35d8E3F0eEb23E4269ff728) ||
            msg.sender == contractOwner
        );
        _;
    }

    
    function createdOrderDelegate(address owner) external authOnly {
        createdOrderMapping[owner][now / 1 days * 1 days] = true;
    }

    
    function doConvertConsumerDelegate(address owner) external authOnly {
        createdOrderMapping[owner][now / 1 days * 1 days] = false;
    }

    
    function canConvertConsumer(address owner) external view returns (bool) {
        return createdOrderMapping[owner][now / 1 days * 1 days];
    }
}
