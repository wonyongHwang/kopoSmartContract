// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleContract {
// 이벤트를 정의합니다. 이더를 전송한 정보를 기록합니다.
event Received(address sender, uint amount);
// 기본적으로 계약이 이더를 받을 수 있도록 설정합니다.
receive() external payable {
    emit Received(msg.sender, msg.value);
}
// 계약의 잔액을 조회하는 함수입니다.
function getBalance() public view returns (uint) {
    return address(this).balance;
}
// 계약의 소유자가 이더를 인출할 수 있는 함수입니다.
function withdraw(uint amount) public {
    require(amount <= address(this).balance, "Insufficient balance");
    payable(msg.sender).transfer(amount);
}

}


