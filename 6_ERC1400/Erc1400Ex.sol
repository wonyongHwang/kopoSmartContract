// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC1400 is ERC20, Ownable {

    // Partitioned balances (파티션 별로 토큰 보유량 관리)
    mapping(bytes32 => mapping(address => uint256)) private _partitionBalances;

    // KYC/Whitelist management (KYC를 통한 화이트리스트 관리)
    mapping(address => bool) private _whitelisted;

    // Document management
    struct Document {
        string uri;
        bytes32 hash;
    }
    mapping(bytes32 => Document) private _documents;

    // Controller list for forced transfers
    address[] private _controllers;

    // EIP-1066 Transfer Status 구조체 정의
    struct TransferStatus {
        bytes32 code;
        string message;
    }

    // Events for partition transfers
    event IssuedByPartition(bytes32 indexed partition, address indexed to, uint256 value, bytes data);
    event RedeemedByPartition(bytes32 indexed partition, address indexed from, uint256 value, bytes data);
    event TransferredByPartition(bytes32 indexed partition, address indexed from, address indexed to, uint256 value, bytes data);

    // Controller events for forced transfers (ERC-1644)
    event ControllerTransfer(address controller, address indexed from, address indexed to, uint256 value, bytes data, bytes operatorData);

    constructor(
        string memory name,
        string memory symbol,
        address[] memory controllers
    ) ERC20(name, symbol) Ownable(msg.sender) {
        _controllers = controllers;
    }

    // ERC-1594: Issue tokens
    function issue(address to, uint256 value, bytes calldata data) external onlyOwner {
        require(isWhitelisted(to), "Recipient not KYC verified");
        _mint(to, value);
        emit IssuedByPartition("", to, value, data);  // Using an empty partition for general issuance
    }

    // ERC-1594: Redeem tokens
    function redeem(uint256 value, bytes calldata data) external {
        _burn(msg.sender, value);
        emit RedeemedByPartition("", msg.sender, value, data);  // Using an empty partition for general redemption
    }

    // ERC-1410: Issue tokens to a specific partition
    // data : 발행의 이유, 문서 참조, 또는 규제 준수를 위한 기타 메타데이터 등
    function issueByPartition(bytes32 partition, address to, uint256 value, bytes calldata data) external onlyOwner {
        require(isWhitelisted(to), "Recipient not KYC verified");
        _partitionBalances[partition][to] += value;
        _mint(to, value);
        emit IssuedByPartition(partition, to, value, data);
    }

    // ERC-1410: Transfer tokens within a specific partition
    function transferByPartition(bytes32 partition, address to, uint256 value, bytes calldata data) external {
        require(isWhitelisted(msg.sender), "Sender not KYC verified");
        require(isWhitelisted(to), "Recipient not KYC verified");
        require(_partitionBalances[partition][msg.sender] >= value, "Insufficient balance in this partition");

        _partitionBalances[partition][msg.sender] -= value;
        _partitionBalances[partition][to] += value;
        _transfer(msg.sender, to, value);
        emit TransferredByPartition(partition, msg.sender, to, value, data);
    }

    // ERC-1644: Forced transfer by a controller
    function controllerTransfer(
        address from,
        address to,
        uint256 value,
        bytes calldata data,
        bytes calldata operatorData
    ) external {
        require(isController(msg.sender), "Caller is not a controller");
        _transfer(from, to, value);
        emit ControllerTransfer(msg.sender, from, to, value, data, operatorData);
    }

    // ERC-1643: Set document
    function setDocument(bytes32 name, string calldata uri, bytes32 documentHash) external onlyOwner {
        _documents[name] = Document({uri: uri, hash: documentHash});
    }

    // ERC-1643: Get document
    function getDocument(bytes32 name) external view returns (string memory uri, bytes32 documentHash) {
        Document memory doc = _documents[name];
        return (doc.uri, doc.hash);
    }

    // ERC-1410: Get balance in a specific partition
    function balanceOfByPartition(bytes32 partition, address account) external view returns (uint256) {
        return _partitionBalances[partition][account];
    }

    // EIP-1066 상태 코드 정의
    function getSuccessStatus() private pure returns (TransferStatus memory) {
        return TransferStatus(bytes32("0x51"), "Transfer successful");
    }

    function getSenderKYCErrorStatus() private pure returns (TransferStatus memory) {
        return TransferStatus(bytes32("0xA0"), "Sender not KYC verified");
    }

    function getRecipientKYCErrorStatus() private pure returns (TransferStatus memory) {
        return TransferStatus(bytes32("0xA1"), "Recipient not KYC verified");
    }

    function getInsufficientBalanceErrorStatus() private pure returns (TransferStatus memory) {
        return TransferStatus(bytes32("0xA2"), "Insufficient balance");
    }

    function getPartitionInsufficientBalanceErrorStatus() private pure returns (TransferStatus memory) {
        return TransferStatus(bytes32("0xA2"), "Insufficient balance in partition");
    }

    // ERC-1594: Check if transfer is possible (canTransfer)
    function canTransfer(address to, uint256 value) public view returns (TransferStatus memory) {
        if (!isWhitelisted(msg.sender)) {
            return getSenderKYCErrorStatus();
        }
        if (!isWhitelisted(to)) {
            return getRecipientKYCErrorStatus();
        }
        if (balanceOf(msg.sender) < value) {
            return getInsufficientBalanceErrorStatus();
        }
        return getSuccessStatus();
    }

    // ERC-1594: Check if transfer by partition is possible (canTransferByPartition)
    function canTransferByPartition(bytes32 partition, address to, uint256 value) public view returns (TransferStatus memory) {
        if (!isWhitelisted(msg.sender)) {
            return getSenderKYCErrorStatus();
        }
        if (!isWhitelisted(to)) {
            return getRecipientKYCErrorStatus();
        }
        if (_partitionBalances[partition][msg.sender] < value) {
            return getPartitionInsufficientBalanceErrorStatus();
        }
        return getSuccessStatus();
    }

    // Add an address to the whitelist (KYC verified)
    function addWhitelisted(address account) external onlyOwner {
        _whitelisted[account] = true;
    }

    // Remove an address from the whitelist
    function removeWhitelisted(address account) external onlyOwner {
        _whitelisted[account] = false;
    }

    // Check if an address is whitelisted (KYC verified)
    function isWhitelisted(address account) public view returns (bool) {
        return _whitelisted[account];
    }

    // Check if an address is a controller
    function isController(address controller) public view returns (bool) {
        for (uint256 i = 0; i < _controllers.length; i++) {
            if (_controllers[i] == controller) {
                return true;
            }
        }
        return false;
    }
}
