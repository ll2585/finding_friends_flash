﻿PLAYER
public function playPoints(suit:String):void {
			if (GameWindow.leadingHand.firstCard().isTrump()) {
				var toAdd:Card=hand.getSmallestTrumpPoints();
				mark(toAdd);
			} else {
				mark(hand.getSmallestPoints(suit));
			}
		}
		
		
PLAYER HAND
function getSmallestTrumpPoints():Card{
			var ofsuits:PlayerHand = handOfTrump();
			var ofPoints:PlayerHand = new PlayerHand();
    		for(var i:Number = 0; i < ofsuits.size(); i++){
    			if (ofsuits.retrieve(i).isPoints()){
					ofPoints.includein(ofsuits.retrieve(i));
				}
    		}
			if(ofPoints.size()!= 0){
    			return ofPoints.retrieve(ofPoints.size()-1);//if have points play smallest point?
			}
			else if (ofsuits.size()!=0){
				return ofsuits.retrieve(ofsuits.size()-1);//if dont have points, but have suit, trash smallest suit
			}
			else if (hasNonTrumpPoints()){//has non-trump points
			ofPoints = new PlayerHand();
				for(var i:Number = 0; i < size(); i++){
					if (retrieve(i).isPoints() && !retrieve(i).isTrump()){//if its points and not trump, include it
						ofPoints.includein(retrieve(i));
					}
				}
			return ofPoints.retrieve(ofPoints.size()-1); //play smallest point
			}
			else {
			return getRandomCard();//play some other shit
			}
		}