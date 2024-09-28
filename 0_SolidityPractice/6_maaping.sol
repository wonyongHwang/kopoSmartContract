// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    
    // 각 계좌의 잔액을 관리하는 매핑
    mapping(address => uint) private balances;

    // 입금 이벤트
    event Deposit(address indexed account, uint amount);

    // 출금 이벤트
    event Withdrawal(address indexed account, uint amount);

    // 이체 이벤트
    event Transfer(address indexed from, address indexed to, uint amount);

    // 특정 계좌에 잔액을 확인하는 함수
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    // 입금 함수 (이더를 스마트 컨트랙트로 전송)
    function deposit() public payable {
        require(msg.value > 0, "should be > 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // 출금 함수 (이더를 본인의 주소로 전송)
    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "error");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawal(msg.sender, _amount);
    }

    // 특정 계좌로 이체하는 함수
    function transfer(address _to, uint _amount) public {
        require(balances[msg.sender] >= _amount, "error");
        require(_to != address(0), "error");
        
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        
        emit Transfer(msg.sender, _to, _amount);
    }
    
    // 은행의 총 잔액을 확인하는 함수 (컨트랙트 자체의 잔액)
    function getBankBalance() public view returns (uint) {
        return address(this).balance;
    }
}