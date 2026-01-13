// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import "../src/game.sol";
import "../src/ledger.sol";

contract DeployGame is Script {
    function run() external returns(Ledger){
        vm.startBroadcast();
        GLDToken token = new GLDToken(21000);
        address tokenAddress = address(token);

        Ledger ledger = new Ledger(tokenAddress);

        vm.stopBroadcast();
        return(ledger);
    }
}