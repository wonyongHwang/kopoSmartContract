// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleTransfer {

// 두 개의 address 변수를 선언합니다.
address public address1;
address public address2;

// 생성자(constructor) 함수: 계약 배포 시 주소를 설정합니다.
constructor(address _address1, address _address2) {
    address1 = _address1;
    address2 = _address2;
}

// Ether를 address2로 송금하는 함수
function transferToAddress2(uint256 amount) public {
    require(address(this).balance >= amount, "Insufficient balance in contract");
    payable(address2).transfer(amount);
}

// 계약에 Ether를 송금하는 함수
receive() external payable {}

// 계약의 현재 Ether 잔액을 확인하는 함수
function getBalance() public view returns (uint256) {
    return address(this).balance;
}

}

