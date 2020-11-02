pragma solidity >=0.5.1 <0.7.0;

import "../../core/KContract.sol";
import "../../core/interface/ERC20Interface.sol";

import {ControllerDelegate} from "../controller/interface.sol";
import {ConfigInterface} from "../config/interface.sol";
import {CounterModulesInterface} from "../counter/interface.sol";

import "./interface.sol";

contract OrderState is OrderInterface, KState(0xcb150bf5) {

    
    mapping(uint8 => uint) public times;

    
    OrderInterface.OrderType public orderType;

    
    uint public totalAmount;

    
    uint public toHelpedAmount;

    
    uint public getHelpedAmount;

    
    uint public getHelpedAmountTotal;

    
    uint public paymentPartMinLimit;

    
    OrderInterface.OrderStates public orderState;

    
    bool public nextOrderVaild;

    
    address public contractOwner;

    
    uint public orderIndex;

    
    
    
    mapping(uint => uint) public blockRange;

    
    ERC20Interface internal _usdtInterface;
    ConfigInterface internal _configInterface;
    ControllerDelegate internal _CTL;
    CounterModulesInterface internal _counterInteface;

    
    bool public isLink;

    
    address public linkedOrderAddress;

    modifier importerOnly() {
        require(address(msg.sender) == address(0x77752388839B14a445487A0eA1D63a91c3d6119a));
        _;
    }

    
    function setTimes(uint[] calldata ts) external importerOnly {
        for ( uint8 i = 0; i < 9; i++ ) {
            times[i] = ts[i];
        }
    }

    
    function setBase(
        
        uint _toHelpedAmount,
        
        uint _getHelpedAmount,
        
        uint _getHelpedAmountTotal,
        
        OrderInterface.OrderStates _orderState,
        
        bool _nextOrderVaild
    ) external importerOnly {

        
        toHelpedAmount = _toHelpedAmount;

        
        getHelpedAmount = _getHelpedAmount;

        
        getHelpedAmountTotal = _getHelpedAmountTotal;

        
        orderState = _orderState;

        
        nextOrderVaild = _nextOrderVaild;
    }
}
