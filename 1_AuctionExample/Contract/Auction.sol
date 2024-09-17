// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    address internal auction_owner;
    uint256 public auction_start;
    uint256 public auction_end;
    uint256 public highestBid;
    address public highestBidder;

    enum auction_state {
        CANCELLED, STARTED
    }

    struct car {
        string Brand;
        string Rnumber;
    }

    car public Mycar;
    address[] bidders;
    mapping(address => uint) public bids;
    auction_state public STATE;

    // 경매가 진행 중인지 확인하는 modifier
    modifier an_ongoing_auction() {
        require(block.timestamp <= auction_end, "Auction has ended");
        _;
    }

    // 경매 소유자만 호출할 수 있는 modifier
    modifier only_owner() {
        require(msg.sender == auction_owner, "Only auction owner can call this");
        _;
    }

    // 함수 선언에 virtual 키워드 추가
    function bid() public payable virtual returns (bool) {}
    function withdraw() public virtual returns (bool) {}
    function cancel_auction() external virtual returns (bool) {}

    // 이벤트 선언
    event BidEvent(address indexed highestBidder, uint256 highestBid);
    event WithdrawalEvent(address withdrawer, uint256 amount);
    event CanceledEvent(uint message, uint256 time);
    event StateUpdated(auction_state newState); // 상태 업데이트 이벤트 추가
}

contract MyAuction is Auction {

    // 생성자
    constructor(uint _biddingTime, address _owner, string memory _brand, string memory _Rnumber) {
        auction_owner = _owner;
        auction_start = block.timestamp;
        auction_end = auction_start + _biddingTime * 1 hours;
        STATE = auction_state.STARTED;
        Mycar.Brand = _brand;
        Mycar.Rnumber = _Rnumber;
    }

    // 부모 컨트랙트의 bid 함수 재정의 (override)
    function bid() public payable override an_ongoing_auction returns (bool) {
        require(bids[msg.sender] + msg.value > highestBid, "You can't bid, make a higher bid");
        highestBidder = msg.sender;
        highestBid = msg.value;
        bidders.push(msg.sender);
        bids[msg.sender] = bids[msg.sender] + msg.value;
        emit BidEvent(highestBidder, highestBid);

        return true;
    }

    // 부모 컨트랙트의 cancel_auction 함수 재정의 (override)
    function cancel_auction() external override only_owner an_ongoing_auction returns (bool) {
        STATE = auction_state.CANCELLED;
        emit CanceledEvent(1, block.timestamp);
        return true;
    }

    // 경매 비활성화 (selfdestruct 대신 사용)
    function deactivateAuction() external only_owner {
        require(block.timestamp > auction_end, "Auction is still ongoing");
        STATE = auction_state.CANCELLED;
        emit CanceledEvent(2, block.timestamp);
    }

    // 경매 소유자가 남은 자금을 회수하는 함수
    function withdrawRemainingFunds() external only_owner {
        uint balance = address(this).balance;
        require(balance > 0, "No funds left in the contract");

        (bool success, ) = payable(auction_owner).call{value: balance}("");
        require(success, "Transfer failed");
    }

    // 출금 함수 (입찰자들이 자금을 출금)
    function withdraw() public override returns (bool) {
        uint amount = bids[msg.sender];
        require(amount > 0, "No funds to withdraw");

        bids[msg.sender] = 0;

        // 안전한 전송 방법 사용
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit WithdrawalEvent(msg.sender, amount);
        return true;
    }

    // 소유자 정보 반환 함수
    function get_owner() public view returns (address) {
        return auction_owner;
    }

    // 경매 상태를 업데이트하는 함수
    function updateAuctionState(auction_state newState) external only_owner {
        STATE = newState;
        emit StateUpdated(newState); // 상태 업데이트 이벤트 발생
    }
}
