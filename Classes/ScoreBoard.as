﻿package
{
	import flash.display.MovieClip;
	public class ScoreBoard extends MovieClip
	{

		public function ScoreBoard()
		{
			p1Number.setText("2");
			p2Number.setText("2");
			p3Number.setText("2");
			p4Number.setText("2");
			p5Number.setText("2");
		}
		
		public function updatePoints(number:String, points:Number):void{
			switch(number){
				case "1": p1Score.addToValue(points); break;
				case "2": p2Score.addToValue(points); break;
				case "3": p3Score.addToValue(points); break;
				case "4": p4Score.addToValue(points); break;
				default: p5Score.addToValue(points);
			}
		}
		public function resetPoints():void{
				 p1Score.reset();
				 p2Score.reset();
				 p3Score.reset();
				 p4Score.reset();
				 p5Score.reset();
		}
		
		public function removeBoard(person:Player):void{
				switch(person.getName()){
					case "1": p1Score.visible = false; break;
					case "2": p2Score.visible = false; break;
					case "3": p3Score.visible = false; break;
					case "4": p4Score.visible = false; break;
					default: p5Score.visible = false;
				}
		}
	}
}