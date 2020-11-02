pragma solidity >=0.5.1 <0.7.0;

import "../../core/interface/ERC777Interface.sol";
import "../../core/KContract.sol";

import "../ext/ext.sol";
import "../order/Order.sol";
import "../config/interface.sol";
import "../reward/interface.sol";
import "../counter/interface.sol";
import "../phoenix/interface.sol";
import "../assertpool/awards/interface.sol";
import "../relationship/interface.sol";

import "./interface.sol";

import "./library/OrderManager.sol";

contract ControllerState is ControllerInterface_User_Read, ControllerInterface_User_Write, ControllerInterface_Onwer, ControllerDelegate, KState(0x54015ff9) {

    
    OrderManager.MainStruct _orderManager;

    
    mapping(address => bool) public blackList;

    
    
    mapping(uint => uint) public depositedLimitMapping;

    ERC777Interface usdtInterface;

    
    ConfigInterface configInterface;
    RewardInterface rewardInterface;
    CounterModulesInterface counterInterface;
    AssertPoolAwardsInterface astAwardInterface;
    PhoenixInterface phoenixInterface;
    RelationshipInterface relationInterface;
}
