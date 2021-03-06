﻿package
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	public class DeclareWindow extends MovieClip
	{
		public var calledSuit:String;
		public var callRank:String;
		public var calledCard:Card = null;
		
		public function DeclareWindow()
		{
			calledSuit = "";
			callRank = "";
			this.x = Game.STAGE_WIDTH/2;
			this.y = Game.STAGE_HEIGHT/2;
			var trumpS = GameWindow.trump;
			var trumpR = Card.trumpRank;
			switch(trumpS){
				case "D": callDiamonds.visible=false; break;
				case "H": callHearts.visible = false; break;
				case "S": callSpades.visible = false; break;
				default: callClubs.visible = false;
			}
			switch(trumpR){
				case "1": callAce.visible=false; break;
				case "2": callTwo.visible = false; break;
				case "3": callThree.visible = false; break;
				default: callKing.visible = false;
			}
 			callAce.addEventListener( MouseEvent.CLICK, callAceClick );
			callTwo.addEventListener( MouseEvent.CLICK, callTwoClick );
			callThree.addEventListener( MouseEvent.CLICK, callThreeClick );
			callKing.addEventListener( MouseEvent.CLICK, callKingClick );
			callHearts.addEventListener( MouseEvent.CLICK, callHeartsClick );
			callDiamonds.addEventListener( MouseEvent.CLICK, callDiamondsClick );
			callClubs.addEventListener( MouseEvent.CLICK, callClubsClick );
			callSpades.addEventListener( MouseEvent.CLICK, callSpadesClick );
			goButton.addEventListener( MouseEvent.CLICK, beginGame );
		}
		
		public function callAceClick( mouseEvent:MouseEvent ):void {
			callRank = "1";
			callText.setText("Ace");
		}

		public function callTwoClick( mouseEvent:MouseEvent ):void {
			callRank = "2";
			callText.setText("Two");
		}
		public function callThreeClick( mouseEvent:MouseEvent ):void {
			callRank = "3";
			callText.setText("Three");
		}
		public function callKingClick( mouseEvent:MouseEvent ):void {
			callRank = "k";
			callText.setText("King");
		}
		public function callHeartsClick( mouseEvent:MouseEvent ):void {
			calledSuit = "H";
			callSuit.setText("Hearts");
		}
		public function callDiamondsClick( mouseEvent:MouseEvent ):void {
			calledSuit = "D";
			callSuit.setText("Diamonds");
		}
		public function callClubsClick( mouseEvent:MouseEvent ):void {
			calledSuit = "C";
			callSuit.setText("Clubs");
		}
		public function callSpadesClick( mouseEvent:MouseEvent ):void {
			calledSuit = "S";
			callSuit.setText("Spades");
		}

		public function beginGame( mouseEvent:MouseEvent ):void {
			var newCardName:String = calledSuit + callRank;
			calledCard = new Card(newCardName);
			dispatchEvent( new CardEvent( CardEvent.START ) );
		}
		
		public function getCalledCard():Card{
			return calledCard;
		}
		public function getRank():String{
			return callText.gettext();
		}
		
		public function getSuit():String{
			return callSuit.gettext();
		}
	}
}