﻿package  
{
	import flash.events.Event;
	public class CardEvent extends Event 
	{
		public static const PLAY:String = "play";
		public static const START:String = "start";
		public static const RESETIT:String = "reset";
		public static const NEWGAME:String = "newgame";
		public static const INFO:String = "info";
		public static const DONE:String = "done";
		public static const CONTINUE:String = "CONTINUE";
 
		public function CardEvent( type:String )
		{
			super( type );
		}
	}
}