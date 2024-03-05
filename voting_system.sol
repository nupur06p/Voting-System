/*
1.The authority must login first with the provided session ID. - done
2.The voter can now begin the process of voting with proper authentication through OTP(one time password) on the respective 
linked mobile number. - done
3.If the voter is valid then the system will check for for the voters age and the address to which he can give vote.- done
4.The voting pallete will be opened with candidate names,their parties and logos. - done
5.Now the voter can give his vote by clicking vote button - done
6.One voter can give his vote only once,i.e after one time voting buttons are disabled and the voter is automatically logged 
out. - done
7.Same process continiues for many more voters irrespective of their voting wards.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract Voting{

    struct Voter{
        uint aadhar_no;
        string voter_name;
        uint mobile_number;
        uint age;
        string voter_address;
        bool vote;
    }

    //voting pallete
    struct voting_pallete{
        string candidate_name;
        string party_name;
        string image_url;
        uint vote;
    }

    //mapping of struct Voter to an array
    mapping(uint=>Voter) public voters;
    Voter[] public candidates;
    uint public voter_count;

    //mapping of struct voting pallete
    mapping(uint=>voting_pallete) public pallete;
  
    uint public pallete_count;
    string constant voterAddress = "siliguri";
    address _authority;

  
    //to update candidates list
    function candidateList(uint _aadhar_no, string memory _voter_name, uint _mobile_number, uint _age) private{
        Voter storage v = voters[_aadhar_no];
        voters[_aadhar_no] = Voter(_aadhar_no,_voter_name,_mobile_number,_age, voterAddress, false);
        candidates.push(v);
        voter_count++;
    }

    //to update voting pallete
    function votingPallete(string memory candidate_name, string memory party_name, string memory image_url) private{
        pallete[pallete_count] = voting_pallete(candidate_name, party_name, image_url,0);
        pallete_count++;
    }

    constructor(address authority){
        _authority = authority;
        require(msg.sender==_authority, "Only authority can update the candidates list");
        voter_count= 0;
        pallete_count=0;

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

    //the authorised person can only login to the session
    modifier onlyAuthority(){
        require(msg.sender == _authority, "Only authority can login the session");
        _;
    }

    //return array of structures
    function getVotingPallete() public view returns (voting_pallete[] memory){
      voting_pallete[] memory Pvotings = new voting_pallete[](voter_count);
      for (uint i = 0; i < voter_count; i++) {
          voting_pallete storage  Pvoting= pallete[i];
          Pvotings[i] = Pvoting;
      }
      return Pvotings;
    }

    //return array of structures
    function getVoters() public view returns (Voter[] memory){
      Voter[] memory Nvoters = new Voter[](voter_count);
      for (uint i = 0; i < candidates.length; i++) {
          Voter storage Nvoter = voters[candidates[i].aadhar_no];
          Nvoters[i] = Nvoter;
      }
      return Nvoters;
    }

    //checking the voter validity
    function validity(uint p) public view onlyAuthority(){
        require(voters[p].age>=18 && keccak256(abi.encodePacked(voters[p].voter_address)) == keccak256(abi.encodePacked("siliguri")), "Voter is Invalid!!");
    }

    //giving vote
    function giveVote(uint _mobile_number, uint _aadhar_number, uint pallete_no) public{
        require(voters[_aadhar_number].aadhar_no ==  _aadhar_number, "Voter does not exist in the list");
        require(voters[_aadhar_number].mobile_number ==  _mobile_number, "Voter mobile number otp verified");
        require(voters[_aadhar_number].vote == false, "Vote has been cast by the voter");
        pallete[pallete_no].vote +=1;
        voters[_aadhar_number].vote = true;

    } 
}
