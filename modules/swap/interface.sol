pragma solidity >=0.5.1 <0.7.0;

interface SwapInterface {

    struct Info {
        
        uint roundID;
        
        uint total;
        
        uint current;
        
        uint prop;
    }

    enum DoswapingError {
        
        NoError,
        
        AllowanceInsufficient,
        
        BalanceInsufficient,
        
        SwapBalanceInsufficient
    }

    
    event Log_UpdateSwapInfo(uint when, address who, uint total, uint prop);

    
    event Log_Swaped(address indexed owner, uint time, uint inAmount, uint outAmount);

    
    function Doswaping(uint amount) external returns (DoswapingError code, uint tokenAmount);

    
    function OwnerUpdateSwapInfo(uint total, uint prop) external;
}
