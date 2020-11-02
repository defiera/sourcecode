pragma solidity >=0.5.1 <0.7.0;

import "./core/KHost.sol";

contract Migrations is Hosts {

    uint public last_completed_migration;

    function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
    }

}
