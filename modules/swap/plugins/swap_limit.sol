pragma solidity >= 0.5 .1 < 0.7 .0;

import "../../phoenix/interface.sol";

contract SwapLimit {

    
    uint public nomalAddressQuota = 5 * 10 ** 6;

    
    uint public vaildAddressQuota = 100 * 10 ** 6;

    
    mapping( address => mapping(uint => uint) ) public quotaMapping;

    address contractOwner;
    address swapInc;
    PhoenixInterface phoenixInc;

    constructor(
        address swap,
        PhoenixInterface phoenixAddress
    ) public {
        swapInc = swap;
        phoenixInc = phoenixAddress;
        contractOwner = msg.sender;
    }

    modifier authOnly() {
        require(msg.sender == swapInc);
        _;
    }

    
    function exchangeLimit(address owner) public returns(uint) {

        
        (uint tin, ) = phoenixInc.GetInoutTotalInfo(owner);

        uint dayz = now / 1 days * 1 days;

        if ( tin > 0 ) {
            return vaildAddressQuota - quotaMapping[owner][dayz];
        } else {
            return nomalAddressQuota - quotaMapping[owner][dayz];
        }
    }

    function shouldChange(address owner, uint amountOfUSD) external returns(bool) {
        uint limit = exchangeLimit(owner);
        return limit <= amountOfUSD;
    }

    function didChangeDelegate(address owner, uint amountOfUSD) external authOnly {
        uint limit = exchangeLimit(owner);
        require(limit >= amountOfUSD);
        quotaMapping[owner][now / 1 days * 1 days] += amountOfUSD;
    }

    function Owner_SetChangeQuota(uint nomal, uint vaild) external {
        require(msg.sender == contractOwner);
        nomalAddressQuota = nomal;
        vaildAddressQuota = vaild;
    }
}
