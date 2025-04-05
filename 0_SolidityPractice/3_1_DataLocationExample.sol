// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataLocationExample {
    uint[] public data; // stored in storage

    // calldata example
    function updateData(uint[] calldata input) external {
        // memory copy of input
        uint[] memory temp = input;

        // storage ref to state variable
        uint[] storage ref = data;

        // stack variable (implicitly stored in the stack)
        uint counter = 0;

        for (uint i = 0; i < temp.length; i++) {
            ref.push(temp[i]);
            counter++;
        }
    }
}
