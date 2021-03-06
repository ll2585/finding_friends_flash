﻿package
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	public class Instruction extends MovieClip
	{
	var thisframe:int;
		public function Instruction() 
		{
			thisframe = 1;
			nextButton.addEventListener( MouseEvent.CLICK, nextPage );
			previousButton.addEventListener( MouseEvent.CLICK, lastPage );
			playButton.addEventListener( MouseEvent.CLICK, goHome );
			previousButton.visible = false;
		}
 
		public function nextPage( event:MouseEvent ):void
		{
			if(thisframe ==0){
				previousButton.visible = false;
			} else{
				previousButton.visible = true;
			}
			if(thisframe ==13){
				nextButton.visible = false;
			} else{
				nextButton.visible = true;
			}
			gotoAndStop(++thisframe);
			
		}
		public function lastPage( event:MouseEvent ):void
		{
			if(thisframe == 2){
				previousButton.visible = false;
			} else{
				previousButton.visible = true;
			}
			if(thisframe ==1){
				nextButton.visible = false;
			} else{
				nextButton.visible = true;
			}
			gotoAndStop(--thisframe);
		}
		public function goHome( event:MouseEvent ):void
		{
			dispatchEvent( new CardEvent( CardEvent.DONE ) );
		}

		
	}
}