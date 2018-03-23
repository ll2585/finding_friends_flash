package
{
	import flash.text.TextField;
	public class PointCounter extends Counter
	{
		public function PointCounter()
		{
			super();
 
		}
		override public function updateDisplay():void
		{
 		super.updateDisplay();
		myValue.text = currentValue.toString();

		}
		
		public function setZero():void
		{
 			currentValue = 0;
		}
		public function setTo(number:Number):void
		{
 			currentValue = number;
			updateDisplay();
		}
	}
}