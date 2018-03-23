package {
	import flash.display.Sprite;

	public class PlayerHand extends Sprite {
		public var hand:Array;
		public var round:int;
		public var played:Boolean;
		public function PlayerHand() {
			played = false;
			hand = new Array;
		}
		
		function findSpot(card:Card, top:Number, out:Number):Number {
			if (top==out) {
				return top;
			}
			var mid:Number = Math.floor((top + out) / 2);
			if (card.isSameCard(hand[mid])) {
				return mid;
			}
			if (card.compareTo(hand[mid])>0) {
				return this.findSpot(card, mid + 1, out);
			} else {
				return this.findSpot(card, top, mid);
			}
		}
		function findRSpot(card:Card, top:Number, out:Number):Number {
			if (top==out) {
				return top;
			}
			var mid:Number = Math.floor((top + out) / 2);
			if (card.isSameCard(hand[mid])) {
				return mid;
			}
			if (card.sortRank(hand[mid])>0) {
				return this.findSpot(card, mid + 1, out);
			} else {
				return this.findSpot(card, top, mid);
			}
		}


		public function hasCard(cardname:String):Boolean{
			for (var k:Number=0; k<hand.length; k++) {

					if(hand[k].cardname==cardname){
						return true;
					}
				}
				return false;
		}
		
		public function sameCard(card:Card):Boolean{
			for (var k:Number=0; k<hand.length; k++) {

					if(hand[k]==card){
						return true;
					}
				}
				return false;
		}
		
		
		public function setScore(number:int){
			this.round = number;
		}
		public function retrieve(i:int):Card{
			return hand[i];
		}
		public function remove(i:int){
			hand.splice(i, 1);
		}
		
		public function removeCard(card:Card):void{
			for (var k:Number=0; k<hand.length; k++) {
					if(hand[k].getName()==card.getName()){
						remove(k);
						return;
					}
				}
		}
		
		public function discard(){
		for each (var card:Card in hand) {
			card.toDiscard();
				}
		}
		
		public function discardAI(){
			var toDiscard:PlayerHand = new PlayerHand;
			var failed:int = 0;
			trace("my hand was " + this);
			while(GameWindow.bottom.size()!=8){
				var club:Number = sumSuit("C");
				if(GameWindow.bottom.size() < 8)
				if((club - saveCards("C"))<4 && (club - saveCards("C"))>0)
					trash("C");
				var spade:Number = sumSuit("S");
				if(GameWindow.bottom.size() < 8)
				if((spade - saveCards("S"))<4 && (spade - saveCards("S"))>0)
					trash("S");
				var heart:Number = sumSuit("H");
				if(GameWindow.bottom.size() < 8)
				if((heart - saveCards("H"))<4 && (heart - saveCards("H"))>0)
					trash("H");
				var diamond:Number = sumSuit("D");
				if(GameWindow.bottom.size() < 8)
				if((diamond - saveCards("D"))<4 && (diamond - saveCards("D"))>0)
					trash("D");
				failed++;
				if(failed >3){
					trash("C");
					trash("D");
					trash("S");
					trash("H");
					if(GameWindow.bottom.size() < 8)
					transferTo(GameWindow.bottom, lowestTrump());
				}
				trace("the bottom is " + GameWindow.bottom);
			}
			trace("now my hand is " + this);
		}
		
		function size():Number{
			return hand.length;
		}
		
		function trash(suit:String):void{
			var suits:String = "23456789tjq";
			for(var j:Number = 0; j < suits.length; j++){
				var rank:String = suit + suits.charAt(j);
				var card = new Card(rank);
				if(hasCard(card) && !hasPair(card) && !card.isTrump()&& GameWindow.bottom.size() < 8)
					{
						trace("trashing " + card + " and the suit " + suit);
						transferTo(GameWindow.bottom, card);
			}
			}
		}
		
		function saveCards(suit:String):Number{
			var i:Number = 0;
			var rank:String = suit + "k";
			if(hasCard(rank)) i++;
			if(hasPair(new Card(rank))) i++;
			rank = suit + "1";
			if(hasCard(rank)) i++;
			if(hasPair(new Card(rank))) i++;
			var suits:String = "23456789tjq";
			for(var j:Number = 0; j < suits.length-1; j++){
				rank = suit + suits.charAt(j);
				var card = new Card(rank);
				if(hasPair(card) && !card.isTrump()) 
					i = i +2;
			}
			return i;
			
		}
		
		
		function pop():Card{
			return hand.pop();
		}
		
		function lowestTrump():Card{
			var ofsuits:PlayerHand = handOfTrump().copyMe();
			return ofsuits.lowest();
		}
		
		function runningDry():String{
			for each (var suit:String in GameWindow.suitArray) {
				if(sumSuit(suit) < 3 && sumSuit(suit) > 0){
					trace("I have <3 of " + suit);
					return suit;
				}
			}
			return "";
		}
		
		function allTrump():Boolean{
			var i:int = 0;
			for each (var suit:String in GameWindow.suitArray) {
				if(sumSuit(suit) == 0){
					i++;
				}
			}
			return i==3;
		}
		
		function getRandomSuit(suit:String):Card{
			var ofsuits:PlayerHand = new PlayerHand();
    		for(var i:Number = 0; i < hand.length; i++){
    			if (hand[i].returnSuit()==suit && !hand[i].isTrump())
    				ofsuits.hand.push(hand[i]);
    		}
    		var randomn:Number = (Decks.randomRange(ofsuits.size()-1));
    		if(GameWindow.pairs && ofsuits.size()==1 && ofsuits.retrieve(0).isClicked()){
				randomn = (Decks.randomRange(hand.length-1));
				while(hand[randomn].isClicked()){
					randomn = (Decks.randomRange(hand.length-1));
				}
				return hand[randomn];
			} else if(ofsuits.size()!= 0){
				while(ofsuits.retrieve(randomn).isClicked()){
				randomn = (Decks.randomRange(ofsuits.size()-1));
				} 
				return ofsuits.retrieve(randomn);
			}else{
				randomn = (Decks.randomRange(hand.length-1));
				while(hand[randomn].isClicked()){
					randomn = (Decks.randomRange(hand.length-1));
				}
				return hand[randomn];
			}
		}
		function getRandomCard():Card{
				var randomn:Number = (Decks.randomRange(hand.length-1));
				while(hand[randomn].isClicked()){
					randomn = (Decks.randomRange(hand.length-1));
				}
				return hand[randomn];
		}
		
		
		function getRandomTrump():Card{
			var ofsuits:PlayerHand = new PlayerHand();
    		for(var i:Number = 0; i < hand.length; i++){
    			if (hand[i].isTrump())
    				ofsuits.hand.push(hand[i]);
    		}
    		var randomn:Number = (Decks.randomRange(ofsuits.size()-1));
			if(ofsuits.size()!= 0){
    		return ofsuits.retrieve(randomn);
			}
			else{
				var randomn:Number = (Decks.randomRange(hand.length-1));
				return hand[randomn];
			}
		}
		
		function getSmallestNonPointTrumps():Card{
			var ofsuits:PlayerHand = handOfTrump().copyMe();
			if (ofsuits.size()!=0 && !ofsuits.lowest().isPoints()){
				return ofsuits.lowest();//if dont have points, but have suit, trash smallest suit
			}
			else if(ofsuits.size()==0) return smallestNonPointRandomSuit();
			else return ofsuits.lowest();
		}
		
		function getLast(number:int):Array{
			var toSend:Array = new Array;
			for(var i:int = 0; i < number; i++){
				toSend.push(hand[hand.length-1+i]);
			}
			return toSend;
		}
		
		function smallestNonPointRandomSuit():Card{
			var suit:String = Card.getRandomSuit();
			var ofsuits:PlayerHand = handOfSuit(suit).copyMe();
			while(suit==GameWindow.trump || ofsuits.size()==0){
				suit = Card.getRandomSuit();
				ofsuits = handOfSuit(suit).copyMe();
				
			}
			var card:Card = ofsuits.lowest();
			var i:int = ofsuits.size();
			while(card.isPoints() || i>=0){
				card = ofsuits.retrieve(i--);
			}
			if(i==-1) return card;//if dont have points, but have suit, trash smallest suit
			return ofsuits.lowest();
		}
		
		function getSmallestSuit(suit:String):Card{
			var ofsuits:PlayerHand = handOfSuit(suit).copyMe();
			if (ofsuits.size()!=0){
				return ofsuits.lowest();;//if dont have points, but have suit, trash smallest suit
			}
			else return smallestRandomSuit();
		}
		
		function getSmallest(suit:String):Card{
			var thesuit:PlayerHand = handOfSuit(suit).copyMe(); 
			return thesuit.lowest();
		}
		function getSmallestNH(suit:String):Card{
			var thesuit:PlayerHand = handOfSuitNH(suit).copyMe(); 
			return thesuit.lowest();
		}
		
		function smallestRandomSuit():Card{
			var suit:String = Card.getRandomSuit();
			var ofsuits:PlayerHand = handOfSuit(suit).copyMe();
			while(suit==GameWindow.trump || ofsuits.size()==0){
				suit = Card.getRandomSuit();
				ofsuits = handOfSuit(suit).copyMe();
				
			}
			return ofsuits.lowest();//if dont have points, but have suit, trash smallest suit
		}
		
		function getRandomNonPoints(suit:String):Card{
			var ofsuits:PlayerHand = handOfSuit(suit);
			var nonPoints:PlayerHand = new PlayerHand();
    		for(var i:Number = 0; i < ofsuits.size(); i++){
    			if (!ofsuits.retrieve(i).isPoints()){
					nonPoints.includein(ofsuits.retrieve(i));
				}
    		}
    		var randomn:Number = (Decks.randomRange(nonPoints.size()-1));
			if(nonPoints.size()!= 0){
    		return nonPoints.retrieve(randomn);
			}
			else if (ofsuits.size()!=0){
				var randomn:Number = (Decks.randomRange(ofsuits.size()-1));
				return ofsuits.retrieve(randomn);
			}
			else if(hasNonPoints()){	
			nonPoints = new PlayerHand();
			for(var i:Number = 0; i < size(); i++){
				if (!retrieve(i).isPoints()){
					nonPoints.includein(retrieve(i));
				}
			}
			var randomn:Number = (Decks.randomRange(nonPoints.size()-1));
			return nonPoints.retrieve(randomn);
			}
			else {	
			return getRandomCard();
			}

		}
		
		function getSmallestPoints(suit:String):Card{
			var ofsuits:PlayerHand = handOfSuit(suit);
			var ofPoints:PlayerHand = new PlayerHand();
    		for(var i:Number = 0; i < ofsuits.size(); i++){
    			if (ofsuits.retrieve(i).isPoints()){
					ofPoints.includein(ofsuits.retrieve(i));
				}
    		}
			if(ofPoints.size()!= 0){//if you have points in the suit
    		return ofPoints.retrieve(ofPoints.size()-1);//play smallest point
			}
			else if (ofsuits.size()!=0){//if you have the suit
				return ofsuits.retrieve(ofsuits.size()-1);//play smallest card
			}
			else if(hasNonTrumpPoints()){ //if you have points in other suits
			trace("i have points in other suit");
			ofPoints = new PlayerHand();
			for(var i:Number = 0; i < size(); i++){
				if (retrieve(i).isPoints() && !retrieve(i).isTrump()){//if it is points and not trump
					ofPoints.includein(retrieve(i));
				}
			}
			trace("and that hand is " + ofPoints);
			return ofPoints.retrieve(ofPoints.size()-1);//play it
			}
			else {	
			return getRandomCard();//otherwise play a random card
			}

		}
		
		function getSmallestPoint(suit:String):Card{
			var ofPoints:PlayerHand = handOfPoints(suit).copyMe(); 
			return ofPoints.lowest();
		}
		function getSmallestPointNH(suit:String):Card{
			var ofPoints:PlayerHand = handOfPointsNH(suit).copyMe(); 
			return ofPoints.lowest();
		}
		function getSmallestNonPoint(suit:String):Card{
			var ofPoints:PlayerHand = handOfNonPoints(suit).copyMe();
			trace("ofpoinst is " + ofPoints);
			return ofPoints.lowest();
		}
		function getSmallestNonPointNH(suit:String):Card{
			var ofPoints:PlayerHand = handOfNonPointsNH(suit).copyMe(); 
			return ofPoints.lowest();
		}
		
		function firstCard():Card{
			return hand[0];
		}
		function numTrumps():Number{
			var number:Number = 0;
    		for(var i:Number = 0; i < hand.length; i++){
    			if (hand[i].isTrump())
    				number++;
    		}
			return number;
		}
		public override function toString():String {
			return String(hand);
		}
		public function empty():void{
			hand = new Array;
		}
		
		public function includein(card:Card):void{
			hand.push(card);
		}
		public function isempty():Boolean{
			return hand.length==0;
		}
		
		public function determineLargest(suit:String):Card{
			var temp = new PlayerHand();
    	for(var i:int = 0; i < hand.length; i++){
    		if (hand[i].returnSuit()==suit || hand[i].isTrump())
    			temp.includein(hand[i]);
    	}
    	return temp.largest();
		}
		
		public function largestOfSuit(suit:String):Card{
			var temp = new PlayerHand();
    	for(var i:int = 0; i < hand.length; i++){
    		if (hand[i].returnSuit()==suit && !hand[i].isTrump())
    			temp.includein(hand[i]);
    	}
    	return temp.largest();
		}
		
		public function determineBiggestPair(suit:String):Card{
			var temp = new PlayerHand();
    	for(var i:int = 0; i < hand.length; i++){
    		if (hand[i].returnSuit()==suit && isPair(hand[i]) || hand[i].isTrump()&& isPair(hand[i]))
    			temp.includein(hand[i]);
    	}
    	return temp.largest();
		}
		
		public function largest():Card{
    	failSort();
    	return hand[0];
    	}
		
		public function lowest():Card{
    	rankSort();
		var toSend:Card = hand[hand.length-1];
		trace("the hand is " + hand + " and tosend aka the lowest is " + toSend);
		var i:int = 1;
		while(toSend.isClicked()){
    		toSend = hand[hand.length-i];
			i++;
			}
		trace("tosend is now " + toSend);
		return toSend;
    	}
		
		public function lowestPoint():Card{
    		failSort();
    		for(var i:int = hand.length -1; i >= 0; i--){
				trace(hand[i] + " is this lowest point card");
    			if (hand[i].isPoints)
    				return hand[i]
    		}
			return hand[hand.length-1];
    	}
		
		function failSort():void{
			var temp:Array = new Array;
			while(hand.length != 0){
				temp.push(hand.pop());
			}
			for each(var card:Card in temp){
				badSortIn(card);
			}
		}
		function rankSort():void{
			var temp:Array = new Array;
			while(hand.length != 0){
				temp.push(hand.pop());
			}
			for each(var card:Card in temp){
				rSortIn(card);
			}
		}
		
		public function badSortIn(card:Card):void{
			var mySpot=findSpot(card,0,hand.length);
			insert(card, mySpot);
		}
		public function rSortIn(card:Card):void{
			var mySpot=findRSpot(card,0,hand.length);
			insert(card, mySpot);
		}
		
		public function transferTo(target:PlayerHand, card:Card):void{
			target.addC(card);
			this.removeCard(card);
			
		}
		
		function insert(card:Card, spot:Number):void {
			if (spot<hand.length) {
				var temp:Card;
				temp=hand[spot];
				hand[spot]=card;
				insert(temp, spot+1);
			} else {
				includein(card);
			}
		}
		
		
		public function firstS():String{
			return firstCard().returnSuit();
		}
		
		public function getIndex(c:Card):int{
    	for(var i:int = 0; i < hand.length; i++){
			if (hand[i].isSameCard(c))
    			return i;
    	}
    	return -1;
    }
	
	public function hasSuit(suit:String):Boolean{
    	for(var i:int = 0; i < hand.length; i++){
    		if ((hand[i].returnSuit()==suit && !hand[i].isTrump()) ||(hand[i].isTrump() && suit == GameWindow.trump) ||(hand[i].isTrump() && suit == "trump") )
    			return true;
    	}
    	return false;
    }
	
	public function numSuit(suit:String, rank:String):Number{
		var count:Number = 0;
    	for(var i:int = 0; i < hand.length; i++){
    		if ((hand[i].returnSuit()==suit && hand[i].returnValue != rank ) )
    			count++
    	}
    	return count;
    }
	
	public function numRank(rank:String):Number{
		var count:Number = 0;
    	for(var i:int = 0; i < hand.length; i++){
    		if ((hand[i].returnValue()==rank) )
    			count++
    	}
    	return count;
    }
	
	public function numJokers():Number{
		var count:Number = 0;
    	for(var i:int = 0; i < hand.length; i++){
    		if ((hand[i].returnSuit()=="J") )
    			count++
    	}
    	return count;
    }
	
	public function getPoints():Number{
		var point:Number = 0;
    	for(var i:int = 0; i < hand.length; i++){
    		if (hand[i].isFive())
				point += 5;
			if(hand[i].isTen())
				point+=10;
    	}
		return point;
    }
	
	
	public function hasNoPoints(suit:String):Boolean{
    	for(var i:int = 0; i < hand.length; i++){
    		if ((!hand[i].isClicked()&&suit=="trump"&&hand[i].isTrump()&&hand[i].isPoints())||(!hand[i].isClicked()&&!hand[i].isTrump() &&hand[i].returnSuit()==suit&&hand[i].isPoints())||(!hand[i].isClicked()&&suit=="nontrump"&&!hand[i].isTrump()&&hand[i].isPoints())){
				return false;
			}
    	}
		return true;
    }
	public function hasPoints(suit:String, number:Number):Boolean{
		var point:Number = 0;
    	for(var i:int = 0; i < hand.length; i++){
    		if ((!hand[i].isClicked()&&suit=="trump"&&hand[i].isTrump()&&hand[i].isPoints())||(!hand[i].isClicked()&&!hand[i].isTrump() &&hand[i].returnSuit()==suit&&hand[i].isPoints())||(!hand[i].isClicked()&&suit=="nontrump"&&!hand[i].isTrump()&&hand[i].isPoints())){
				point++;
				if(point==number) return true;
			}
    	}
		return false;
    }
	public function haveNonPoints(suit:String, number:Number):Boolean{
		var point:Number = 0;
    	for(var i:int = 0; i < hand.length; i++){
    		if ((!hand[i].isClicked()&&suit=="trump"&&hand[i].isTrump()&&!hand[i].isPoints())||(!hand[i].isClicked()&&!hand[i].isTrump() && hand[i].returnSuit()==suit&&!hand[i].isPoints())||(!hand[i].isClicked()&&suit=="nontrump"&&!hand[i].isTrump()&&!hand[i].isPoints())){
				point++;
				if(point==number) return true;
			}
    	}
		return false;
    }
	public function hasNonPointsNH(suit:String, number:Number):Boolean{
		var point:Number = 0;
    	for(var i:int = 0; i < hand.length; i++){
    		if ((!hand[i].isClicked()&&hand[i].isTrump() &&!hand[i].isPoints())|| (!hand[i].isClicked()&&hand[i].returnSuit()!=suit&&!hand[i].isPoints())){
				point++;
				if(point==number) return true;
			}
    	}
		return false;
    }
	
	public function hasPointsNH(suit:String, number:Number):Boolean{
		var point:Number = 0;
    	for(var i:int = 0; i < hand.length; i++){
    		if ((!hand[i].isClicked()&&hand[i].isTrump() &&hand[i].isPoints())|| (!hand[i].isClicked()&&hand[i].returnSuit()!=suit&&hand[i].isPoints())){
				point++;
				if(point==number) return true;
			}
    	}
		return false;
    }
	
	public function hasNonPoints():Boolean{
    	for(var i:int = 0; i < hand.length; i++){
    		if (hand[i].isPoints())
				return false;
    	}
		return true;
    }
	public function hasNonTrumpPoints():Boolean{
    	for(var i:int = 0; i < hand.length; i++){
    		if (hand[i].isPoints() && !hand[i].isTrump())
				return true;
    	}
		return false;
    }
	
	public function hasTrump():Boolean{
		for(var i:int = 0; i < hand.length; i++){
    		if (hand[i].isTrump())
    			return true;
    	}
    	return false;
	}
	
		public function hasTrumpPoints():Boolean{
		for(var i:int = 0; i < hand.length; i++){
    		if (hand[i].isTrump()&&hand[i].isTrump())
    			return true;
    	}
    	return false;
	}
	
	
	public function hasPair(card:Card):Boolean{
		var count:Number = 0;
		for(var i:int = 0; i < hand.length; i++){
    		if (hand[i].isSameCard(card))
    			count++;
    	}
    	return count==2;
	}
	public function isPair(card:Card):Boolean{
		var myIndex:Number = getIndex(card);
		if(myIndex % 2 == 0){ //if it is even, so like 0/1 or 2/3
			if(hand[myIndex+1].isSameCard(card)) {
				return true;
			}
		}
		return false;
	}
	
	public function numPTrump(card:Card):Number{
		var potentialSuit:String = card.returnSuit();
		var potentialRank:String = card.returnValue();
		return numSuit(potentialSuit, potentialRank) + numRank(potentialRank) + numJokers();
	}
	
	 function resort():void{
	 }
		public function addC(card:Card):void {
		}
		public function getAll():Array {
			return hand;
		}
		public function includeHand(other:Array):void {
			for(var j:int = 0; j<other.length; j++){
					hand.push(other[j]);
				}
		}
		public function copyMe():PlayerHand {
			var other:PlayerHand = new PlayerHand;
			other.includeHand(hand);
			return other;
		}
		
		public function stealFrom(other:Array):void {
			while(other.length!=0){
				addC(other.pop());
			}
		}
	
		public function arrayOfRandomTrumpPair():Array{
			var allPairs:Array = new Array;
			for(var j:int = 0; j<hand.length; j++){
					if(retrieve(j).isTrump() && hasPair(retrieve(j))){
						allPairs.push(retrieve(j));
					}
				}
			var randomn:Number = (Decks.randomRange(allPairs.length-1));
			var toReturn:Array = new Array;
			toReturn.push(allPairs[randomn]);
			for(var j:int = 0; j<hand.length; j++){
					if(toReturn[0]!=retrieve(j)&&toReturn[0].isSameCard(retrieve(j))){
						toReturn.push(retrieve(j));
					}
				}
			return toReturn;
		}
		public function arrayOfRandomPair(suit:String):Array{
			var allPairs:Array = new Array;
			for(var j:int = 0; j<hand.length; j++){
					if(retrieve(j).returnSuit() == suit && hasPair(retrieve(j)) && !retrieve(j).isTrump()){
						allPairs.push(retrieve(j));
					}
				}
			var randomn:Number = (Decks.randomRange(allPairs.length-1));
			var toReturn:Array = new Array;
			toReturn.push(allPairs[randomn]);
			for(var j:int = 0; j<hand.length; j++){
					if(toReturn[0]!=retrieve(j)&&toReturn[0].isSameCard(retrieve(j))){
						toReturn.push(retrieve(j));
					}
				}
			return toReturn;
		}
		

		public function play(card:Card, k:int):void{
		}
		
		public function canBeat(card:Card):Boolean{
			if(!card.isTrump()){
				if(hasSuit(card.returnSuit())){
					trace("I have the suit of card" + card);
					if(handOfSuit(card.returnSuit()).largest().compareTo(card) < 0){
						trace("the card that can beat it is " + handOfSuit(card.returnSuit()).largest());
						return true;
					}
				}else return hasTrump();
			} else if(!GameWindow.pile.firstCard().isTrump() && hasSuit(GameWindow.pile.firstS()))
			{ 
			return false;
			} else if(hasTrump()){
				if(handOfTrump().largest().compareTo(card) < 0)
					return true;
			}
			else return false;
			return false;
		}
		
		public function canBeatWithPoints(card:Card):Boolean{
			trace("we want to beat a " + card + " with points");
			if(!card.isTrump()){
				trace("the card is not trump");
				if(hasSuit(card.returnSuit())){
					for(var j:int = 0; j<handOfSuit(card.returnSuit()).size(); j++){
						if(handOfSuit(card.returnSuit()).retrieve(j).compareTo(card) < 0 && handOfSuit(card.returnSuit()).retrieve(j).isPoints()){
							trace(handOfSuit(card.returnSuit()).retrieve(j) + " is this card that i can beat with points");
							return true;
						}
					}
				}else {
					trace(" do i have trump points? "+  hasTrumpPoints());
					return hasTrumpPoints();
				}
			} else if(!GameWindow.pile.firstCard().isTrump() && hasSuit(GameWindow.pile.firstS())){
																			return false;
																								 } else if(hasTrump()){
				for(var j:int = 0; j<handOfTrump().size(); j++){
				if(handOfTrump().retrieve(j).compareTo(card) < 0 && handOfTrump().retrieve(j).isPoints()){
					trace("the card is trump and i have trump and this card is trump points: " + handOfTrump().retrieve(j));
					return true;
				}
				}
			}
			else return false;
			return false;
		}
		
		public function handOfSuit(suit:String):PlayerHand{
			var handsuit:PlayerHand = new PlayerHand;
			for(var j:int = 0; j<hand.length; j++){
					if((!retrieve(j).isTrump() && retrieve(j).returnSuit()==suit )|| (retrieve(j).isTrump() &&suit=="trump" ) || (!retrieve(j).isTrump() &&suit=="nontrump" )){
						handsuit.includein(retrieve(j));
					}
				}
			return handsuit;
		}
		public function handOfSuitNH(suit:String):PlayerHand{
			var handsuit:PlayerHand = new PlayerHand;
			for(var j:int = 0; j<hand.length; j++){
					if(retrieve(j).isTrump() || retrieve(j).returnSuit()!=suit ){
						handsuit.includein(retrieve(j));
					}
				}
			return handsuit;
		}
		
		public function handOfPoints(suit:String):PlayerHand{
			var handsuit:PlayerHand = new PlayerHand;
			for(var j:int = 0; j<hand.length; j++){
					if((!retrieve(j).isTrump() && retrieve(j).returnSuit()==suit && retrieve(j).isPoints() )|| (retrieve(j).isTrump() && retrieve(j).isPoints()&&suit=="trump" ) || (!retrieve(j).isTrump() && retrieve(j).isPoints()&&suit=="nontrump" )){
						handsuit.includein(retrieve(j));
					}
				}
			return handsuit;
		}
		
		public function handOfPointsNH(suit:String):PlayerHand{//hand of points that arent this suit, includes trump points
			var handsuit:PlayerHand = new PlayerHand;
			for(var j:int = 0; j<hand.length; j++){
					if((retrieve(j).isTrump()&& retrieve(j).isPoints())||(retrieve(j).returnSuit()!=suit && retrieve(j).isPoints())){
						handsuit.includein(retrieve(j));
					}
				}
			return handsuit;
		}
		public function handOfNonPoints(suit:String):PlayerHand{
			var handsuit:PlayerHand = new PlayerHand;
			for(var j:int = 0; j<hand.length; j++){
					if((!retrieve(j).isTrump() && retrieve(j).returnSuit()==suit && !retrieve(j).isPoints() )|| (retrieve(j).isTrump() && !retrieve(j).isPoints()&&suit=="trump" )||(!retrieve(j).isTrump() && !retrieve(j).isPoints()&&suit=="nontrump" )){
						handsuit.includein(retrieve(j));
					}
				}
			return handsuit;
		}
		
		public function handOfNonPointsNH(suit:String):PlayerHand{
			var handsuit:PlayerHand = new PlayerHand;
			for(var j:int = 0; j<hand.length; j++){
					if((retrieve(j).isTrump()&&!retrieve(j).isPoints())||(retrieve(j).returnSuit()!=suit && !retrieve(j).isPoints()) ){
						handsuit.includein(retrieve(j));
					}
				}
			return handsuit;
		}
		
		public function handOfTrump():PlayerHand{
			var handsuit:PlayerHand = new PlayerHand;
			for(var j:int = 0; j<hand.length; j++){
					if(retrieve(j).isTrump()){
						handsuit.includein(retrieve(j));
					}
				}
			return handsuit;
		}
		
		public function sumSuit(suit:String):Number{
		var count:Number = 0;
    	for(var i:int = 0; i < hand.length; i++){
			if ((!hand[i].isClicked()&&hand[i].returnSuit()==suit && !hand[i].isTrump())||(!hand[i].isClicked()&&hand[i].isTrump() && suit=="trump") )
    			count++;
    	}
		//trace("my sum of the suit " + suit + " is " + count);
    	return count;
  	  }
	  
	  public function clickedSize():Number{
		var count:Number = 0;
    	for(var i:int = 0; i < hand.length; i++){
			if (hand[i].isClicked())
    			count++;
    	}
		//trace("my sum of the suit " + suit + " is " + count);
    	return count;
  	  }
	  
	  public function getClicked():Array{
		var count:Array = new Array;
    	for(var i:int = 0; i < hand.length; i++){
			if (hand[i].isClicked())
    			count.push(hand[i]);
    	}
		//trace("my sum of the suit " + suit + " is " + count);
    	return count;
  	  }
		public function getPoint(suit:String):Card{
    	var ofPoints:PlayerHand = handOfPoints(suit).copyMe(); 
		return ofPoints.getRandomCard();//COULD CHANGE THIS? BUT MAKE SURE IT PICKS TWO DIFF CARDS
   		}
		public function getPointNH(suit:String):Card{//not this suit this means
    	var ofPoints:PlayerHand = handOfPointsNH(suit).copyMe();//hand of points that arent this suit 
		return ofPoints.getRandomCard();//COULD CHANGE THIS? BUT MAKE SURE IT PICKS TWO DIFF CARDS
   		}
	}
}