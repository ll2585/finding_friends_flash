﻿package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Player1Hand extends PlayerHandHorizontal {
		var toPlay:PlayerHandHorizontal;
		
		public function Player1Hand() {
			hand = new Array();
			x=Game.STAGE_WIDTH / 2;
			y=Game.STAGE_HEIGHT - 100;
			firstcardx = -35.5;
			firstcardy = 0;
		}


		function iClicked():void {
			toPlay = new PlayerHandHorizontal;
			toPlay.setFirst(-35.5, -111);
			for (var k:Number=0; k<hand.length; k++) {
				if (hand[k].clicked) {
					toPlay.addC(hand[k]);
					var card:Card=hand[k];
					hand.splice(k,1);
					play(card, k);
					k--;
				} 
			}
			played = true;
			addChild(toPlay);
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
		
		function declare(suit:String):void{
			toPlay = new PlayerHandHorizontal;
			toPlay.setFirst(-35.5, -111);
			var declare:Card;
			var cardString:String = suit + getRound();
			declare = new Card(cardString);
			GameWindow.trump = suit;
			for (var k:Number=0; k<hand.length; k++) {
				if (hand[k].isSameCard(declare)) {
					toPlay.addC(hand[k]);
					var card:Card=hand[k];
					hand.splice(k,1);
					play(card, k);
					GameWindow.trumpc = new Card(card.getName());
					addChild(toPlay);
					trace ("i declared and to play is " + toPlay);
					return;
				} 
			}
		}
		function overturn(suit:String):void{
			toPlay = new PlayerHandHorizontal;
			toPlay.setFirst(-35.5, -111);
			var declare:Card;
			var cardString:String = suit + getRound();
			declare = new Card(cardString);
			GameWindow.trump = suit;
			for (var k:Number=0; k<hand.length; k++) {
				if (hand[k].isSameCard(declare)) {
					toPlay.addC(hand[k]);
					var card:Card=hand[k];
					hand.splice(k,1);
					play(card, k);
					GameWindow.trumpc = new Card(card.getName());
					addChild(toPlay);
					k--;
				} 
			}
			trace ("i overturned and to play is " + toPlay);
		}
		function finalize(suit:String):void{
			var declare:Card;
			var cardString:String = suit + getRound();
			declare = new Card(cardString);
			GameWindow.trump = suit;
			for (var k:Number=0; k<hand.length; k++) {
				if (hand[k].isSameCard(declare)) {
					toPlay.addC(hand[k]);
					var card:Card=hand[k];
					hand.splice(k,1);
					play(card, k);
					GameWindow.trumpc = new Card(card.getName());
					addChild(toPlay);
					return;
				} 
			}
		}
		
		function returnCard():void{
			while(toPlay.size() != 0) {
				addC(toPlay.pop());
			}
			//removeChild(toPlay);
		}
		
		function myTurn():Boolean{
			return String(GameWindow.players[0]) == "1";
		}
		
		function led():Boolean{
			return GameWindow.leader=="1";
		}
		
		function clearit():void{
			removeChild(toPlay);
		}
		
		function validCard(card:Card):Card{
			if (!card.isTrump()) return getRandomSuit(card.returnSuit());
			else return getRandomTrump();
		}
		function anotherCard(card:Card):Card{
			if (!card.isTrump()) return getRandomSuit(card.returnSuit());
			else return getRandomTrump();
		}
		
	}
}