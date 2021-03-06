﻿package
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	public class StartScreen extends MovieClip
	{

		public function StartScreen() 
		{
			startButton.addEventListener( MouseEvent.CLICK, onClickStart );
			instructionButton.addEventListener( MouseEvent.CLICK, onClickInstructions );
		}
 
		public function onClickStart( event:MouseEvent ):void
		{
			dispatchEvent( new CardEvent( CardEvent.NEWGAME ) );
		}
		public function onClickInstructions( event:MouseEvent ):void
		{
			dispatchEvent( new CardEvent( CardEvent.INFO ) );
		}


		
	}
}