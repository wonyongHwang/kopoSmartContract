pragma solidity ^0.4.24;

contract Auction {
    address internal auction_owner;
    uint256 public auction_start;
    uint256 public auction_end;
    uint256 public highestBid;
    address public highestBidder;
    uint public count;
    
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
    
    modifier an_ongoing_auction(){
        require(now <= auction_end);
        _;
    }
    
    modifier only_owner(){
        require(msg.sender == auction_owner);
        _;
    }
    
    function bid() public payable returns (bool) {}
    function withdraw() public returns (bool) {}
    function cancel_auction() external returns (bool) {}
    
    event BidEvent(address indexed highestBidder, uint256 highestBid);
    event WithdrawalEvent(address withdrawer, uint256 amount);
    event CanceledEvent(string message, uint256 time);
}

contract MyAuction is Auction{
  
    constructor(uint _biddingTime, address _owner,string _brand,string _Rnumber) public  {
        auction_owner = _owner;
        auction_start=now;
        auction_end = auction_start + _biddingTime*1  hours;
        STATE=auction_state.STARTED;
        Mycar.Brand=_brand;
        Mycar.Rnumber=_Rnumber;
        
    }
 

 function bid() public payable an_ongoing_auction returns (bool){
    //  destruct_auction이 실행되었는지 확인하는 부분
     if(count < 1){
                 require(bids[msg.sender]+msg.value> highestBid,"You can't bid, Make a higher Bid");
        highestBidder = msg.sender;
        highestBid = msg.value;
        bidders.push(msg.sender);
        bids[msg.sender]=  bids[msg.sender]+msg.value;
        emit BidEvent(highestBidder,  highestBid);

        return true;
     } else {
        //  1번이라도 destruct_auction을 실행했다면 경매 중이 아니라는 메세지 출력
         revert("Auction is not in progress.");
     }
    }
    

function cancel_auction() external only_owner  an_ongoing_auction returns (bool){
        require(now < auction_end, "Auction has already ended");

        STATE=auction_state.CANCELLED;
        emit CanceledEvent("Auction Cancelled", now);
        return true;
     }
    

    // 작동되고 실행 시 전원에게 환불(90% 반환, 10% 주인)
function destruct_auction() external only_owner returns (bool) {
    // 경매 개시 시간 이후에 작동되게 수정함으로써, 작동이 가능해졌다
    // 이전에는 경매 종료 시간이후에만 detruct_auction이 가능했다.
    require(now > auction_start, "You can't destruct the contract, the auction is still open");
 
    // 경매 개최자가 먹게되는 10%부분
    uint fee = address(this).balance / 10;

    // 90% 환불
    for (uint i = 0; i < bidders.length; i++) {
        address bidder = bidders[i];
        uint amount = bids[bidder];
        if (amount > 0) {
            bids[bidder] = 0;
            uint bidderRefund = (amount * 9) / 10; // 90% refund to bidder
            require(bidder.send(bidderRefund), "Transfer to bidder failed");
        }
    }

    // 10%는 주인에게
    require(auction_owner.send(fee), "Transfer to owner failed");

    selfdestruct(auction_owner);

    count++;
    
    return true;
}



function withdraw() public returns (bool){
    // require(now > auction_end ,"You can't withdraw, the auction is still open"); 이 부분 때문에 환불이 안되었었다.
    uint amountToRefund;
    uint amountToOwner;

    amountToRefund = (bids[msg.sender] * 9) / 10; // 90% 환불
    amountToOwner = bids[msg.sender] - amountToRefund; // 10%는 소유자에게

    require(amountToRefund > 0, "No refund available.");

    bids[msg.sender] = 0;

    if (amountToRefund > 0) {
        msg.sender.transfer(amountToRefund); // 90% 환불
    }

    if (amountToOwner > 0) {
        auction_owner.transfer(amountToOwner); // 10% 소유자에게
    }

    emit WithdrawalEvent(msg.sender, amountToRefund);
    return true;
}



    
function get_owner() public view returns(address){
        return auction_owner;
    }
}