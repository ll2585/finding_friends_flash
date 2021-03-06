﻿package
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	public class FinalScore extends MovieClip
	{
		public var totalPoints:Number;
		var lastShow:LastHand;
		public var bottomPts:Number;
		public var deck:Decks;
		public function FinalScore(total:Number, bottom:Number)
		{
			goButton.addEventListener( MouseEvent.CLICK, resetIt );
			startOver.addEventListener( MouseEvent.CLICK, finish );
			this.x = Game.STAGE_WIDTH/2;
			this.y = Game.STAGE_HEIGHT/2;
			totalPoints = total;
			bottomPts = bottom;
			totalPts.setTo(totalPoints);
			previousButton.addEventListener( MouseEvent.CLICK, onClickPrevious );
			bottomPoints.setTo(bottomPts);
			var finalpoints:Number = Number(totalPoints) + Number(bottomPts);
			finalPts.setTo(finalpoints);
			var thebottom:PlayerHandHorizontal= new PlayerHandHorizontal();
			addChild(thebottom);
			thebottom.setFirst(142.5,116.5);
			//thebottom.setFirst(this.x, this.y);
			thebottom.copyHandFrom(GameWindow.bottom);
			for(var i:Number = 0; i < thebottom.size(); i++){
    			if(thebottom.retrieve(i).isPoints()) thebottom.retrieve(i).y -= 10;
			}
			if(GameWindow.over){
				startOver.visible = true;
				goButton.visible = false;
				gameOver.visible = true;
			}else{
			startOver.visible = false;
				goButton.visible = true;
				gameOver.visible = false;
			}
			
		}
		
		public function  resetIt( mouseEvent:MouseEvent ):void {
			dispatchEvent( new CardEvent( CardEvent.RESETIT ) );
		}
		public function  finish( mouseEvent:MouseEvent ):void {
			dispatchEvent( new CardEvent( CardEvent.NEWGAME ) );
		}
		
		public function onClickPrevious( mouseEvent:MouseEvent ):void {
			lastShow = new LastHand();
			addChild(lastShow);
			lastShow.moveMeTo(0,0);
			lastShow.addEventListener( CardEvent.CONTINUE, closeShow );
		}
		function closeShow(cardEvent:CardEvent):void {
				removeChild(lastShow);
		}
		
		
	}
}