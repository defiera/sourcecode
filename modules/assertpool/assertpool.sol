pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract AssertPool is AssertPoolState, KContract {

    constructor(
        ERC777Interface usdInc,
        Hosts host
    ) public {
        _KHost = host;
        usdtInterface = usdInc;
    }

    
    function OWNER_SetSwapInterface(address swapInc) external KOwnerOnly {
        authAddress = swapInc;
    }

    
    function OWNER_SetOperator(address operator, AssertPoolName poolName) external KOwnerOnly {
        operators[uint(poolName)] = operator;
    }

    
    function OWNER_SetMatchings( uint[4] calldata ms ) external KOwnerOnly {

        require( ms[0] + ms[1] + ms[2] + ms[3] == 1 szabo );

        matchings[1] = ms[0];
        matchings[2] = ms[1];
        matchings[3] = ms[2];
        matchings[4] = ms[3];
    }

    
    function PoolNameFromOperator(address) external readonly returns (AssertPoolName) {
        super.implementcall();
    }

    
    function Allowance(address) external readonly returns (uint) {
        super.implementcall();
    }

    
    function OperatorSend(address, uint) external readwrite {
        super.implementcall();
    }

    
    function Auth_RecipientDelegate(uint) external readwrite {
        super.implementcall();
    }

    
    function ImportConfig() external readwrite {
        super.implementcall();
    }
}
