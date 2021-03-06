﻿package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Player extends Sprite {
		var played:Boolean=false;
		private var memory:Brain;
		public var number:String;
		public var round:int;
		public var hand:PlayerHand=new PlayerHand  ;
		public var jugg:Boolean;
		public var toPlay:PlayerHandHorizontal=new PlayerHandHorizontal  ;
		public var totalPoints:Number;
		public var ideclared:Boolean;
		public var declaredCard:Card;
		public var wantDeclare:Card;
		public var partnerCard:Card;
		public static var NONE:Player = new Player("999");

		public function Player(name:String) {
			totalPoints=0;
			jugg=false;
			this.number=name;
			switch (name) {
				case "2" :
					toPlay.setFirst(238, 306);
					break;
				case "3" :
					toPlay.setFirst(326, 70);
					break;
				case "4" :
					toPlay.setFirst(614, 70);
					break;
				default :
					toPlay.setFirst(702, 306);
			}
		}

		public function setScore(number:int) {
			this.round=number;
		}
		public override function toString():String {
			return number;
		}
		public function giveHand(hand:PlayerHand) {
			this.hand=hand;
			this.hand.setScore(round);
		}

		public function canDeclareS():Boolean {
			var myCard:String="S"+getRound();
			return hand.hasCard(myCard);
		}

		public function canOverturn(suit:String):Boolean {
			var myCard:String=suit+getRound();
			var toCheck:Card=new Card(myCard);
			return hand.hasPair(toCheck);
		}
		public function canFinalize(suit:String):Boolean {
			return hand.hasPair(GameWindow.trumpc);
		}
		public function canDeclareH():Boolean {
			var myCard:String="H"+getRound();
			return hand.hasCard(myCard);
		}
		public function canDeclareD():Boolean {
			var myCard:String="D"+getRound();
			return hand.hasCard(myCard);
		}
		public function canDeclareC():Boolean {
			var myCard:String="C"+getRound();
			return hand.hasCard(myCard);
		}
		public function hasCard(myCard:Card):Boolean {
			return hand.hasCard(myCard.getName());
		}

		public function discard():void {
			hand.discard();
		}
		public function discardAI():void {
			//trace("my hand is " + hand + " what is wrong?");
			hand.discardAI();
		}
		// GAME STRATEGY STARTS HERE!!!!!!

		//Playing a random card (easiest)
		public function go():void {
			toPlay.empty();
			/*if (!otherTeamHasSuit(GameWindow.leadingHand.firstCard().returnSuit())){
				trace("The other team does not have this suit.");
				}
				*/
			if (! GameWindow.pairs&&! GameWindow.consecutives) {
				if (GameWindow.getPlayed().size()==1) {
					trace("p2 strat");
					playerTwoStrategy();
				} else if (GameWindow.getPlayed().size()==2) {
					trace("p3 strat");
					playerThreeStrategy();
				} else if (GameWindow.getPlayed().size()==3) {
				trace("p4 strat");
				playerFourStrategy();
				} else if(GameWindow.getPlayed().size()==4){
				trace("p5strat");
				playerFiveStrategy();
				}
			} else if (GameWindow.pairs) {
				playRandomPair(GameWindow.leadingHand.firstCard().returnSuit());
			}
			submit();
		}

		public function submit():void{
		for (var j:int = 0; j<hand.size(); j++) {
				if (hand.retrieve(j).isClicked()) {
					toPlay.addC(hand.retrieve(j));
					var card:Card=hand.retrieve(j);
					hand.hand.splice(j,1);
					hand.play(card, j);
					j--;
				}
			}
			played=true;
			addChild(toPlay);
}
		public function canWin(pile:PlayerHand):Boolean {
			var oldPile = pile.copyMe();
			var winner:Card=oldPile.determineLargest(oldPile.firstS());
			if (!pile.firstCard().isTrump()&&winner.isTrump()) {
				if (hand.hasSuit(pile.firstS())) {
					trace("aw i can't beat it because the winner is trump and i have the suit");
					return false;
				}
			}
			return hand.canBeat(winner);
		}
		public function canWinWithPoints(pile:PlayerHand):Boolean {
			var oldPile = pile.copyMe();
			var winner:Card=oldPile.determineLargest(oldPile.firstS());
			return hand.canBeatWithPoints(winner);
		}
		public function beginRound():void {
			if (played) {
				toPlay.empty();
			}
			for (var j:int = 0; j<hand.size(); j++) {
				if (hand.retrieve(j).isClicked()) {
					hand.retrieve(j).setUnClicked();//so he starts all over
				}
			}
			
			GameWindow.pairs=false;
			playerOneStrategy();
			submit();
		}
		public function playRandomCard():void {
			mark(hand.getRandomCard());
		}
		public function playWinningCard(pile:PlayerHand):void {
			var oldPile = pile.copyMe();
			var toBeat:Card=oldPile.determineLargest(oldPile.firstS());
			if (canWinWithPoints(GameWindow.getPlayed())) {
				playWinningPointCard(GameWindow.getPlayed());
				return;
			}
			if (!toBeat.isTrump()) {
				var ableCards:PlayerHand=getBetterHand(toBeat);
				mark(ableCards.lowest());
			} else {
				var ableCards:PlayerHand=getBetterTrumps(toBeat);
				mark(ableCards.lowest());
			}
		}

		public function playWinningPointCard(pile:PlayerHand):void {
			var oldPile = pile.copyMe();
			var toBeat:Card=oldPile.determineLargest(oldPile.firstS());
			if (! toBeat.isTrump()) {
				var ableCards:PlayerHand=getBetterHand(toBeat);
				trace("the card is not trump and my able cards are " +  getBetterHand(toBeat));
				mark(ableCards.lowestPoint());
			} else {
				var ableCards:PlayerHand=getBetterTrumps(toBeat);
				trace("the card is trump and my able cards are " +  getBetterTrumps(toBeat));
				mark(ableCards.lowestPoint());
			}
		}


		public function clearit():void {
			removeChild(toPlay);
		}

		public function getBetterHand(card:Card):PlayerHand {
			var suitHand:PlayerHand=new PlayerHand  ;
			var betterHand:PlayerHand=new PlayerHand  ;
			if (hand.hasSuit(card.returnSuit())) {
				suitHand=hand.handOfSuit(card.returnSuit());
				for (var j:int = 0; j<suitHand.size(); j++) {
					if (suitHand.retrieve(j).compareTo(card)<0) {
						trace("this card is better: " + suitHand.retrieve(j));
						betterHand.includein(suitHand.retrieve(j));
					}
				}
			} else {
				betterHand=hand.handOfTrump();
				trace("just kidding i don't have the suit so my better hand is the trump");
			}
			trace("my hand that is better than a "  + card + " is " + betterHand);
			return betterHand;
		}
		public function getBetterTrumps(card:Card):PlayerHand {
			var suitHand:PlayerHand=hand.handOfTrump();
			var betterHand:PlayerHand=new PlayerHand  ;
			for (var j:int = 0; j<suitHand.size(); j++) {
				if (suitHand.retrieve(j).compareTo(card)<0) {
					betterHand.includein(suitHand.retrieve(j));
				}
			}
			return betterHand;
		}
		
		public function playPointCard(card:Card):void {
			var theSuit:String = card.returnSuit();
			if (card.isTrump()) theSuit = "trump";
			if(theSuit=="trump"){
					if(hand.hasPoints("trump", 1)){
						trace("i have points in trump");
						playSmallestPoints("trump");
					}
					else if(hand.sumSuit("trump")!=0){
						trace("i have no points in trump");
						playSmallest("trump");
					}
					else if(hand.hasPoints("nontrump", 1)){
						trace("i have points in nontrump");
						playPoint("nontrump");
					}
					else{
						trace("i have no points in nontrump");
						playSmallestNonPoints("nontrump");
					}
			}
			else{
					if(hand.hasPoints(theSuit, 1)){
						trace("i have points in the suit");
						playSmallestPoints(theSuit);
					}else if(hand.sumSuit(theSuit)!=0){
						trace("i do not have pts in the suit aw");
						playSmallest(theSuit);
					}else if(hand.hasPointsNH(theSuit, 1)){
						trace("i have points in non the suit");
						playPointNH(theSuit);
					}else{
						trace("all i have are nonpoints");
						playSmallestNonPointsNH(theSuit);
				}
		}
}
		
		
		public function playNonPointCard(card:Card):void{
			var theSuit:String = card.returnSuit();
			if (card.isTrump()) theSuit = "trump";
			if(theSuit=="trump"){
				if(hand.haveNonPoints("trump", 1)){
						trace("i have nonpoints in trump");
						playSmallestNonPoints("trump");
					}else if(hand.sumSuit("trump")!=0){
						trace("i have trumps");
						playSmallest("trump");//or the only trump w/e
					}else if (hand.haveNonPoints("nontrump", 1)){//so no trumps. do you have 2 nonpoints?
						trace("i have no trumps and nonpoints");
						playSmallestNonPoints("nontrump");
					}else{
						trace("i have nontrumps");
						playSmallest("nontrump");
					}
			} else{
					if(hand.haveNonPoints(theSuit, 1)){
						trace("i have non points in this suit");
						playSmallestNonPoints(theSuit);
					}else if(hand.sumSuit(theSuit)!=0){
						trace("i have all points in this suit :(");
						playSmallest(theSuit);//or the only trump w/e
					}else if (hand.hasNonPointsNH(theSuit, 1)){//so no trumps. do you have 2 nonpoints?
						trace("i have nonpoints in other suits so trash");
						playSmallestNonPointsNH(theSuit);
					}else{
						trace("all i have are points :(");
						playSmallestNH(theSuit);
			}
		}
		}
		
		public function playRandomPair(suit:String):void {
				if (GameWindow.leadingHand.firstCard().isTrump()) {
					if (hasTrumpPair()) {
						markAll(hand.arrayOfRandomTrumpPair());
						return;
					} else {
						pairStrategy();
					}
				} else {
					if (hasPair(suit)) {
						markAll(hand.arrayOfRandomPair(suit));
						return;
					} else {
						if(GameWindow.getPlayed().getPoints() > 0 &&!hand.hasSuit(suit)){
							if (hasTrumpPair()) {
								markAll(hand.arrayOfRandomTrumpPair());
								return;
							}
						}
						pairStrategy();
					}
				}

		}
		
		public function playPoint(suit:String):void {
			mark(hand.getPoint(suit));
		}
		
		
		public function playPointNH(suit:String):void {//non this suit
			mark(hand.getPointNH(suit));
		}
		
		public function playSmallestPoints(suit:String):void {
			mark(hand.getSmallestPoint(suit));
		}
		public function playSmallestPointsNH(suit:String):void {
			mark(hand.getSmallestPointNH(suit));
		}
		public function playSmallest(suit:String):void {
			mark(hand.getSmallest(suit));
		}
		public function playSmallestNH(suit:String):void {
			mark(hand.getSmallestNH(suit));
		}
		public function playSmallestNonPoints(suit:String):void {
			mark(hand.getSmallestNonPoint(suit));
		}
		public function playSmallestNonPointsNH(suit:String):void {
			mark(hand.getSmallestNonPointNH(suit));
		}
		
		public function pairStrategy():void {
			var theSuit:String = GameWindow.leadingHand.firstCard().returnSuit();
			var card:Card = GameWindow.leadingHand.firstCard();
			while(hand.clickedSize()!=2){
				trace("the cards that are clicked are " + hand.getClicked());
				if(winnerIsOnMyTeam()){
					trace("the winner is on my team so i am playing points");
					playPointCard(card);
				} else {
					trace("the winner is not on my team so i am trashing");
					playNonPointCard(card);
				}
			}
		}
		
		public function playerOneStrategy():void {
			trace("p1 strat!:");
			if(hasHighestPair() && GameWindow.getPlayed().size()==0){
				trace("playing a highest pair");
				playAHighestPair();
				GameWindow.pairs=true;
				return;
			} else if(hasHighest() && GameWindow.getPlayed().size()==0){
				trace("playing a highest card");
				playAHighest();
				return;
			}else if(havePairs()){
			GameWindow.pairs=true;
			playPair();
			return;
			}else{
				for each (var suit:String in GameWindow.suitArray) {
					if(otherTeamhasSuit(suit)&&!myTeamhasSuit(suit)&&hand.hasSuit(suit)){
						trace("the other team has " + suit + " and my team doesnt. a card would be " + hand.getRandomSuit(suit));
						mark(hand.getRandomSuit(suit));
						return;
					}
				}
			if(hand.runningDry() != "") {
				mark(hand.getRandomSuit(hand.runningDry()));
			trace("playing " + hand.runningDry() + " then");
			return;
			}
			if(hand.hasSuit("trump")&&(hand.sumSuit("trump")/hand.size()) > 0.4) {
				mark(hand.getSmallestNonPointTrumps());
			trace("playing trumps then");
			return;
			}trace("playing a random card..");
			playRandomCard();
			return;
			}
		}
		
		public function playerTwoStrategy():void {
			var theSuit:String = GameWindow.leadingHand.firstCard().returnSuit();
			var card:Card = GameWindow.leadingHand.firstCard();
			if((isUnbeatable(theWinningCard()) && winnerIsOnMyTeam())){
					trace("the winner is unbeatable and on my team");
					playPointCard(card);
			}else if(otherTeamhasSuit(theSuit)&&!hand.hasSuit(theSuit)&&canWin(GameWindow.getPlayed())){
					trace("I can beat this! I don't have it but the other team does.");
					playWinningCard(GameWindow.getPlayed());
			} else {
					trace("player 2 trashes");
					playNonPointCard(card);
				}
		}
		
		public function playerThreeStrategy():void {
			var theSuit:String = GameWindow.leadingHand.firstCard().returnSuit();
			var card:Card = GameWindow.leadingHand.firstCard();
			if((isUnbeatable(theWinningCard()) && winnerIsOnMyTeam())){
					trace("the winner is unbeatable and on my team");
					playPointCard(card);
			} else if(sameTeam(GameWindow.players[1]) && sameTeam(GameWindow.players[2])&&canWin(GameWindow.getPlayed())){
					trace("I can beat this! and my team has yet to go");
					playWinningCard(GameWindow.getPlayed());
			} else if(otherTeamhasSuit(theSuit)&&!hand.hasSuit(theSuit)&&canWin(GameWindow.getPlayed())){
					trace("I can beat this! I don't have it but the other team does. - player 3");
					playWinningCard(GameWindow.getPlayed());
			} else {
					trace("player 3 trashes");
					playNonPointCard(card);
			}
			
		}
		
		public function playerFourStrategy():void {
			var theSuit:String = GameWindow.leadingHand.firstCard().returnSuit();
			var card:Card = GameWindow.leadingHand.firstCard();
			if((isUnbeatable(theWinningCard()) && winnerIsOnMyTeam())||(winnerIsOnMyTeam()&&sameTeam(GameWindow.players[1]))){
				trace("either the winner is unbeatable and on my team or the other team went and the winner is on my team and is unbeatable");
				playPointCard(card);
			} else if(sameTeam(GameWindow.players[1])&&canWin(GameWindow.getPlayed())){
				trace("I can beat this! and the last guy is on my team");
				playWinningCard(GameWindow.getPlayed());
			} else if(!sameTeam(GameWindow.players[1])&&canWin(GameWindow.getPlayed()) && !memory.playerOut(GameWindow.players[1].getName(), theSuit)){
				trace("I can beat this! and the last guy is not on my team but he has the suit");
				playWinningCard(GameWindow.getPlayed());
			} else {
				trace("trash..");
				playNonPointCard(card);
			}
		}
		
		public function playerFiveStrategy():void {
			var card:Card = GameWindow.leadingHand.firstCard();
			var theSuit:String = GameWindow.leadingHand.firstCard().returnSuit();
			if(winnerIsOnMyTeam()){
				trace("the winner is on my team");
					playPointCard(card);
			} else if(canWin(GameWindow.getPlayed()) && GameWindow.pile.getPoints() > 0){
					trace("I can beat this! 5");
					playWinningCard(GameWindow.getPlayed());
				} else {
					("alas i must trash");
					playNonPointCard(card);
				}

		}
		
		public function playPair():void {
			var suitList:String = "SHDC";
			while(suitList.length!=0){
				var randomn:Number = (Decks.randomRange(suitList.length-1));
				var theSuit:String = suitList.charAt(randomn);
				suitList = suitList.replace(theSuit,"");
				if (hasPair(theSuit)) {
					markAll(hand.arrayOfRandomPair(theSuit));
					return;
				}
			}
			if (hasTrumpPair()) {
				markAll(hand.arrayOfRandomTrumpPair());
			} 
		}

		public function addPoints(i:Number):void {
			totalPoints+=i;
		}

		public function mark(card:Card):void {
			card.setClicked();
		}
		public function markAll(cardarray:Array):void {
			for (var i:int = 0; i < cardarray.length; i++) {
				cardarray[i].setClicked();
			}
		}

		public function hasTrumpPair():Boolean {
			for (var j:int = 0; j<hand.size(); j++) {
				if (hand.retrieve(j).isTrump()&&hand.hasPair(hand.retrieve(j))) {
					return true;
				}
			}
			return false;
		}


		public function hasPair(suit:String):Boolean {
			for (var j:int = 0; j<hand.size(); j++) {
				if (hand.retrieve(j).returnSuit()==suit&&hand.hasPair(hand.retrieve(j))&&! hand.retrieve(j).isTrump()) {
					return true;
				}
			}
			return false;
		}
		
		public function havePairs():Boolean {
			for (var j:int = 0; j<hand.size(); j++) {
				if (hand.hasPair(hand.retrieve(j)) && !hand.retrieve(j).isTrump()) {
					return true;
				}
			}
			for (var j:int = 0; j<hand.size(); j++) {
				if (hand.hasPair(hand.retrieve(j)) && hand.retrieve(j).isTrump() && hand.allTrump()) {
					return true;
				}
			}
			return false;
		}

		public function handSize():Number {
			return hand.size();
		}

		public function getPoints():Number {
			return totalPoints;
		}

		public function addRound(number:Number):void {
			round+=number;
			this.hand.setScore(round);
		}

		public function getRound():String {
			if (round>9) {
				if (round==10) {
					return "t";
				}
				if (round==11) {
					return "j";
				}
				if (round==12) {
					return "q";
				}
				if (round==13) {
					return "k";
				}
				if (round==14) {
					return "1";
				}
			}
			return String(round);
		}

		public function returnRound():Number {
			return round;
		}
		public function getName():String {
			return number;
		}
		function removetoPlay():void {
			toPlay.empty();
		}
		function resetPoints():void {
			totalPoints=0;
		}
		function purgeToPlay():void {
			toPlay.purge();
		}
		function resetMe():void {
			ideclared=false;
			declaredCard=null;
		}

		public function wantsToDeclare():Card {
			var spadeCard:String="S"+getRound();
			var heartCard:String="H"+getRound();
			var clubCard:String="C"+getRound();
			var diamondCard:String="D"+getRound();
			if (wouldDeclare(new Card(spadeCard))) {
				declaredCard=new Card(spadeCard);
				return declaredCard;
			} else if (wouldDeclare(new Card(heartCard))) {
				declaredCard=new Card(heartCard);
				return declaredCard;
			} else if (wouldDeclare(new Card(clubCard))) {
				declaredCard=new Card(clubCard);
				return declaredCard;
			} else if (wouldDeclare(new Card(diamondCard))) {
				declaredCard=new Card(diamondCard);
				return declaredCard;
			}
			return null;
		}

		public function havePairToDeclare():Card {
			var spadeCard:String="S"+getRound();
			var heartCard:String="H"+getRound();
			var clubCard:String="C"+getRound();
			var diamondCard:String="D"+getRound();
			if (wouldDeclare(new Card(spadeCard))&&canOverturn("S")) {
				declaredCard=new Card(spadeCard);
				return declaredCard;
			} else if (wouldDeclare(new Card(heartCard))&& canOverturn("H")) {
				declaredCard=new Card(heartCard);
				return declaredCard;
			} else if (wouldDeclare(new Card(clubCard))&& canOverturn("C")) {
				declaredCard=new Card(clubCard);
				return declaredCard;
			} else if (wouldDeclare(new Card(diamondCard))&& canOverturn("D")) {
				declaredCard=new Card(diamondCard);
				return declaredCard;
			}
			return null;
		}

		public function wouldDeclare(card:Card):Boolean {
			return (hand.hasCard(card.getName()) && hand.numPTrump(card) >= 10);
		}


		public function declare(card:Card):void {
			ideclared=true;
			GameWindow.trumpc=new Card(card.getName());
			GameWindow.trump=card.returnSuit();
			toPlay.addC(card);
			addChild(toPlay);
		}
		public function wantsToFinalizeOverTurn():Card {
			var spadeCard:String="S"+getRound();
			var heartCard:String="H"+getRound();
			var clubCard:String="C"+getRound();
			var diamondCard:String="D"+getRound();
			if (ideclared) {
				if (hand.hasPair(declaredCard)) {
					return declaredCard;
				} else {
					return null;
				}
			}
			return havePairToDeclare();
		}

		public function finalizeOverTurn(card:Card):void {
			GameWindow.trumpc=new Card(card.getName());
			GameWindow.trump=card.returnSuit();
			toPlay.addC(new Card(card.getName()));
			if (toPlay.size()!=2) {
				toPlay.addC(new Card(card.getName()));
			}
			trace("ai overturned and toplay is " + toPlay);
			addChild(toPlay);
		}

		public function callPartner(trump:Card):void {
			var suits:String="SHCD";
			var rank:String="123456789tjqk";
			var randomsuit:Number = (Decks.randomRange(suits.length-1));
			var randomrank:Number = (Decks.randomRange(rank.length-1));
			var toCall:Card = new Card("Jb");
			for(var j:Number = 0; j < suits.length-1; j++){
				var newC:String = suits.charAt(j) + "k";
				var card = new Card(newC);
				if(hand.hasCard(card) && !card.isTrump() && !hand.hasPair(new Card(suits.charAt(j) + "1"))) 
					var toCall:Card = new Card(suits.charAt(j) + "1");
			}
			while (toCall.isTrump()) {
				randomsuit = (Decks.randomRange(suits.length-1));
				randomrank = (Decks.randomRange(rank.length-1));
				toCall=new Card(suits.charAt(randomsuit)+rank.charAt(randomrank));
				if(hand.hasPair(toCall)) toCall.makeTrump();
			}
			trace("The card is " + toCall);
			partnerCard=toCall;
		}

		public function getCalledCard():Card {
			return partnerCard;
		}
		public function getCalledRank():String {
			return partnerCard.returnValue();
		}
		public function getCalledSuit():String {
			return partnerCard.returnSuit();
		}
		public function declared():void {
			ideclared=true;
		}
		public function isDeclared():Boolean {
			return ideclared;
		}
		public function winnerIsOnMyTeam():Boolean {
			if(canBe() && !GameWindow.hasPartner && memory.hasTraitor() && memory.essentiallyTraitor(theWinner())){
				trace("i can be on the team, but there is a traitor and the winner is the traitor");
				return false;
			}
			if(GameWindow.jugg.getName()==getName() && !GameWindow.hasPartner && memory.hasTraitor() && memory.essentiallyTraitor(theWinner())){
				trace("i am on the jugg, and there is a traitor and the winner is the traitor");
				return true;
			}
			else if (iAmOnTeam()&&onTeam(theWinner())) {
				trace("i am on team and so is the winner");
				return true;
			} else if (iAmAgainst() && against(theWinner())) {
				trace("i am against and so is the iwnner");
				return true;
			} else if(iAmAgainst() && !GameWindow.hasPartner && memory.hasTraitor() && !memory.essentiallyTraitor(theWinner())){//i am against and there is atraitor and its not this guy
				trace("i am against and there is a traitor and it is not this guy");
				return true;
			}
			return false;
		}
		
		public function sameTeam(player:Player):Boolean {
			if(canBe() && !GameWindow.hasPartner && memory.hasTraitor() && memory.essentiallyTraitor(player.getName())){
				return false;
			}
			if(iAmOnTeam() && !GameWindow.hasPartner && memory.hasTraitor() && memory.essentiallyTraitor(player.getName())){
				return true;
			}
			else if (iAmOnTeam()&&onTeam(player.getName())) {
				return true;
			} else if (iAmAgainst() && against(player.getName())) {
				return true;
			} else if(iAmAgainst() && !GameWindow.hasPartner && memory.hasTraitor() && !memory.essentiallyTraitor(player.getName())){//i am against and there is atraitor and its not this guy
			return true;
			}
			return false;
		}

		public function theWinner():String {
			var oldPile = GameWindow.pile.copyMe();
			if(GameWindow.pairs){
				var winner:Card=oldPile.determineBiggestPair(oldPile.firstS());
				var pileWinningIndex=GameWindow.pile.getIndex(winner);
				pileWinningIndex = Math.floor(pileWinningIndex/2);
			} else{
			var winner:Card=oldPile.determineLargest(oldPile.firstS());
			var pileWinningIndex=GameWindow.pile.getIndex(winner);
			}
			var leadingPlayer:Number=Number(GameWindow.leader);
			var theWinner:Number=0;
			if (pileWinningIndex+leadingPlayer<=5) {
				theWinner=pileWinningIndex+leadingPlayer;
			} else {
				theWinner = (pileWinningIndex+leadingPlayer)%5;
			}
			return String(theWinner);
		}
		
		public function theWinningCard():Card {//only for 1 card right now
			var oldPile = GameWindow.pile.copyMe();
			var winner:Card=oldPile.determineLargest(oldPile.firstS());
			return winner;
		}
			public function winnerReasonablyHigh():Boolean {
			var oldPile = GameWindow.pile.copyMe();
			var winner:Card=oldPile.determineLargest(oldPile.firstS());
			trace("ok the winner is reasonably high");
			return memory.reasonablyHigh(winner);
		}

		public function onTeam(player:String):Boolean {
			
			if(!GameWindow.hasPartner && memory.essentiallyTraitor(player)) return true;
			return GameWindow.jugg.getName()==player || (GameWindow.partner.getName()==player && GameWindow.hasPartner);
		}
		public function canBe():Boolean {
			return hand.hasCard(GameWindow.calledC.getName());
		}
		public function against(player:String):Boolean {
			if(memory.isNotPartner(player)&& GameWindow.partner.getName()!=player && GameWindow.jugg.getName()!=player) {
				trace(player + " he is out of the suit"); return true;
			}//|| (GameWindow.partner.getName()==player && GameWindow.hasPartner);
			if(GameWindow.partner.getName()!=player && GameWindow.hasPartner && GameWindow.jugg.getName()!=player) return true;
			return false;
		}
		public function iAmAgainst():Boolean {
			if(GameWindow.partner.getName()!=getName() && GameWindow.jugg.getName()!=getName() && !hand.hasCard(GameWindow.calledC.getName()))
			trace("i am " + number + " and i am def not the partner");
			return  (GameWindow.hasPartner&&!onTeam(getName()))||(GameWindow.partner.getName()!=getName() && GameWindow.jugg.getName()!=getName() && !hand.hasCard(GameWindow.calledC.getName()));
		}
		public function iAmOnTeam():Boolean {
			return (onTeam(getName())) || (GameWindow.onlyOther && hand.hasCard(GameWindow.calledC.getName())) || hand.hasPair(GameWindow.calledC);
		}
		
		public function isJugg():Boolean {
			return jugg;
		}
		
		public function remember(othersPlayed:PlayerHand):void {
			memory.rememberPlayed(othersPlayed);
		}
		
		public function rememberMine():void {
			memory.rememberMine(hand);
		}
		
		public function hasHighest():Boolean{
			for (var j:int = 0; j<hand.size(); j++) {
				var theCard:Card = hand.retrieve(j);
				if(!theCard.isTrump() && memory.highest(theCard)&&otherTeamhasSuit(theCard.returnSuit())){
					//trace("I HAVE THE HIGHEST OF THE SUIT!" + theCard);
					return true;
				}
			}
			return false;
		}
		
		public function hasHighestPair():Boolean{
			for (var j:int = 0; j<hand.size(); j++) {
				var theCard:Card = hand.retrieve(j);
				if(!theCard.isTrump() && memory.highestPair(theCard) && hand.hasPair(theCard)){
					trace("I HAVE THE HIGHEST PAIR OF THE SUIT!" + theCard + " and my hand is " + hand);
					return true;
				}
			}
			return false;
		}
		public function playAHighest():void {
			for (var j:int = 0; j<hand.size(); j++) {
				var theCard:Card = hand.retrieve(j);
				if(!theCard.isTrump() && memory.highest(theCard)){
					mark(theCard);
					return;
				}
			}
		}
		public function playAHighestPair():void {
			for (var j:int = 0; j<hand.size(); j++) {
				var theCard:Card = hand.retrieve(j);
				if(!theCard.isTrump() && memory.highestPair(theCard)){
					mark(theCard);
					//trace("the card is " + theCard);
					mark(pairOf(theCard));
					//trace("the other card is " + pairOf(theCard));
					return;
				}
			}
		}
		public function newBrain():void{
			memory = new Brain();
		}	
		/*public function otherTeamHasSuit(suit:String):Boolean{
			return memory.otherTeamhasSuit(number, suit);
		}	
		*/
		public function pairOf(card:Card):Card{
			var myCard:Card;
			for (var j:int = 0; j<hand.size(); j++) {
				var theCard:Card = hand.retrieve(j);
				if(theCard.isSameCard(card)){
					myCard = theCard;
				}
			}
			//trace("uh oh");
			return myCard;
		}	
		
		public function isUnbeatable(card:Card):Boolean{
			return memory.highest(card) && otherTeamhasSuit(card.returnSuit());
		}	
		
		public function grade():void{
			memory.setTrust();
		}	
		
		public function otherTeamhasSuit(suit:String):Boolean{
			for each (var player:Player in GameWindow.players) {
					if(!sameTeam(player) && memory.playerOut(player.getName(), suit)) return false;				
			}
			return true;
		}
		public function myTeamhasSuit(suit:String):Boolean{
			for each (var player:Player in GameWindow.players) {
					if(sameTeam(player) && memory.playerOut(player.getName(), suit)) return false;				
			}
			return true;
		}
		
	}
}