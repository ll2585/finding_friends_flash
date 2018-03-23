package{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class Decks extends MovieClip{
		public var deck:Array;
		public var suits:String = "SHCDSHCD";
		public var rank:String = "123456789tjqk";
		public function Decks(){
			deck = new Array();
			for (var i:Number=0; i< suits.length;i++){
				for (var j:Number=0; j< rank.length;j++){
					var cardname:String = suits.charAt(i) + rank.charAt(j);
					var card:Card = new Card(cardname);
					deck.push( card );
				}
			}
			card = new Card("Jb");
			deck.push(card);
			card = new Card("Jr");
			deck.push(card);
			card = new Card("Jb");
			deck.push(card);
			card = new Card("Jr");
			deck.push(card);
			shuffle();
			this.x = Game.STAGE_WIDTH/2;
			this.y = Game.STAGE_HEIGHT/2;			
		}
		
		public function deal():Card{
			return deck.pop();
		}
		
		public function size():Number{
		return deck.length;
		}
	public function shuffle():void{
		for (var i:Number=0; i< deck.length;i++) {
			var nextplace:Number = randomRange(deck.length-1); 
			var temp:Card = deck[i];
			deck[i] = deck[nextplace];
			deck[nextplace] = temp;
		}
	}

	public function isEmpty():Boolean{
		return deck.length==8;
	}
	static function randomRange(max:Number, min:Number = 0):Number {      
	return Math.round(Math.random() * (max - min) + min); 
	} 
	//trace(randomRange(3)); //value between 0 and 3 
	//trace(randomRange(5,2)); //value between 2 and 5 
		public override function toString():String {
			return deck.toString();
		}
		
	}
}