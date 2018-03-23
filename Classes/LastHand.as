package
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	public class LastHand extends MovieClip
	{
		public var totalPoints:Number;
		public var bottomPts:Number;
		public var deck:Decks;
		public function LastHand()
		{
			beginGame.addEventListener( MouseEvent.CLICK, continueIt );
			this.x = Game.STAGE_WIDTH/2;
			this.y = Game.STAGE_HEIGHT/2;
			var lastHand:Array = GameWindow.lastHand;
			var lastWinner:String = GameWindow.leader;
			var firstHand:PlayerHandHorizontal =  new PlayerHandHorizontal;
			var secondHand:PlayerHandHorizontal =  new PlayerHandHorizontal;
			var thirdHand:PlayerHandHorizontal =  new PlayerHandHorizontal;
			var fourthHand:PlayerHandHorizontal =  new PlayerHandHorizontal;
			var fifthHand:PlayerHandHorizontal =  new PlayerHandHorizontal;
			firstHand.setFirst(-18, 93.6);
			secondHand.setFirst(-141.5, 4.6);
			thirdHand.setFirst(-88, -139);
			fourthHand.setFirst(52, -139);
			fifthHand.setFirst(105, 4.6);
			firstHand.adaptFrom(lastHand[0]);
			secondHand.adaptFrom(lastHand[1]);
			thirdHand.adaptFrom(lastHand[2]);
			fourthHand.adaptFrom(lastHand[3]);
			fifthHand.adaptFrom(lastHand[4]);
			addChild(firstHand);
			addChild(secondHand);
			addChild(thirdHand);
			addChild(fourthHand);
			addChild(fifthHand);
			hideStuff();
			switch(lastWinner){
			case "1": p1Win.visible = true; break;
			case "2": p2Win.visible = true; break;
			case "3": p3Win.visible = true; break;
			case "4": p4Win.visible = true; break;
			default: p5Win.visible = true;
			}
			
			switch(GameWindow.jugg.getName()){
			case "1": p1Team.visible = true; break;
			case "2": p2Team.visible = true; break;
			case "3":  p3Team.visible = true; break;
			case "4": p4Team.visible = true; break;
			case "5": p5Team.visible = true; break;
			default:
			}
			
			switch(GameWindow.partner.getName()){
			case "1":  p1Team.visible = true; break;
			case "2": p2Team.visible = true; break;
			case "3": p3Team.visible = true; break;
			case "4":  p4Team.visible = true; break;
			case "5": p5Team.visible = true; break;
			default:
			}

		}
		
		public function  continueIt( mouseEvent:MouseEvent ):void {
			dispatchEvent( new CardEvent( CardEvent.CONTINUE ) );
		}
		
		public function  moveMeTo( ex:int, why:int ):void {
			this.x=ex;
			this.y=why;
		}
		function hideStuff():void{
			p1Team.visible = false;
			p2Team.visible = false;
			p3Team.visible = false;
			p4Team.visible = false;
			p5Team.visible = false;
			p1Win.visible = false;
			p2Win.visible = false;
			p3Win.visible = false;
			p4Win.visible = false;
			p5Win.visible = false;
		}
		
	}
}