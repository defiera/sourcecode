pragma solidity >=0.5.1 <0.7.0;

import "./interface.sol";

import "../../core/KContract.sol";
import "../../core/interface/ERC777Interface.sol";

import "../assertpool/interface.sol";

contract SwapState is SwapInterface, KState(0x6b0331b4) {

    
    uint public swapedTotalSum;

    Info public swapInfo;

    ERC777Interface public usdtInterface;

    AssertPoolInterface public astPool;
}
