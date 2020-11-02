pragma solidity >=0.5.0 <0.6.0;

interface USDTInterface {

    function totalSupply() external view returns (uint);

    function balanceOf(address who) external view returns (uint);

    function allowance(address owner, address spender) external view returns (uint);

    
    function transfer(address to, uint value) external;

    function approve(address spender, uint value) external;

    function transferFrom(address from, address to, uint value) external;
}
