// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;  // Assign the initially minted tokens to the contract deployer
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}

contract ICO {
    Token public token;
    address public owner;
    uint256 public rate = 100;  // 1 wei <-> 100 토큰

    event BoughtTokens(address buyer, uint256 amount);

    constructor(Token _token) {
        token = _token;
        owner = msg.sender;
    }

    // Function that is called when an investor sends Ether
    receive() external payable {
        uint256 tokenAmount = msg.value * rate;
        require(token.balanceOf(owner) >= tokenAmount, "Not enough tokens");
        token.transferFrom(owner, msg.sender, tokenAmount);
        emit BoughtTokens(msg.sender, tokenAmount);
    }

    // Function that allows the contract owner to withdraw Ether
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}

// Execution order:
// 1. Deploy the TOKEN contract.
// 2. Deploy the ICO contract (pass the TOKEN contract address to the constructor when deploying).
// 3. Call the `approve` function of the TOKEN contract:
//      - First parameter: Address of the deployed ICO contract
//      - Second parameter: Total number of tokens the ICO contract is allowed to transfer to investors via `transferFrom` (e.g., 1000)
// 4. Verify using the `allowance` function of the TOKEN contract:
//      - First parameter: Deployer's address
//      - Second parameter: Address of the deployed ICO contract
// 5. For testing, switch to the second wallet address in Remix.
// 6. From the second wallet, set VALUE to 1 wei and click `Transact` on the deployed ICO contract.
// 7. Check the results using `balanceOf` and `allowance`.


// 실행 순서 
// TOKEN 컨트랙트 배포 -> ICO 컨트랙트 배포(배포시 TOKEN 컨트랙트 배포 주소를 생성자에 전달)
// TOKEN 컨트랙트의 approve 함수 호출 
//      첫 번째 파라미터 : ICO 컨트랙트 배포 주소
//      두 번째 파라미터 : ICO 컨트랙트가 transferFrom으로 투자자에게 전송을 허용량 총 토큰 (예> 1000)
// TOKEN 컨트랙트의 allowance 로 확인
//      첫 번째 파라미터 : 배포자 주소
//      두 번째 파라미터 : ICO 컨트랙트 배포 주소
// 테스트를 위해 Remix의 지갑 주소를 2번째 지갑주소로 변경
// 2번째 지갑 주소에서 VALUE를 1 wei 로 설정하고 ICO 컨트랙트 배포된 항목의 TRANSACT를 클릭
// 결과 확인 : balanceOf, allowance로 확인
