pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract CounterImpl is CounterState {

    modifier AuthorizedOnly() {
        require(_CTL.order_IsVaild(msg.sender));_;
    }

    
    function mergeInvokeResults( InvokeResult[] memory results, uint len ) internal pure returns (InvokeResult memory r) {

        
        uint addressCount;

        
        for (uint i = 0; i < len; i++) {
            for (uint j = 0; j < results[i].len; j++) {
                if ( results[i].addresses[j] != address(0x0) ) {
                    addressCount++;
                }
            }
        }

        
        r = InvokeResult(addressCount, new address[](addressCount), new uint[](addressCount), new AwardType[](addressCount));

        
        uint offset = 0;
        for ( uint i = 0; i < len; i++ ) {
            for (uint j = 0; j < results[i].len; j++) {
                if ( results[i].addresses[j] != address(0x0) ) {
                    r.addresses[offset] = results[i].addresses[j];
                    r.awards[offset] = results[i].awards[j];
                    r.awardTypes[offset] = results[i].awardTypes[j];
                    ++offset;
                }
            }
        }
    }

    
    function WhenOrderCreatedDelegate(OrderInterface order)
    external AuthorizedOnly returns (uint, address[] memory, uint[] memory, AwardType[] memory) {

        InvokeResult[] memory results = new InvokeResult[](submodules.length);

        for ( uint i = 0; i < submodules.length; i++ ) {
            (results[i].len, results[i].addresses, results[i].awards, results[i].awardTypes) = submodules[i].WhenOrderCreatedDelegate(order);
        }

        
        InvokeResult memory r = mergeInvokeResults(results, submodules.length);

        return (r.len, r.addresses, r.awards, r.awardTypes);
    }

    
    function WhenOrderFrozenDelegate(OrderInterface order)
    external AuthorizedOnly returns (uint, address[] memory, uint[] memory, AwardType[] memory) {

        InvokeResult[] memory results = new InvokeResult[](submodules.length);

        for ( uint i = 0; i < submodules.length; i++ ) {
            (results[i].len, results[i].addresses, results[i].awards, results[i].awardTypes)  = submodules[i].WhenOrderFrozenDelegate(order);
        }

        
        InvokeResult memory r = mergeInvokeResults(results, submodules.length);

        return (r.len, r.addresses, r.awards, r.awardTypes);
    }

    
    function WhenOrderDoneDelegate(OrderInterface order)
    external AuthorizedOnly returns (uint, address[] memory, uint[] memory, AwardType[] memory) {

        InvokeResult[] memory results = new InvokeResult[](submodules.length);

        for ( uint i = 0; i < submodules.length; i++ ) {
            (results[i].len, results[i].addresses, results[i].awards, results[i].awardTypes)  = submodules[i].WhenOrderDoneDelegate(order);
        }

        
        InvokeResult memory r = mergeInvokeResults(results, submodules.length);

        return (r.len, r.addresses, r.awards, r.awardTypes);
    }
}
