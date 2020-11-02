pragma solidity >=0.5.1 <0.7.0;

import "../order/interface.sol";

library OrderArrExt {

    using OrderArrExt for OrderInterface[];

    function isEmpty(OrderInterface[] storage self) internal view returns (bool) {
        return self.length == 0;
    }

    function isNotEmpty(OrderInterface[] storage self) internal view returns (bool) {
        return self.length > 0;
    }

    function latest(OrderInterface[] storage self) internal view returns (OrderInterface) {
        return self[self.length - 1];
    }
}


library Uint32ArrExt {

    using Uint32ArrExt for uint32[];

    function isEmpty(uint32[] storage self) internal view returns (bool) {
        return self.length == 0;
    }

    function isNotEmpty(uint32[] storage self) internal view returns (bool) {
        return self.length > 0;
    }

    function latest(uint32[] storage self) internal view returns (uint32) {
        return self[self.length - 1];
    }
}
