package{
	import flash.display.MovieClip;
	public class Game extends MovieClip{
		public static const STAGE_WIDTH:Number = 1000;
		public static const STAGE_HEIGHT:Number = 600;
	
	public var startScreen:StartScreen;
	public var gameWindow:GameWindow;
	var instruction:Instruction
		public function Game(){
			startScreen = new StartScreen();
			startScreen.addEventListener( CardEvent.NEWGAME, onRequestStart );
			startScreen.addEventListener( CardEvent.INFO, getInstructions );
			startScreen.x = 0;
			startScreen.y = 0;
			addChild( startScreen );
		}
		public function onRequestStart( cardEvent:CardEvent ):void
		{
			gameWindow = new GameWindow();
			gameWindow.x = 0;
			gameWindow.y = 0;
			gameWindow.addEventListener(CardEvent.PLAY, gameWindow.playCard);
			addChild( gameWindow );
			removeChild(startScreen);
			startScreen = null;
		}
		public function getInstructions( cardEvent:CardEvent ):void
		{
			instruction = new Instruction();
			instruction.addEventListener( CardEvent.DONE, done );
			instruction.x = 0;
			instruction.y = 0;
			addChild(instruction);
			removeChild(startScreen);
			startScreen = null;
		}
		public function done( cardEvent:CardEvent ):void
		{
			startScreen = new StartScreen();
			startScreen.addEventListener( CardEvent.NEWGAME, onRequestStart );
			startScreen.addEventListener( CardEvent.INFO, getInstructions );
			startScreen.x = 0;
			startScreen.y = 0;
			addChild( startScreen );
			removeChild(instruction);
			instruction = null;
		}
	}
}