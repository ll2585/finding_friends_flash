package
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	public class PopUpCalled extends MovieClip
	{
		public var trumpCard:Card;
		public var calledCard:Card;
		
		public function PopUpCalled(jugg:Player, firstcard:String, called:Card)
		{
			this.x = Game.STAGE_WIDTH/2;
			this.y = Game.STAGE_HEIGHT/2;
			jugName.setText("Player " + jugg.getName());
			firstOrOnly.setText(firstcard);
			trumpCard = new Card(GameWindow.trumpc.getName());
			addChild(trumpCard);
			trumpCard.setPosition(-161.5,3);
			calledCard = new Card(called.getName());
			calledCard.setPosition(44.5,-70);
			addChild(calledCard);
			goButton.addEventListener( MouseEvent.CLICK, beginGame );
		}
		
		public function beginGame( mouseEvent:MouseEvent ):void {
			dispatchEvent( new CardEvent( CardEvent.START ) );
		}
	}
}