// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {

    mapping(address => uint) private balances;

    event Deposit(address indexed account, uint amount);
    event Withdrawal(address indexed account, uint amount);
    event InternalTransfer(address indexed from, address indexed to, uint amount); // ✅ 변경: 사용자 혼란 방지를 위해 이름 변경

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    function deposit() public payable {
        require(msg.value > 0, "should be > 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        // ✅ 변경: Checks-Effects-Interactions 패턴 적용 — 재진입 공격 방지
        balances[msg.sender] -= _amount; // 상태 먼저 변경
        payable(msg.sender).transfer(_amount); // 이후 이더 전송

        emit Withdrawal(msg.sender, _amount);
    }

    function internalTransfer(address _to, uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(_to != address(0), "Invalid address");

        // ✅ 변경: transfer → internalTransfer 로 명확하게 변경 (실제 이더 전송 아님 명시)
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        emit InternalTransfer(msg.sender, _to, _amount);
    }

    function getBankBalance() public view returns (uint) {
        return address(this).balance;
    }
}
