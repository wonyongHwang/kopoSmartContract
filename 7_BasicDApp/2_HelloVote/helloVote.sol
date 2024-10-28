// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // 후보자 구조체
    struct Candidate {
        string name;
        uint voteCount;
    }

    // 소유자 주소
    address public owner;

    // 후보자 목록 및 투표 여부를 기록
    mapping(address => bool) public voters;  // 투표자의 투표 여부
    Candidate[] public candidates;  // 후보자 목록

    // 이벤트
    event VoteCast(address voter, uint candidateIndex);

    // 소유자 설정 (컨트랙트 배포 시)
    constructor() {
        owner = msg.sender;
    }

    // 후보자를 추가하는 함수 (소유자만 가능)
    function addCandidate(string memory _name) public {
        require(msg.sender == owner, "Only the contract owner can add candidates.");  // 소유자만 호출 가능
        candidates.push(Candidate(_name, 0));
    }

    // 투표 기능
    function vote(uint _candidateIndex) public {
        require(!voters[msg.sender], "You have already voted.");  // 이미 투표한 사람은 다시 투표 불가
        require(_candidateIndex < candidates.length, "Invalid candidate index.");  // 유효한 후보자 여부 확인

        voters[msg.sender] = true;  // 투표자 기록
        candidates[_candidateIndex].voteCount++;  // 후보자 득표수 증가

        emit VoteCast(msg.sender, _candidateIndex);  // 투표 이벤트 발생
    }

    // 후보자별 득표수를 반환하는 함수
    function getCandidateVotes(uint _candidateIndex) public view returns (uint) {
        require(_candidateIndex < candidates.length, "Invalid candidate index.");
        return candidates[_candidateIndex].voteCount;
    }

    // 전체 후보자 목록을 반환하는 함수
    function getCandidates() public view returns (string[] memory) {
        string[] memory candidateNames = new string[](candidates.length);
        for (uint i = 0; i < candidates.length; i++) {
            candidateNames[i] = candidates[i].name;
        }
        return candidateNames;
    }
}
