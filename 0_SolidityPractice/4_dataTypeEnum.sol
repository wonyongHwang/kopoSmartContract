// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EnumExam {

    enum status { start, stop, running, pending }

    status myStatus = status.stop;

    function getStatus() public view returns (status) {
        return myStatus;
    }

    function setStatus(uint _newStatus) public {
        // 유효한 상태 값 검증
        require(_newStatus <= uint(status.pending), "Invalid status");
        myStatus = status(_newStatus);
    }
}