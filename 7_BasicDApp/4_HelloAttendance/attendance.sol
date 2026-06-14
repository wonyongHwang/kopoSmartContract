// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AttendanceCheck {
    mapping(address => bool) private checkedIn;
    mapping(address => uint256) private checkInTime;

    function checkIn() public {
        require(!checkedIn[msg.sender], "Already checked in");

        checkedIn[msg.sender] = true;
        checkInTime[msg.sender] = block.timestamp;
    }

    function isCheckedIn(address user) public view returns (bool) {
        return checkedIn[user];
    }

    function getCheckInTime(address user) public view returns (uint256) {
        return checkInTime[user];
    }
}
