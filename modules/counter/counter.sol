pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract Counter is CounterState, CounterInterface, KContract {

    constructor(Hosts host) public {
        _KHost = host;
    }

    function OWNER_SetCTL(ControllerDelegate ctl) external KOwnerOnly {
        _CTL = ctl;
    }

    function WhenOrderCreatedDelegate(OrderInterface)
    external readwrite returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    
    function WhenOrderFrozenDelegate(OrderInterface)
    external readwrite returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    
    function WhenOrderDoneDelegate(OrderInterface)
    external readwrite returns (uint, address[] memory, uint[] memory, AwardType[] memory) {
        super.implementcall();
    }

    
    
    
    
    
    function SubModuleCIDXXS() external readonly returns (uint[] memory) {
        uint[] memory r = new uint[](submodules.length);
        for ( uint i = 0; i < submodules.length; i++ ) {
            r[i] = KContract(address(submodules[i]))._CIDXX();
        }
        return r;
    }

    function AddSubModule(CounterModulesInterface moduleInterface) external readwrite KOwnerOnly {
        for ( uint i = 0; i < submodules.length; i++ ) {
            require(submodules[i] != moduleInterface, "SubModulesExisted");
        }
        submodules.push(moduleInterface);
    }

    function RemoveSubModule(CounterModulesInterface moduleInterface) external readwrite KOwnerOnly {
        for ( uint i = 0; i < submodules.length; i++ ) {
            if ( submodules[i] == moduleInterface ) {
                for (uint j = i; j < submodules.length - 1; j++) {
                    submodules[j] = submodules[j + 1];
                }
                delete submodules[submodules.length - 1];
                submodules.length--;
                return ;
            }
        }
    }
}
