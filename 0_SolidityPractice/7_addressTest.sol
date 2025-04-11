// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTransfer {

address public addressTo;

constructor(address addr) {
    
    addressTo = addr;
}

function transferToAddress2(uint256 amount) public {
    require(address(this).balance >= amount, "Insufficient balance in contract");
    payable(addressTo).transfer(amount);
}


receive() external payable {}


function getBalance() public view returns (uint256) {
    return address(this).balance;
}

}

