package
{
	import flash.text.TextField;
	public class DeckCount extends Counter
	{
		public function DeckCount()
		{
			super();
 
		}
		override public function updateDisplay():void
		{
 		super.updateDisplay();
		deckSize.text = currentValue.toString();

		}
	}
}