// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicWallet {
    address public storedAddress;

    // Store a specific address passed in the constructor
    constructor(address _inputAddress) {
        storedAddress = _inputAddress;
    }

    // Return the Ether balance of the stored address
    function getStoredAddressBalance() public view returns (uint256) {
        return storedAddress.balance;
    }

    // Enable the contract to receive Ether
    receive() external payable {}

    // Send Ether from this contract to another address
    function sendEther(address payable _to, uint256 _amount) public {
        require(address(this).balance >= _amount, "Not enough Ether in contract");
        _to.transfer(_amount);
    }

    // Return the Ether balance of this contract
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

