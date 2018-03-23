package
{
	import flash.display.MovieClip;
	public class TextField extends MovieClip
	{
		public var myText:String;
 
		public function TextField()
		{
			reset();
			updateDisplay();
		}
		
		public function reset():void
		{
 			myText = "HI";

		}
 
 		public function setText(newText:String):void{
			myText = newText;
			updateDisplay();
		}
		public function updateDisplay():void
		{
			textField.text = myText;
		}
		public function gettext():String
		{
			return myText;
		}
	}
}