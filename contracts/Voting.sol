// SPDX-License-Identifier : MIT

pragma solidity ^0.8.0;

contract Voting{
    struct Candidate {     // creating struct
        string name;           // name and its vote count
        uint256 voteCount;
    }

    Candidate[] public candidates;    // array of struct
    address owner;                    // owner of smart contract

    mapping(address => bool) public voters;         // track either he voted or not

    uint256 votingStart;      // time of voting - start
    uint256 votingEnd;        // end time

    constructor(string[] memory _candidateNames, uint256 _durationInMinutes){     // constructor with 2 argument
        for(uint256 i = 0; i < _candidateNames.length; i++){
            candidates.push(
                Candidate({                                 // inserting name and their count in struct
                    name : _candidateNames[i],
                    voteCount : 0
                })
            );
        }

        owner = msg.sender;
        votingStart = block.timestamp;
        votingEnd = block.timestamp + (_durationInMinutes * 1 minutes);
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }


    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate({
            name : _name,
            voteCount : 0
        }));
        
    }

    function vote(uint256 _candidateIndex) public {
        require(!voters[msg.sender], "You have already voted !!!");      // to check whether he or she already voted or not
        require(_candidateIndex < candidates.length, "Invalid Candidate index"); // whether selected the candidate who are elected or not

        candidates[_candidateIndex].voteCount++;     // increment that particular candidate count
        voters[msg.sender] == true;                  // now change that he voted (conition true)
        
    }

    function getAllVotesOfCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    // to check whether vooting ended or not
    function getVotingStatus() public view returns (bool) {     
        return (block.timestamp>=votingStart && block.timestamp < votingEnd);
    }

    function getRemainingTime() public view  returns (uint256){
        require(block.timestamp >= votingStart, "Voting has not started yet !!!"); 
        if(block.timestamp >= votingEnd){
            return 0;
        }
        return votingEnd - block.timestamp;
    }
    // now its completed


}
