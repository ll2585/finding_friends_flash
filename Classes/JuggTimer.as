package
{
	import flash.text.TextField;
	public class JuggTimer extends Counter
	{
		public function JuggTimer()
		{
			super();
 
		}
		override public function updateDisplay():void
		{
 		super.updateDisplay();
		timer.text = currentValue.toString();

		}
	}
}