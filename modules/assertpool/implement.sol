pragma solidity >=0.5.1 <0.7.0;

import "./state.sol";

contract AssertPoolImpl is AssertPoolState {

    modifier AuthAddressOnly {
        require( authAddress == msg.sender, "InvalidOperation");
        _;
    }

    function PoolNameFromOperator(address operator) public returns (AssertPoolName) {

        for (uint i = 0; i < operators.length; i++) {
            if ( operators[i] == operator ) {
                return AssertPoolName(i);
            }
        }

        return AssertPoolName.Nullable;
    }

    
    function Allowance(address operator) external returns (uint) {

        for (uint i = 0; i < operators.length; i++) {
            if ( operators[i] == operator ) {
                return availTotalAmouns[i];
            }
        }

        
        return 0;
    }

    
    function OperatorSend(address to, uint amount) external {

        AssertPoolName pname = PoolNameFromOperator(msg.sender);

        
        require( availTotalAmouns[uint(pname)] >= amount );

        
        
        availTotalAmouns[uint(pname)] -= amount;

        
        usdtInterface.operatorSend(address(this), to, amount, "", "");
    }

    
    function Auth_RecipientDelegate(uint amount) external AuthAddressOnly {
        for (uint i = 0; i < availTotalAmouns.length; i++) {
            availTotalAmouns[i] += amount * matchings[i] / 1 szabo;
        }
    }

    
    function ImportConfig() external KOwnerOnly {

        uint balanceUSD = usdtInterface.balanceOf(address(this));

        
        for (uint i = 0; i < availTotalAmouns.length; i++) {
            availTotalAmouns[i] = balanceUSD * matchings[i] / 1 szabo;
        }
    }
}
