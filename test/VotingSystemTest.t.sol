// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "lib/forge-std/src/Test.sol";
// import {Test} from "forge-std/Test.sol";
import {VotingSystem} from "../src/VotingSystem.sol";

contract VotingSystemTest is Test {

    VotingSystem votingSystem;

    function setUp() public{
        votingSystem = new VotingSystem(); 
        votingSystem.votingPallete("Mickey Mouse","BJP","#");
        votingSystem.candidateList(123456789,"Neha", 987654311, 19);  
    }

    /**
    * @notice - testing the owner of the contract
    */

    function testOwnerIsMsgSender() public view {
        assertEq(votingSystem.s_authority(), address(this));
    }

    /**
    * @notice - returning an array of structs in foundry
    * @notice - testing the voting pallete getVotingPallete() in foundry
    */
    function testVotingPalleteList() public view{

        (string memory candidate_name, string memory party_name, string memory image_url, uint vote) = votingSystem.s_votePallete(0);
        assert(keccak256(bytes(candidate_name)) == keccak256(bytes("Mickey Mouse")));
        assert(keccak256(bytes(party_name)) == keccak256(bytes("BJP")));
        assert(keccak256(bytes(image_url)) == keccak256(bytes("#"))); 
    }

    /** Testing the candidate List getVotersList() in foundry */
    function testCandidateList() public view{

        (uint aadhar_no, string memory voter_name, uint mobile_number, uint age, string memory voter_address, bool vote) = votingSystem.s_candidates(0);
        assert(123456789 == aadhar_no);
        assert(keccak256(bytes(voter_name)) == keccak256(bytes("Neha")));
        assert(987654311 == mobile_number);
        assert(19 == age);
    }

    /** Testing the giveVote() function in foundry
    * @notice - The functions candidateList() and votingPallete() needs initial update before calling function giveVote()
    * @notice - since the function giveVote() updates the element vote in both these function
    * @notice - vote in votingPallete() is a uint and vote in candidateList is a bool
    * @notice - hence assert and assertEq is used accordingly
    */

    function testgiveVote() public {

        //updates an element of the array s_candidates and s_votepallete
        (uint256 aadhar_no, string memory voter_name, uint256 mobile_number, uint256 age, string memory voter_address, bool vote) = votingSystem.s_candidates(0);
        (string memory candidate_name, string memory party_name, string memory image_url, uint Vote) = votingSystem.s_votePallete(0);

        votingSystem.giveVote(987654311, 123456789, "Mickey Mouse");
        uint256 votes = votingSystem.votesReceivedByVottingPallete("Mickey Mouse");
        VotingSystem.s_voterDetails memory voter  = votingSystem.getVoterByAadharNumber(123456789);
        assertEq(vote , false);
        assert(Vote == 0);
        assert(votes == 1);
        assertEq(voter.vote, true);
    }

    /** Testing the giveVote() function in foundry
    * @notice - Testing votesReceivedByVottingPallete() function in foundry
    */

    function testvotesReceivedByVottingPallete() public {
       
        votingSystem.giveVote(987654311, 123456789, "Neha");
        (uint aadhar_no, string memory voter_name, uint mobile_number, uint age, string memory voter_address, bool vote) = votingSystem.s_candidates(0);
        (string memory candidate_name, string memory party_name, string memory image_url, uint _vote) = votingSystem.s_votePallete(0);
        assert(keccak256(bytes(candidate_name)) == keccak256(bytes("Mickey Mouse")));
    }

    /** Testing the voterValidity() function in foundry
    * @notice - Testing voterValidity() function in foundry
    */

    function testvoterValidity() public {

        votingSystem.voterValidity(123456789);
        VotingSystem.s_voterDetails memory voter = votingSystem.getVoterByAadharNumber(123456789);

        assertGt(voter.age, 18);
        assertEq(voter.vote, false);

        votingSystem.giveVote(987654311, 123456789, "Mickey Mouse");
        vm.startPrank(address(this));
        vm.expectRevert("Voter has already voted");
        votingSystem.voterValidity(123456789);
        VotingSystem.s_voterDetails memory _voter = votingSystem.getVoterByAadharNumber(123456789);
        vm.stopPrank();

    }
}