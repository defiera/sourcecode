pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract CounterRecommendImpl is CounterRecommendState {

    modifier AuthorizedOnly() {
        require(msg.sender == authorizedAddress); _;
    }

    
    function WhenOrderCreatedDelegate(OrderInterface)
    external AuthorizedOnly returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        return (0, new address[](0), new uint[](0), new AwardType[](0));
    }

    
    function WhenOrderFrozenDelegate(OrderInterface order)
    external AuthorizedOnly returns (uint len, address[] memory addresses, uint[] memory awards, AwardType[] memory types) {

        
        if ( RLTInterface.GetIntroducer(order.contractOwner()) == RLTInterface.rootAddress() ) {
            existedMapping[order.contractOwner()] = true;
            return (0, new address[](0), new uint[](0), new AwardType[](0));
        }

        
        if ( existedMapping[order.contractOwner()] ) {
            return (0, new address[](0), new uint[](0), new AwardType[](0));
        }

        
        existedMapping[order.contractOwner()] = true;

        len = 1;
        addresses = new address[](1);
        awards = new uint[](1);
        types = new AwardType[](1);

        addresses[0] = RLTInterface.GetIntroducer(order.contractOwner());
        awards[0] = order.totalAmount() * awardProp / 1 szabo;
        types[0] = AwardType.Recommend;
    }

    
    function WhenOrderDoneDelegate(OrderInterface)
    external AuthorizedOnly returns (uint len, address[] memory addresses, uint[] memory awards, AwardType[] memory) {
        return (0, new address[](0), new uint[](0), new AwardType[](0));
    }

    function SetAwardProp(uint p) external KOwnerOnly {
        awardProp = p;
    }

    
    function Import(address sender, bool isExisted) external KOwnerOnly {
        existedMapping[sender] = isExisted;
    }

}
