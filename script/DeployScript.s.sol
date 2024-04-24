// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "lib/forge-std/src/Script.sol";
import "../src/VotingSystem.sol";

contract DeployVotingSystem is Script {
    function run() external {
        vm.startBroadcast();

        VotingSystem votingSystem = new VotingSystem();

        vm.stopBroadcast();
    }
}