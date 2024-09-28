require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.27", // 원하는 Solidity 버전
  networks: {
    hardhat: {
      // 여기에 필요한 추가 설정을 추가할 수 있습니다.
      chainId: 1337, // Hardhat 네트워크의 기본 체인 ID
    },
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    websocket: {
      url: "ws://127.0.0.1:8545",
      timeout: 20000,
    },
  },
};
