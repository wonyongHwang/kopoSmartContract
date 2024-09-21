// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    // 소유자 목록과 필요한 확인(서명) 수
    address[] public owners;
    uint public numConfirmationsRequired;

    // 트랜잭션 구조체: 받는 주소, 송금액, 실행 여부, 확인된 서명 수
    struct Transaction {
        address to;
        uint value;
        bool executed;
        uint numConfirmations;
    }

    // 매핑: 소유자인지 여부와 트랜잭션에 대한 서명 상태
    mapping(address => bool) public isOwner;
    mapping(uint => mapping(address => bool)) public isConfirmed;

    // 트랜잭션 배열
    Transaction[] public transactions;

    // 이벤트 로그
    event Deposit(address indexed sender, uint amount);
    event SubmitTransaction(uint indexed txIndex, address indexed to, uint value);
    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeConfirmation(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    // 소유자만 실행 가능하도록 제한하는 modifier
    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    // 트랜잭션이 존재하는지 확인하는 modifier
    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "Transaction does not exist");
        _;
    }

    // 이미 실행된 트랜잭션인지 확인하는 modifier
    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }

    // 이미 서명한 트랜잭션인지 확인하는 modifier
    modifier notConfirmed(uint _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "Transaction already confirmed");
        _;
    }

    // 생성자: 소유자 목록과 필요한 서명 수를 설정
    constructor(address[] memory _owners, uint _numConfirmationsRequired) payable {
        require(_owners.length > 0, "Owners required");
        require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "Invalid number of required confirmations");

        // 소유자 설정
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        numConfirmationsRequired = _numConfirmationsRequired;
    }

    // 입금 기능 (컨트랙트가 이더를 받을 수 있음)
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // 트랜잭션 제출: 소유자가 트랜잭션을 제출
    function submitTransaction(address _to, uint _value)
        public
        onlyOwner
    {
        uint txIndex = transactions.length;

        // 트랜잭션 배열에 새로운 트랜잭션 추가
        transactions.push(Transaction({
            to: _to,
            value: _value,
            executed: false,
            numConfirmations: 0
        }));

        emit SubmitTransaction(txIndex, _to, _value);
    }

    // 트랜잭션 확인: 다른 소유자가 트랜잭션에 서명
    function confirmTransaction(uint _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    // 트랜잭션 실행: 필요한 서명이 완료된 후 트랜잭션 실행
    function executeTransaction(uint _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        require(transaction.numConfirmations >= numConfirmationsRequired,
            "Cannot execute transaction");

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}("");
        require(success, "Transaction failed");

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    // 서명 취소: 서명한 소유자가 서명을 취소할 수 있음
    function revokeConfirmation(uint _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        require(isConfirmed[_txIndex][msg.sender], "Transaction not confirmed");

        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeConfirmation(msg.sender, _txIndex);
    }
}
