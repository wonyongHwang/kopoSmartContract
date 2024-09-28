// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

 
contract MyToken is ERC20, Ownable {
    // 토큰 생성자 함수​

    constructor() ERC20("MyToken", "MTK") {

        // 토큰 초기 발행량을 설정 (단위: 10^18, 즉 1 MTK = 1 * 10^18 Wei)​

        // 여기서 1000 MTK 토큰을 배포자에게 할당​

        _mint(msg.sender, 1000 * 10 ** decimals());

    }

    // 추가 발행 함수 (Owner만 호출 가능)​

    function mint(address to, uint256 amount) public onlyOwner {

        _mint(to, amount);

    }
}

