
function init(){
	if (index != null){
	index = window.localStorage["index"];
	}
	else{
		index = 0;
	}
	
}

/*Constructor for bid object
 * */

function bid(uname, IP, amount){
	this.uname = uname;
	this.IP = IP;
	this.amount = amount;
}


/*Constructor for auction object
 * */

function auction(productname, neighborIP, bid){
	this.productname = productname;
	this.neighborIP = neighborIP;
	this.bid = bid;
}

/*Stores new auctions into local storage
 * */

function storeAuction(){
	if (((document.getElementById('productName_Text').value) == '') && 
			((document.getElementById('neighborIP_Text').value) == '')
			&& ((document.getElementById('Bid_Text').value) == '')){
		alert('Please enter values');
	}
	else{
		var productname = document.getElementById('productName_Text').value;
		var neighborIP = document.getElementById('neighborIP_Text').value;
		var bidvalue = document.getElementById('Bid_Text').value;
		var mybid  = new bid(uname, IP, bidvalue);
		var myauction = new auction(productname,neighborIP, mybid);
		myauction.bidlist =  new Array();
		myauction.bidlist.push(mybid);
		window.localStorage["TestAuction" + index] = JSON.stringify(myauction);
		alert("Auction data stored with Auction ID: " + index);
		index++;
		window.localStorage["testAuctionindex"] = index;
	}
}

function storePredecessor(neighbor, category)
{
	window.localStorage["predecessor_" +  category] = neighbor;
}

function storeSuccessor(neighbor, category)
{
	window.localStorage["successor_" + category] = neighbor2;
}

function retrievePredecessor(category)
{
	return window.localStorage["predecessor_" + category];
}

function retrieveSucessor(category)
{
	return window.localStorage["successor_" + category];
}

function storeBackupPredecessor(neighbor, category)
{
	window.localStorage["predecessor_bak_" +  category] = neighbor;
}

function storeBackupSuccessor(neighbor, category)
{
	window.localStorage["successor_bak_" + category] = neighbor2;
}

function retrieveBackupPredecessor(category)
{
	return window.localStorage["predecessor_bak_" + category];
}

function retrieveBackupSucessor(category)
{
	return window.localStorage["successor_bak_" + category];
}

function storeParent(myparent, category)
{
	window.localStorage["parent_" + category] = myparent;
}

/*Retrieves auction based on Auction ID from local storage
 * */

function retrieveAuction(){
	var testindex =  document.getElementById('index_Text').value;
	if (testindex == ''){
		alert("Enter something!");
	}
	else{
		var myauction =  JSON.parse(window.localStorage["TestAuction" + testindex]);
		if (myauction != null){
			document.getElementById('index_Text').value = '';
			document.getElementById('bing').rows[0].cells[0].innerHTML = "Product: " + myauction.productname;
			document.getElementById('bing').rows[1].cells[0].innerHTML = "IP: " + myauction.neighborIP;
			var bidtext = "Bids:<br/><pre>";
			for (var i = 0; i < myauction.bidlist.length; i++){
				bidtext += "#" + (i + 1) + ": " + "	User: " + myauction.bidlist[i].uname + "\tIP: " + myauction.bidlist[i].IP + 
							"\tBid: " + myauction.bidlist[i].amount + "<br/>";
			}	
			bidtext += "</pre>";
			
			document.getElementById('bing').rows[2].cells[0].innerHTML = bidtext;
		}
		else{
			alert("Auction No " + testindex + " does not exist!");
			document.getElementById('index_Text').value = '';
			document.getElementById('bing').rows[0].cells[0].innerHTML = null;
			document.getElementById('bing').rows[1].cells[0].innerHTML = null;
			document.getElementById('bing').rows[2].cells[0].innerHTML = null;
		}
	}
}

/*Add bids to existing auctions based on auction ID
 * */

function addBid(){
	var testindex = document.getElementById('index_Text2').value;
	var myauction =  JSON.parse(window.localStorage["TestAuction" + testindex]);
	var uname = document.getElementById('Uname_Text2').value;
	var IP = document.getElementById('IP_Text2').value;
	var bidvalue = document.getElementById('Bid_Text2').value;
	var mybid = new bid(uname, IP, bidvalue);
	myauction.bidlist.push(mybid);
	window.localStorage["TestAuction" + testindex] = JSON.stringify(myauction);
}

/*Remove bid or auction based on auction ID and username
 * */

function remove(){
	var testindex = document.getElementById('index_Text3').value;
	var testAuction = document.getElementById('checkbox1').checked;
	if (testAuction == true){
		window.localStorage.removeItem("TestAuction" + testindex);
		alert("Auction No " + testindex + " withdrawn.");
	}
	else{
		var myauction =  JSON.parse(window.localStorage["TestAuction" + testindex]);
		if (myauction != null){
			var uname = document.getElementById('User_Text').value;
			var i;
			var bidremoved = false;
			for (i = 0; i < myauction.bidlist.length; i++ ){
				if (uname == myauction.bidlist[i].uname){
					myauction.bidlist.splice(i,1);
					bidremoved = true;
					break;
				}
			}
			if (!bidremoved){
				alert("No bids identifed with that username");
			}
			else{
				window.localStorage["TestAuction" + testindex] = JSON.stringify(myauction);
				alert("Bid for " + uname + " removed.");
			}
		}
		else{
			alert("Thats an incorrect Auction ID");
		}
	}
}

/*Clear local storage
 * */

function clearAll(){
	localStorage.clear();
}
