
// var web3 = new Web3();
var web3 = new Web3('ws://localhost:7545');
 
// web3.setProvider(new web3.providers.HttpProvider("http://localhost:7545"));

var bidder;
//=   web3.eth.getAccounts(); // web3.eth.accounts[0];
web3.eth.getAccounts().then(function(acc){
  // bidder=acc;
  console.log(acc)
  web3.eth.defaultAccount = acc[0]
  bidder = acc[0]

  auctionContract.methods.auction_end().call().then( (result)=>{
document.getElementById("auction_end").innerHTML=result;
});

  auctionContract.methods.highestBidder().call().then( (result)=>{
document.getElementById("HighestBidder").innerHTML=result;
}); 
    
auctionContract.methods.highestBid().call().then( (result)=>{
console.log("highest bid info: ", result)
var bidEther = web3.utils.fromWei(web3.utils.toBN(result), 'ether');
document.getElementById("HighestBid").innerHTML=bidEther;

}); 
  auctionContract.methods.STATE().call().then( (result)=>{
document.getElementById("STATE").innerHTML=result;

}); 

  auctionContract.methods.Mycar().call().then( (result)=>{
    
  
    document.getElementById("car_brand").innerHTML=result[0];
    document.getElementById("registration_number").innerHTML=result[1];
  
}); 

auctionContract.methods.bids(bidder).call().then( (result) => {
  
    var bidEther = web3.utils.fromWei(web3.utils.toBN(result), 'ether');
    document.getElementById("MyBid").innerHTML=bidEther;

    console.log(bidder);
 
}); 




});
// web3.eth.defaultAccount = bidder;
var auctionContract =  new web3.eth.Contract(
[
  {
    "inputs": [],
    "name": "bid",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "payable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "uint256",
        "name": "_biddingTime",
        "type": "uint256"
      },
      {
        "internalType": "address",
        "name": "_owner",
        "type": "address"
      },
      {
        "internalType": "string",
        "name": "_brand",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "_Rnumber",
        "type": "string"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "internalType": "address",
        "name": "highestBidder",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "highestBid",
        "type": "uint256"
      }
    ],
    "name": "BidEvent",
    "type": "event"
  },
  {
    "inputs": [],
    "name": "cancel_auction",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "message",
        "type": "uint256"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "time",
        "type": "uint256"
      }
    ],
    "name": "CanceledEvent",
    "type": "event"
  },
  {
    "inputs": [],
    "name": "deactivateAuction",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "enum Auction.auction_state",
        "name": "newState",
        "type": "uint8"
      }
    ],
    "name": "StateUpdated",
    "type": "event"
  },
  {
    "inputs": [
      {
        "internalType": "enum Auction.auction_state",
        "name": "newState",
        "type": "uint8"
      }
    ],
    "name": "updateAuctionState",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "withdraw",
    "outputs": [
      {
        "internalType": "bool",
        "name": "",
        "type": "bool"
      }
    ],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "internalType": "address",
        "name": "withdrawer",
        "type": "address"
      },
      {
        "indexed": false,
        "internalType": "uint256",
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "WithdrawalEvent",
    "type": "event"
  },
  {
    "inputs": [],
    "name": "withdrawRemainingFunds",
    "outputs": [],
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "auction_end",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "auction_start",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "name": "bids",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "get_owner",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "highestBid",
    "outputs": [
      {
        "internalType": "uint256",
        "name": "",
        "type": "uint256"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "highestBidder",
    "outputs": [
      {
        "internalType": "address",
        "name": "",
        "type": "address"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "Mycar",
    "outputs": [
      {
        "internalType": "string",
        "name": "Brand",
        "type": "string"
      },
      {
        "internalType": "string",
        "name": "Rnumber",
        "type": "string"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  },
  {
    "inputs": [],
    "name": "STATE",
    "outputs": [
      {
        "internalType": "enum Auction.auction_state",
        "name": "",
        "type": "uint8"
      }
    ],
    "stateMutability": "view",
    "type": "function"
  }
]
  );
var contractAddress = '0x48aD25108F4B84033C0E1ebB8724709B6B8bEEd8';
// var auction = auctionContract.at(contractAddress); 
auctionContract.options.address = '0x48aD25108F4B84033C0E1ebB8724709B6B8bEEd8';

function bid() {
var mybid = document.getElementById('value').value;

auctionContract.methods.bid().send({from: '0xbE6f814236Ba430F0A5AAeE0a269faCdbDc4F777', value: web3.utils.toWei(mybid, "ether"), gas: 200000}).then((result)=>{
  console.log(result)
  // 

  document.getElementById("biding_status").innerHTML="Successfull bid, transaction ID : "+ result.transactionHash; 

  
});

// Automatically determines the use of call or sendTransaction based on the method type
// auctionContract.methods.bid().call({value: web3.utils.toWei(mybid, "ether"), gas: 200000}, function(error, result){
//   if(error)	
//   {console.log("error is "+ error); 
//   document.getElementById("biding_status").innerHTML="Think to bidding higher"; 
//   }
//   if (!error)
//   document.getElementById("biding_status").innerHTML="Successfull bid, transaction ID"+ result; 
// });
  
} 
	

	
function init(){
 // setTimeout(() => alert("아무런 일도 일어나지 않습니다."), 3000);

 
}
   
var auction_owner=null;
auctionContract.methods.get_owner().call().then((result)=>{
  
      auction_owner=result;
     if(bidder!=auction_owner)
     $("#auction_owner_operations").hide();

})
  // auctionContract.methods.get_owner(function(error, result){
	 //  if (!error){
		//   auction_owner=result;
	 //   if(bidder!=auction_owner)
	 //   $("#auction_owner_operations").hide();
	 //  }

// }
// ); 
  
  
function cancel_auction(){
  // .auction_end().call().
// auctionContract.methods.cancel_auction().call().then( (result)=>{
//   console.log(result)
// });
auctionContract.methods.cancel_auction().send({from: '0xbE6f814236Ba430F0A5AAeE0a269faCdbDc4F777', gas: 200000}).then((res)=>{
// auctionContract.methods.cancel_auction().call({from: '0x3211BA2b204cdb231EF5616ec3cAd26043b71394'}).then((res)=>{
console.log(res);
}); 
}



function Destruct_auction(){
  

}
  


auctionContract.events.BidEvent(/*{highestBidder:"A",highestBid:"888"},*/function(error, event){ 
      console.log(event); 
  })
  .on("connected", function(subscriptionId){
      console.log(subscriptionId);
  })
  .on('data', function(event){
      console.log(event); // same results as the optional callback above
      $("#eventslog").html(event.returnValues.highestBidder + ' has bidden(' + event.returnValues.highestBid + ' wei)');

  })
  .on('changed', function(event){
      // remove event from local database
      console.log(event);
  })
  // var BidE 
/*filter.get(callback): Returns all of the log entries that fit the filter.
filter.watch(callback): Watches for state changes that fit the filter and calls the callback. See this note for details.*/
// var BidEvent = auctionContract.events.BidEvent(); // var BidEvent = auction.BidEvent(({}, {fromBlock: 0, toBlock: 'latest'});

  
//     BidEvent.watch(function(error, result){
//             if (!error)
//                 {
//                     $("#eventslog").html(result.args.highestBidder + ' has bidden(' + result.args.highestBid + ' wei)');
//                 } else {
 
//                     console.log(error);
//                 }
//         });

//  auctionContract.events.allEvents({fromBlock: 0}, function(error, event){ console.log(event); })
// .on("connected", function(subscriptionId){
//     console.log(subscriptionId);
// })
// .on('data', function(event){
//     console.log(event); // same results as the optional callback above
// })
// .on('changed', function(event){
//     // remove event from local database
// })
// .on('error', function(error, receipt) { // If the transaction was rejected by the network with a receipt, the second parameter will be the receipt.
    
// });


// var subscription = web3.eth.subscribe('CanceledEvent', function(error, result){
//     if (!error)
//         console.log(result);
// })
// .on("data", function(transaction){
//     console.log(transaction);
// });

// unsubscribes the subscription
// subscription.unsubscribe(function(error, success){
//     if(success)
//         console.log('Successfully unsubscribed!');
// });



 auctionContract.events.CanceledEvent( function(error, event){ 
  console.log(event); 
  })
  .on("connected", function(subscriptionId){
      console.log(subscriptionId);
  })
  .on('data', function(event){
      console.log(event); // same results as the optional callback above
   $("#eventslog").html(event.returnValues.message+' at '+event.returnValues.time);
  })
  .on('changed', function(event){
      // remove event from local database
  })
  .on('error', function(error, receipt){ // If the transaction was rejected by the network with a receipt, the second parameter will be the receipt.
   
  });

 // var CanceledEvent = auctionContract.events.CanceledEvent();
  
 //    CanceledEvent.watch(function(error, result){
 //            if (!error)
 //                {
	// 				                    console.log(result);

 //                    $("#eventslog").html(result.args.message+' at '+result.args.time);
 //                } else {
 
 //                    console.log(error);
 //                }
 //        });
	
  	 
// const filter = web3.eth.subscribe({
//   fromBlock: 0,
//   toBlock: 'latest',
//   address: contractAddress,
//   topics: [web3.utils.sha3('BidEvent(address,uint256)')]
// }, function(error, result){
//    if (!error)
//   console.log(result);
// })
 
// filter.get((error, result) => {
// 	   if (!error)
//   console.log(result);
//   //console.log(result[0].data);
 
// })