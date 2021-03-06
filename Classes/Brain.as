﻿package {
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class Brain extends MovieClip {
		private var memoryOfPlayedCards:Array;
		private var trumpCards:Array;
		private var spadeCards:Array;
		private var heartCards:Array;
		private var clubCards:Array;
		private var diamondCards:Array;
		private var notPartner:Array;
		private var playerTrust:Array;
		private var outofSuit:Array;
		private var trustLimit:Number = 25;
		private var betrayed:Boolean;
		

		private var myDeck:Decks;
		private var probOfRemember:Number = 1.9;//70% chance of remembering
		
		public function Brain() {
			myDeck = new Decks();
			betrayed = false;
			trumpCards = new Array;
			spadeCards = new Array;
			heartCards = new Array;
			clubCards = new Array;
			diamondCards = new Array;
			outofSuit = new Array;
			memoryOfPlayedCards = new Array;
			while(myDeck.size()!=0){
				var card:Card = myDeck.deal();
				if(card.isTrump()){
					trumpCards.push(card);
				} else suitArray(card).push(card);
			}
			notPartner = new Array;
			playerTrust = new Array;
			playerTrust[0] = 50;
			playerTrust[1] = 50;
			playerTrust[2] = 50;
			playerTrust[3] = 50;
			playerTrust[4] = 50;
		}
		
		public function reset(){
			betrayed = false;
			memoryOfPlayedCards = new Array;
			notPartner = new Array;
			trumpCards = new Array;
			spadeCards = new Array;
			heartCards = new Array;
			clubCards = new Array;
			diamondCards = new Array;
			playerTrust = new Array;
			playerTrust[0] = 50;
			playerTrust[1] = 50;
			playerTrust[2] = 50;
			playerTrust[3] = 50;
			playerTrust[4] = 50;
		}
		
		public function rememberPlayed(othersPlayed:PlayerHand):void{
			if(!betrayed && !GameWindow.hasPartner){
			eraseCard(GameWindow.calledC);
			eraseCard(GameWindow.calledC);
			}
			if(!betrayed && GameWindow.hasPartner){
				suitArray(GameWindow.calledC).push(GameWindow.calledC);
				suitArray(GameWindow.calledC).push(GameWindow.calledC);
			betrayed = true;
			}
			
			var oldPile:PlayerHand = othersPlayed.copyMe();
			for (var j:int = 0; j<oldPile.size(); j++) {
				var randomn:Number = Math.random();
				var card:Card = oldPile.retrieve(j);
				if(randomn < probOfRemember){
					memoryOfPlayedCards.push(card);
					eraseCard(card);
				}
				for (var f:int = 0; f<GameWindow.lastHand.length; f++) {
				if(!GameWindow.leadingHand.firstCard().isTrump() && !GameWindow.lastHand[f].hasSuit(GameWindow.leadingHand.firstCard().returnSuit())){
					var out:String = String(f+1) + "+" + GameWindow.leadingHand.firstCard().returnSuit();
					outofSuit.push(out);
				}
			}
			}
		}
		
		
		public function rememberMine(hand:PlayerHand):void{
			var oldPile:PlayerHand = hand;
			for (var j:int = 0; j<oldPile.size(); j++) {
					eraseCard(oldPile.retrieve(j));
			}
		}
		
		public function highest(card:Card):Boolean{
			var theArray:Array = suitArray(card);
			for (var j:int = 0; j<theArray.length; j++) {
				if(theArray[j].compareTo(card) < 0) return false;
			}
			return true;
		}
		public function highestPair(card:Card):Boolean{
			var theArray:Array = suitArray(card);
			for (var j:int = 0; j<theArray.length; j++) {
				if(theArray[j].compareTo(card) < 0 && onlyOneRemains(card)) return false;
			}
			return true;
		}
		public function onlyOneRemains(card:Card):Boolean{
			var theArray:Array = suitArray(card);
			var num:Number = 0;
			for (var j:int = 0; j<theArray.length; j++) {
				if(theArray[j].isSameCard(card)) num++;
			}
			return num==1 || num==0;
		}
		
		public function reasonablyHigh(card:Card):Boolean{
			var theArray:Array = suitArray(card);
			var i:int = 0;
			for (var j:int = 0; j<theArray.length; j++) {
				if(theArray[j].compareTo(card) < 0) i++;
			}
			return i < 6;
		}
		
		public function otherTeamhasSuit(number:String, suit:String):Boolean{
			var onteam:Boolean;
			if(GameWindow.jugg.getName()==number || GameWindow.partner.getName()==number) //if i am the juggernaut
				onteam = true;
			else onteam = false;
			var otherTeam:String = "";	
			for (var j:int = 0; j<GameWindow.players.length; j++) {
				if((onteam && !GameWindow.players[j].iAmOnTeam())||(!onteam&&GameWindow.players[j].iAmOnTeam()))
					otherTeam+= GameWindow.players[j].getName();
			}
			for (var j:int = 0; j<otherTeam.length; j++) {
				var toCheck:String = otherTeam.charAt(j) + "+"+suit;
				if(outofSuit.indexOf(toCheck)!=-1){
					trace("i am " + number + " and the other team is out of the suit!");
					return true;
				}
			}
			trace("i am " + number + " the other team is not out yet");
			return false;
		}
		
		public function eraseCard(card:Card):void{
			var theArray:Array = suitArray(card);
			var position:int = 0;
			for (var j:int = 0; j<theArray.length; j++) {
				
				if(theArray[j].getName()==card.getName()){
					position = j;
					break;
				}
			}
			theArray.splice(position, 1);
		}
		
		public function eraseTrumpCard(card:Card):void{
			var theArray:Array = suitArray(card);
			var position:int = 0;
			for (var j:int = 0; j<theArray.length; j++) {
				
				if(theArray[j].getName()==card.getName()){
					position = j;
					break;
				}
			}
			theArray.splice(position, 1);
		}
		
		
		public function suitArray(card:Card):Array{
			var returnit:Array;
			if(card.isTrump()){
						returnit = trumpCards;
					} else {
						switch(card.returnSuit()){
							case "S": returnit= spadeCards; break;
							case "D": returnit= diamondCards; break;
							case "H": returnit= heartCards; break;
							default: returnit= clubCards;
						}
					}
					return returnit;
		}
		
		public function playerOut(player:String, suit:String):Boolean{
			var toCheck:String = player + "+"+suit;
			
			if(outofSuit.indexOf(toCheck)!=-1)
					return true;
			return false;
		}
		
		public function isNotPartner(player:String):Boolean{
			return playerOut(player, GameWindow.calledC.returnSuit());
		}
		
		public function setTrust():void{
			var toJugg:Number = Number(GameWindow.jugg.getName());
			playerTrust[toJugg-1] = -100;
			var winner:String =GameWindow.largestSoFar();
			if(!GameWindow.hasPartner){
			if(GameWindow.players[0].getName()!="1" && GameWindow.players[0].toPlay.getPoints()>0 && String(toJugg) == winner) {
				trace(GameWindow.players[0] + " someone put points");
				var theirIndex:Number = Number(GameWindow.players[0].getName())-1;
				trace(GameWindow.players[0].toPlay.getPoints() + " points?!?!");
				playerTrust[theirIndex] -= 1.5*GameWindow.players[0].toPlay.getPoints();
				trace("now your trust is " + playerTrust[theirIndex] );
			} else if(GameWindow.players[0].getName()=="1" && GameWindow.lastHand[0].getPoints()>0 && String(toJugg) == winner) {
				trace(GameWindow.players[0] + " someone put points");
				var theirIndex:Number = Number(GameWindow.players[0].getName())-1;
				trace(GameWindow.lastHand[0].getPoints() + " points?!?!");
				playerTrust[theirIndex] -= 1.5*GameWindow.lastHand[0].getPoints();
				trace("now your trust is " + playerTrust[theirIndex] );
			}
			}
		}
		
		public function essentiallyTraitor(number:String):Boolean{
			if (number== GameWindow.jugg.getName()) return true;
			else if(playerTrust[Number(number)-1] <=trustLimit) {
				trace(number + " you are a traitor!");
				return true;
			}
			else return false;
			
		}
		public function hasTraitor():Boolean{
			var count:Number = 0;
			for (var j:int = 0; j<playerTrust.length; j++) {
				if(playerTrust[j] <=trustLimit){
					count++;
				}
			}
			return count == 2;
			
		}
		
	}
}