
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
    "constant": false,
    "inputs": [],
    "name": "bid",
    "outputs": [
      {
        "name": "",
        "type": "bool"
      }
    ],
    "payable": true,
    "stateMutability": "payable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "cancel_auction",
    "outputs": [
      {
        "name": "",
        "type": "bool"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "destruct_auction",
    "outputs": [
      {
        "name": "",
        "type": "bool"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [],
    "name": "withdraw",
    "outputs": [
      {
        "name": "",
        "type": "bool"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function"
  },
  {
    "inputs": [
      {
        "name": "_biddingTime",
        "type": "uint256"
      },
      {
        "name": "_owner",
        "type": "address"
      },
      {
        "name": "_brand",
        "type": "string"
      },
      {
        "name": "_Rnumber",
        "type": "string"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": true,
        "name": "highestBidder",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "highestBid",
        "type": "uint256"
      }
    ],
    "name": "BidEvent",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "withdrawer",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "WithdrawalEvent",
    "type": "event"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "message",
        "type": "string"
      },
      {
        "indexed": false,
        "name": "time",
        "type": "uint256"
      }
    ],
    "name": "CanceledEvent",
    "type": "event"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "auction_end",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "auction_start",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "name": "bids",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "get_owner",
    "outputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "highestBid",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "highestBidder",
    "outputs": [
      {
        "name": "",
        "type": "address"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "Mycar",
    "outputs": [
      {
        "name": "Brand",
        "type": "string"
      },
      {
        "name": "Rnumber",
        "type": "string"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "STATE",
    "outputs": [
      {
        "name": "",
        "type": "uint8"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function"
  }
]
  );
var contractAddress = '0x2783eAA4BB06C2C15288b33AcF38226252a88E12';
// var auction = auctionContract.at(contractAddress); 
auctionContract.options.address = '0x2783eAA4BB06C2C15288b33AcF38226252a88E12';

function bid() {
var mybid = document.getElementById('value').value;

auctionContract.methods.bid().send({from: '0xa6623cc5264B05757852AD6aB663dB90E171080e', value: web3.utils.toWei(mybid, "ether"), gas: 200000}).then((result)=>{
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
auctionContract.methods.cancel_auction().call().then( (result)=>{
  console.log(result)
});
}



function Destruct_auction(){
auctionContract.methods.destruct_auction().call().then( (result)=>{
  console.log(result) //The auction is still open when now() time < auction_end time
});
// auctionContract.methods.destruct_auction().call({from: '0xAf91a82C2D968c6Ed3eeFe5dD90D860d011B7B0A'},function(error, result){
// console.log(result);
// }); 
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
 auctionContract.events.CanceledEvent( function(error, event){ 
console.log(event); 
})
.on("connected", function(subscriptionId){
    console.log(subscriptionId);
})
.on('data', function(event){
    console.log(event); // same results as the optional callback above
 $("#eventslog").html(event.args.message+' at '+event.args.time);
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