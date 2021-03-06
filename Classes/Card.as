﻿package {
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;

	public class Card extends MovieClip {
		public static var suits:String="DCHS";
		public static var rank:String="23456789tjqk1";
		public static var trumpRank:String = "";
		public var cardname:String;
		public var clicked:Boolean;
		public var discard:Boolean;
		public var thissuit:String;
		public var thisrank:String;
		public static var clickedarray:Array;
		public static var allclicked:int=0;
		public function Card(file:String) {
			clickedarray=new Array;
			clicked=false;
			cardname=file;
			attacca(file);
			thissuit = cardname.charAt(0);
			thisrank = cardname.charAt(1);
		}

		public static function getRandomSuit():String{
		var randomn:Number = (Decks.randomRange(3));
		return suits.charAt(randomn);
		}
		
		public function compareTo(other:Card):Number {
			var othername:String=other.cardname;
			if(this.cardname == other.cardname) return 0;
			if (cardname=="Jr") {
				return -1;
			}//this card comes before the other
			if (othername=="Jr") {
				return 1;
			}//comes after big joker
			if (cardname=="Jb") {
				return -1;
			}//this card comes before the other
			if (othername=="Jb") {
				return 1;
			}//comes after big joker
			if(GameWindow.finalized){
			if (cardname==GameWindow.trumpc.cardname) {
				return -1;
			}//this card comes before the other
			if (othername==GameWindow.trumpc.cardname) {
				return 1;
			}//comes after big joker
			if (thisrank==trumpRank && other.thisrank==trumpRank) {
				return 0;
			}
			if (thisrank==trumpRank) {
				return -1;
			}//this card comes before the other
			if (other.thisrank==trumpRank) {
				return 1;
			}//comes after big joker
			if (thissuit==GameWindow.trumpc.returnSuit() && other.thissuit!=GameWindow.trumpc.returnSuit()) {
				return -1;
			}//this card comes before the other
			if (other.thissuit==GameWindow.trumpc.returnSuit() &&thissuit!=GameWindow.trumpc.returnSuit() ) {
				return 1;
			}//comes after big joker
			}
			var mySuit=cardname.charAt(0);
			var otherSuit=othername.charAt(0);
			if (mySuit==otherSuit) {
				return rank.indexOf(othername.charAt(1)) - rank.indexOf(cardname.charAt(1));
			} else {
				return suits.indexOf(othername.charAt(0)) - suits.indexOf(cardname.charAt(0));

			}
		}
		public function sortRank(other:Card):Number {
			var othername:String=other.cardname;
			if(this.cardname == other.cardname) return 0;
			if (cardname=="Jr") {
				return -1;
			}//this card comes before the other
			if (othername=="Jr") {
				return 1;
			}//comes after big joker
			if (cardname=="Jb") {
				return -1;
			}//this card comes before the other
			if (othername=="Jb") {
				return 1;
			}//comes after big joker
			if(GameWindow.finalized){
			if (cardname==GameWindow.trumpc.cardname) {
				return -1;
			}//this card comes before the other
			if (othername==GameWindow.trumpc.cardname) {
				return 1;
			}//comes after big joker
			if (thisrank==trumpRank && other.thisrank==trumpRank) {
				return 0;
			}
			if (thisrank==trumpRank) {
				return -1;
			}//this card comes before the other
			if (other.thisrank==trumpRank) {
				return 1;
			}//comes after big joker
			}
			var myRank=cardname.charAt(1);
			var otherRank=othername.charAt(1);
			if (myRank==otherRank) {
				return suits.indexOf(othername.charAt(0)) - suits.indexOf(cardname.charAt(0));
			} else {
				return rank.indexOf(othername.charAt(1)) - rank.indexOf(cardname.charAt(1));

			}
		}
		
		public function isSameCard(other:Card):Boolean {
			return(this.cardname == other.cardname);
		}
		public function moveleft(distance:int):void {
			x-=distance;
		}
		public function setPosition(xpart:int, ypart:int):void {
			x = xpart;
			y = ypart;
		}
		public function moveright(distance:int):void {
			x+=distance;
		}

		public override function toString():String {
			return cardname;
		}
		private function attacca(file:String):void {
			var immagine;
			switch (file) {
				case "H1" :
					immagine=new H1(0,0);
					break;
				case "H2" :
					immagine=new H2(0,0);
					break;
				case "H3" :
					immagine=new H3(0,0);
					break;
				case "H4" :
					immagine=new H4(0,0);
					break;
				case "H5" :
					immagine=new H5(0,0);
					break;
				case "H6" :
					immagine=new H6(0,0);
					break;
				case "H7" :
					immagine=new H7(0,0);
					break;
				case "H8" :
					immagine=new H8(0,0);
					break;
				case "H9" :
					immagine=new H9(0,0);
					break;
				case "Ht" :
					immagine=new Ht(0,0);
					break;
				case "Hj" :
					immagine=new Hj(0,0);
					break;
				case "Hq" :
					immagine=new Hq(0,0);
					break;
				case "Hk" :
					immagine=new Hk(0,0);
					break;
				case "D1" :
					immagine=new D1(0,0);
					break;
				case "D2" :
					immagine=new D2(0,0);
					break;
				case "D3" :
					immagine=new D3(0,0);
					break;
				case "D4" :
					immagine=new D4(0,0);
					break;
				case "D5" :
					immagine=new D5(0,0);
					break;
				case "D6" :
					immagine=new D6(0,0);
					break;
				case "D7" :
					immagine=new D7(0,0);
					break;
				case "D8" :
					immagine=new D8(0,0);
					break;
				case "D9" :
					immagine=new D9(0,0);
					break;
				case "Dt" :
					immagine=new Dt(0,0);
					break;
				case "Dj" :
					immagine=new Dj(0,0);
					break;
				case "Dq" :
					immagine=new Dq(0,0);
					break;
				case "Dk" :
					immagine=new Dk(0,0);
					break;
				case "C1" :
					immagine=new C1(0,0);
					break;
				case "C2" :
					immagine=new C2(0,0);
					break;
				case "C3" :
					immagine=new C3(0,0);
					break;
				case "C4" :
					immagine=new C4(0,0);
					break;
				case "C5" :
					immagine=new C5(0,0);
					break;
				case "C6" :
					immagine=new C6(0,0);
					break;
				case "C7" :
					immagine=new C7(0,0);
					break;
				case "C8" :
					immagine=new C8(0,0);
					break;
				case "C9" :
					immagine=new C9(0,0);
					break;
				case "Ct" :
					immagine=new Ct(0,0);
					break;
				case "Cj" :
					immagine=new Cj(0,0);
					break;
				case "Cq" :
					immagine=new Cq(0,0);
					break;
				case "Ck" :
					immagine=new Ck(0,0);
					break;
				case "S1" :
					immagine=new S1(0,0);
					break;
				case "S2" :
					immagine=new S2(0,0);
					break;
				case "S3" :
					immagine=new S3(0,0);
					break;
				case "S4" :
					immagine=new S4(0,0);
					break;
				case "S5" :
					immagine=new S5(0,0);
					break;
				case "S6" :
					immagine=new S6(0,0);
					break;
				case "S7" :
					immagine=new S7(0,0);
					break;
				case "S8" :
					immagine=new S8(0,0);
					break;
				case "S9" :
					immagine=new S9(0,0);
					break;
				case "St" :
					immagine=new St(0,0);
					break;
				case "Sj" :
					immagine=new Sj(0,0);
					break;
				case "Sq" :
					immagine=new Sq(0,0);
					break;
				case "Sk" :
					immagine=new Sk(0,0);
					break;
				case "Jb" :
					immagine=new Jb(0,0);
					break;
				default :
					immagine=new Jr(0,0);
			}
			var bitmap:Bitmap=new Bitmap(immagine);
			addChild(bitmap);
		}

		function clickHandler(event:MouseEvent):void {
			if (GameWindow.discarding) {
				if (! clicked) {
					if (clickedarray.length!=8) {
						y-=10;
						clicked=true;
						clickedarray.push(this);
					}
				} else {
					y+=10;
					clicked=false;
					if (clickedarray.length==1) {
						clickedarray=new Array  ;
					} else {
						clickedarray.pop();
					}
				}
			} else {
				if (! clicked) {
					if (clickedarray.length==0||
						(GameWindow.leader == "1" && this.isSameCard(clickedarray[0])) || 
						(GameWindow.pairs && clickedarray.length<2)) {
						y-=10;
						clicked=true;
						trace("the clicked array twas " + clickedarray);
						clickedarray.push(this);
						trace("the clciked array is " + clickedarray);
					}
				} else {
					y+=10;
					clicked=false;
					if (clickedarray.length==1) {
						clickedarray=new Array  ;
					} else {
						trace("the clicked array was " + clickedarray);
						var oldIndex = clickedarray.indexOf(this);
						clickedarray.splice(oldIndex,1);
						trace("the clicked array is now " + clickedarray);
					}
				}
			}
		}
		function unClick():void {
			clicked=false;
			if (clickedarray.length==1) {
				clickedarray=new Array  ;
			} else {
				clickedarray.pop();
			}
		}

		function toDiscard():void {
			this.discard=true;
		}

		static function resort(trump:String){
			trumpRank = trump.charAt(1);
			var trumpSuit = trump.charAt(0);
			suits = suits.replace(trumpSuit,"").concat(trumpSuit);
			rank = rank.replace(trumpRank,"").concat(trumpRank);
		}
		
		function makeClickable():void{
			addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		function makeunClickable():void{
			removeEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		function returnSuit():String{
			return thissuit;
		}
		
		function returnValue():String{
			return thisrank;
		}
		
		function isTrump():Boolean{
			return thissuit == GameWindow.trump || thisrank == Card.trumpRank || cardname == "Jb" || cardname == "Jr";
		}
		
		function makeTrump():void{
			cardname = "Jr";
		}
		
		function isFive():Boolean{
			return returnValue() == "5";
		}
		
		function isTen():Boolean{
			return returnValue() == "t" || returnValue() == "k";
		}
		function getName():String{
			return cardname;
		}
		function setClicked():void{
			clicked = true;
		}
		function setUnClicked():void{
			clicked = false;
		}
		function isClicked():Boolean{
			return clicked;
		}
		static function defaultRank(){
			  suits="DCHS";
			rank="23456789tjqk1";
		}
		function isPoints():Boolean{
			return isFive() || isTen();
		}
	}
}