// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**@title A Voting Contract
 * @author Nupur Panjiar
 * @notice This contract is for creating a voting system contract
*/

contract VotingSystem{

    /**Type declarations*/
    /* @dev - Voter structure details*/
    struct s_voterDetails{
        uint aadhar_no;
        string voter_name;
        uint mobile_number;
        uint age;
        string voter_address;
        bool vote;
    }

    /* @dev - Voting Pallete details*/
    struct s_votingPallete{
        string candidate_name;
        string party_name;
        string image_url;
        uint vote;
    }

    /* @dev - Mapping of structure voter to an array*/
    mapping(uint=>s_voterDetails) public s_voters;
    s_voterDetails[] public s_candidates;
    uint private s_voterCount;

    /* @dev - Mapping of structure voting pallete*/
    mapping(string=>s_votingPallete) public s_pallete;
    s_votingPallete[] public s_votePallete;
    uint private s_palleteCount;

    string private constant VOTER_ADDRESS = "siliguri";
    address public s_authority;
    string private s_text = "Voter is Valid";
    string private s_invalid = "Voter is Invalid";

    /* @dev - Only authorised person can login to this session*/
    modifier onlyAuthority(){
        require(s_authority == msg.sender, "Only authority can login the session");
        _;
    }

    /* Functions */
    constructor() {
        s_authority = msg.sender;
        s_voterCount= 0;
        s_palleteCount=0;

        //updating the candidate list
        candidateList(123456789,"Neha",987654311,19);
        candidateList(123456788,"Nupur",987654322,20);
        candidateList(123456787,"Akansha",987654333,21);
        candidateList(123456786,"Ankita",987654344,22);
        candidateList(123456785,"Anamika",987654355,22);

        //updating the voting pallete
        votingPallete("Mickey Mouse", "BJP", "#");
        votingPallete("Donald Duck", "Congress", "@");
        votingPallete("Popeye", "RJD", "!");
        votingPallete("Sindabad Sailor", "BSP", "%");
    }
  
    /* @dev - This function updates candidate list*/
    function candidateList(uint aadhar_no, string memory voterName, uint mobileNumber, uint age) public{
        // s_voterDetails storage v = s_voters[aadhar_no];
        s_voters[aadhar_no] = s_voterDetails(aadhar_no, voterName, mobileNumber, age, VOTER_ADDRESS, false);
        s_candidates.push(s_voters[aadhar_no]);
        s_voterCount++;
    }

    /* @dev - This function updates voting pallete*/
    function votingPallete(string memory candidateName, string memory partyName, string memory imageUrl) public{
        s_pallete[candidateName] = s_votingPallete(candidateName, partyName, imageUrl,0);
        s_votePallete.push(s_pallete[candidateName]);
        s_palleteCount++;
    }

    /* @dev - This function checks the voter validity*/
    function voterValidity(uint aAdhar_no) public view onlyAuthority() returns(string memory){
        if(s_voters[aAdhar_no].aadhar_no ==0){
            return s_invalid;
        } else{
        require(s_voters[aAdhar_no].age>=18 && keccak256(abi.encodePacked(s_voters[aAdhar_no].voter_address)) == 
        keccak256(abi.encodePacked(VOTER_ADDRESS)), "Voter is Invalid!!");
        require(s_voters[aAdhar_no].vote == false, "Voter has already voted");
        return s_text;
        }
    }

    /* @dev - This function handles the vote being given by a candidate*/
    function giveVote(uint mobileNumber, uint aadharNumber, string memory candidateName) public{
        require(s_voters[aadharNumber].aadhar_no ==  aadharNumber, "Voter does not exist in the list");
        require(s_voters[aadharNumber].mobile_number ==  mobileNumber, "Voter mobile number otp verified");
        require(s_voters[aadharNumber].vote == false, "Vote has been cast by the voter");
        s_pallete[candidateName].vote +=1;
        s_voters[aadharNumber].vote = true;
    } 

    /** Getter Functions */
    /* @dev - This function gets the voting pallete*/
    function getVotingPallete() public view returns (s_votingPallete[] memory){
        return s_votePallete;
    }

    /* @dev - This function gets the list of voters*/
    function getVotersList() public view returns (s_voterDetails[] memory){
        return s_candidates;
    }

    /* @dev - This function gets each voter by aadhar number*/
    function getVoterByAadharNumber(uint aadharNo) public view returns (s_voterDetails memory){
        return s_voters[aadharNo];
    }

    /* @dev - This function extracts the votes received by all parties*/
    function votesReceivedByVottingPallete(string memory candidateName) public view returns(uint256 vote){
        return  s_pallete[candidateName].vote;
    }
}