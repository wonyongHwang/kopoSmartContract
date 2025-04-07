// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RequireContract {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function checkUnSignInt8(uint _data) public view returns (uint) {
        // Only the owner can call this function
        require(msg.sender == owner, "Caller is not the owner");

        // Check that _data is within uint8 range
        require(_data <= 255, "Value must be between 0 and 255");

        return _data;
    }
}
