// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20PermitToken is ERC20Permit, Ownable(msg.sender) {
    // 이벤트 정의
    event PermitFailed(address indexed owner, address indexed spender, uint256 value);
    event PermitSuccess(address indexed owner, address indexed spender, uint256 value);

    // constructor: ERC20 토큰 이름 및 기호를 설정
    constructor() ERC20("MyToken", "MTK") ERC20Permit("MyToken") {
        // 초기 발행량 설정
        _mint(msg.sender, 1000000 * 10 ** decimals()); // 1,000,000 토큰 발행
    }

    // Optional: 토큰 전송 함수 (ERC20에서 제공됨)
    function transfer(address to, uint256 amount) public override returns (bool) {
        return super.transfer(to, amount);
    }

    // Optional: 허가된 주소에서 토큰을 전송하는 함수 (ERC20에서 제공됨)
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        return super.transferFrom(from, to, amount);
    }

    // Optional: 특정 주소에 대해 토큰 잔액을 확인하는 함수 (ERC20에서 제공됨)
    function balanceOf(address account) public view override returns (uint256) {
        return super.balanceOf(account);
    }

    // Optional: 토큰의 총 발행량을 확인하는 함수 (ERC20에서 제공됨)
    function totalSupply() public view override returns (uint256) {
        return super.totalSupply();
    }

    // Override permit function with signature verification
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public override {
        // Custom logic (optional)
        require(deadline >= block.timestamp, "ERC20Permit: expired deadline");

        // Hash the permit data
        bytes32 structHash = keccak256(
            abi.encode(
                keccak256("Permit(address owner,address spender,uint256 value,uint256 deadline)"),
                owner,
                spender,
                value,
                deadline
            )
        );

        // Hash the domain
        bytes32 domainSeparator = _domainSeparatorV4();

        // Calculate the full message hash
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));

        // Recover the signer's address
        address recoveredAddress = ecrecover(digest, v, r, s);

        // Verify the signature
        if (recoveredAddress != owner) {
            emit PermitFailed(owner, spender, value); // Emit event on failure
            revert("ERC20Permit: invalid signature");
        } else {
            emit PermitSuccess(owner, spender, value); // Emit event on failure
        }

        // Call the parent contract's permit function
        // super.permit(owner, spender, value, deadline, v, r, s);

         _approve(owner, spender, value);
    }
}