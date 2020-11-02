pragma solidity >=0.5.1 <0.7.0;

interface AssertPoolInterface{

    enum AssertPoolName {
        Nullable,
        
        Prepare,
        
        Treasure,
        
        Awards,
        
        Events
    }

    
    function PoolNameFromOperator(address operator) external returns (AssertPoolName);

    
    function Allowance(address operator) external returns (uint);

    
    function OperatorSend(address to, uint amount) external;

    
    function Auth_RecipientDelegate(uint amount) external;

    
    function ImportConfig() external;
}
