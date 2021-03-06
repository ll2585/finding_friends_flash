﻿package {
	import flash.display.Sprite;
		import flash.events.MouseEvent;

	public class PlayerHandHorizontal extends PlayerHand {
		var toleft:Boolean;
		var toright:Boolean;
		var firstcardx:Number;
		var firstcardy:Number;
		
		public function PlayerHandHorizontal() {
			hand = new Array;
			toleft=false;
			toright=false;
		}
		
		public function setFirst(myX:Number, myY:Number){
			firstcardx = myX;
			firstcardy = myY;
		}
		
		public override function addC(card:Card):void {
			card.y=firstcardy;
			var midpoint = Math.round((hand.length-1)/2);
			if (hand.length==0) {
				card.x=firstcardx;
				addChild(card);
			} else {
				var midCard:Card=hand[midpoint];
				var mySpot=findSpot(card,0,hand.length);
				if (card.compareTo(midCard)<0) {//comes before the middle
					toleft=true;
					toright=false;
					for (var j:Number=mySpot-1; j>=0; j--) {
						hand[j].moveleft(20);
					}
					card.x=hand[mySpot].x-20;
					addChild(card);
				} else {
					toleft=false;
					toright=true;
					for (var i:Number=mySpot; i<hand.length; i++) {
						hand[i].moveright(20);
					}
					if (mySpot==hand.length) {
						card.x=hand[mySpot-1].x+20;
					} else {
						card.x=hand[mySpot].x-20;
					}
					addChild(card);
				}
			}
			insert(card, mySpot);
			for (var k:Number=mySpot; k<hand.length; k++) {
				setChildIndex(hand[k],numChildren - 1);
			}
			if (toright==true) {
				for (var d:Number=0; d<hand.length; d++) {
					hand[d].moveleft(10);
				}
			} else if (toleft==true) {
				for (var f:Number=0; f<hand.length; f++) {
					hand[f].moveright(10);
				}
			}
		}
	
		public override function play(card:Card, k:int):void{
			card.unClick();
			Card.clickedarray = new Array;
			card.removeEventListener(MouseEvent.CLICK, card.clickHandler);
			var midpoint = Math.floor((hand.length-1)/2);
			var midCard:Card=hand[midpoint];
			var mySpot=k;
			if (k<midpoint) {//comes before the middle
				toleft=true;
				toright=false;
				for (var j:Number=mySpot-1; j>=0; j--) {
					hand[j].moveright(20);
				}
			} else {
				toleft=false;
				toright=true;
				for (var i:Number=mySpot; i<hand.length; i++) {
					hand[i].moveleft(20);
				}
			}
			if (toright==true) {
				for (var l:Number=0; l<hand.length; l++) {
					hand[l].moveright(10);
				}
			} else if (toleft==true) {
				for (var b:Number=0; b<hand.length; b++) {
					hand[b].moveleft(10);
				}
			}
		}
		
		function toss():void {
			for (var k:Number=0; k<hand.length; k++) {
				hand[k].discard = false;
				if (hand[k].clicked) {
					GameWindow.bottom.addC(hand[k]);
					var card:Card=hand[k];
					hand.splice(k,1);
					play(card, k);
					k--;
				} 
			}
		}
		
		override function resort():void{
			var temp:Array = new Array;
			while(hand.length != 0){
				temp.push(hand.pop());
			}
			for each(var card:Card in temp){
				this.addC(card);
			}

		}
		
		function clearall():void{
			for each(var card:Card in hand){
				removeChild(card);
			}
		}
		function makeClickable(card:Card):void{
				card.addEventListener(MouseEvent.CLICK, card.clickHandler);
		}
		function makeUnClickable(card:Card):void{
				card.removeEventListener(MouseEvent.CLICK, card.clickHandler);
		}
		
		public  function copyHandFrom(sourceHand:PlayerHand):void{
			for(var i:Number = 0; i < sourceHand.size(); i++){
    			this.addC(sourceHand.retrieve(i));
			}
    	}
		
		public function cleanup():void{
			clearall();
			super.empty();
		}
	
		public function purge():void{
		while (numChildren > 0){
		 removeChildAt(0);
			}
			super.empty();
		}
		
		public function adaptFrom(other:PlayerHand):void {
			for(var j:int = 0; j<other.size(); j++){
					addC(new Card(other.retrieve(j).getName()));
				}
		}
		
		
		
	}
}