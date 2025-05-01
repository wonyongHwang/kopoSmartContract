// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // structure of Candidate
    struct Candidate {
        string name;
        uint voteCount;
    }

    // owner address
    address public owner;

    // Record of candidate list and voting status
    mapping(address => bool) public voters;  // Has the voter voted
    Candidate[] public candidates;  // candidate list

    // event
    event VoteCast(address voter, uint candidateIndex);

    // set the owner (will be called when this contract is deployed)
    constructor() {
        owner = msg.sender;
    }

    // Function to add a candidate (owner only)
    function addCandidate(string memory _name) public {
        require(msg.sender == owner, "Only the contract owner can add candidates.");  // 소유자만 호출 가능
        candidates.push(Candidate(_name, 0));
    }

    // voting
    function vote(uint _candidateIndex) public {
        require(!voters[msg.sender], "You have already voted.");  // 이미 투표한 사람은 다시 투표 불가
        require(_candidateIndex < candidates.length, "Invalid candidate index.");  // 유효한 후보자 여부 확인

        voters[msg.sender] = true;  // 투표자 기록
        candidates[_candidateIndex].voteCount++;  // 후보자 득표수 증가

        emit VoteCast(msg.sender, _candidateIndex);  // 투표 이벤트 발생
    }

    // Function that returns the number of votes for each candidate
    function getCandidateVotes(uint _candidateIndex) public view returns (uint) {
        require(_candidateIndex < candidates.length, "Invalid candidate index.");
        return candidates[_candidateIndex].voteCount;
    }

    // Function that returns the full list of candidates
    function getCandidates() public view returns (string[] memory) {
        string[] memory candidateNames = new string[](candidates.length);
        for (uint i = 0; i < candidates.length; i++) {
            candidateNames[i] = candidates[i].name;
        }
        return candidateNames;
    }
}
