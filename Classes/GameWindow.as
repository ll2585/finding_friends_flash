package {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class GameWindow extends MovieClip {
		public static var lastHand:Array;
		public static var suitArray:Array = new Array;
		public static var onlyOther:Boolean;
		var popup:PopUpCalled;
		var lastShow:LastHand;
		public var timerTime:int = 25;
		public static var over:Boolean;
		public var totalPoints:Number;
		public var board:ScoreBoard;
		public static var trump:String;
		public static var discarding:Boolean;
		public static var pairs:Boolean;
		public static var consecutives:Boolean;
		public static var started:Boolean;
		public static var declared:Boolean;
		public static var leader:String="";
		public var deck:Decks;
		public var gameTimer:Timer;
		public var waiter:Timer;
		public var betweenRounds:Timer;
		public var human:Player;
		public static var finalized:Boolean;
		public var p1h:Player1Hand;
		public var p2h:PlayerHandHorizontal;
		public var p3h:PlayerHandHorizontal;
		public var p4h:PlayerHandHorizontal;
		public var p5h:PlayerHandHorizontal;
		public static var pile:PlayerHand;
		public var callWindow:DeclareWindow;
		public var finalWindow:FinalScore;
		public static var leadingHand:PlayerHandHorizontal=new PlayerHandHorizontal  ;
		public static var players:Array;
		public static var trumpc:Card;
		public static var calledC:Card;
		public static var bottom:PlayerHandHorizontal=new PlayerHandHorizontal  ;
		static var jugg:Player;
		static var partner:Player;
		static var hasPartner:Boolean = false;

		var overTurn:Timer=new Timer(50);//25ms

		public function GameWindow() {
			suitArray[0] = "S";
			suitArray[1] = "C";
			suitArray[2] = "D";
			suitArray[3] = "H";
			lastHand = new Array;
			cleanWinIndicator();
			hideStuff();
			partner = Player.NONE;
			over = false;
			finalized = false;
			totalPoints = 0;
			jugtimer.visible = false;
			firstOrOther.visible= false;
			board = new ScoreBoard;
			addChild(board);
			pile=new PlayerHand;
			started=false;
			consecutives=false;
			pairs=false;
			trumpc=null;
			discarding=false;
			trump="";
			deck = new Decks();

			gameTimer=new Timer(timerTime);//25ms
			gameTimer.addEventListener( TimerEvent.TIMER, autodeal );
			gameTimer.start();
			waiter=new Timer(1);//25ms
			waiter.addEventListener( TimerEvent.TIMER, wait );
			waiter.start();
			betweenRounds=new Timer(2000);//25ms
			betweenRounds.addEventListener( TimerEvent.TIMER, betweenRoundWait );
			p1h = new Player1Hand();
			addChild(p1h);
			p2h = new PlayerHandHorizontal();
			addChild(p2h);
			p3h = new PlayerHandHorizontal();
			addChild(p3h);
			p4h = new PlayerHandHorizontal();
			addChild(p4h);
			p5h = new PlayerHandHorizontal();
			addChild(p5h);
			p2h.setFirst(700,0);
			p3h.setFirst(700,50);
			p4h.setFirst(700,100);
			p5h.setFirst(700,150);
			players=new Array;
			players.push(new Player("1"));
			players[0].setScore(2);
			players[0].giveHand(p1h);
			human = players[0];
			players.push(new Player("2"));
			players[1].setScore(2);
			players[1].giveHand(p2h);
			players.push(new Player("3"));
			players[2].setScore(2);
			players[2].giveHand(p3h);
			players.push(new Player("4"));
			players[3].setScore(2);
			players[3].giveHand(p4h);
			players.push(new Player("5"));
			players[4].setScore(2);
			players[4].giveHand(p5h);
			addChild(players[1]);
			addChild(players[2]);
			addChild(players[3]);
			addChild(players[4]);
			
			//hideH();
			
			jugtimer.addToValue(5);
			drawButton.addEventListener( MouseEvent.CLICK, onClickDeal );
			previousButton.addEventListener( MouseEvent.CLICK, onClickPrevious );
			previousButton.visible=false;
			redoButton.addEventListener( MouseEvent.CLICK, onClickRedo );
			playButton.visible=false;
			tossButton.visible=false;
			declared=false;
			dS.visible=false;
			dC.visible=false;
			dH.visible=false;
			dD.visible=false;
			dS.addEventListener( MouseEvent.CLICK, onClickDeclareS );
			dC.addEventListener( MouseEvent.CLICK, onClickDeclareC );
			dH.addEventListener( MouseEvent.CLICK, onClickDeclareH );
			dD.addEventListener( MouseEvent.CLICK, onClickDeclareD );
			playButton.addEventListener( MouseEvent.CLICK, onClickPlay );
			tossButton.addEventListener( MouseEvent.CLICK, onClickToss );
			autoPlayit.addEventListener( MouseEvent.CLICK, autoPlayClick );
			updateRound();
		}
		private function hideH():void{
			p2h.visible=false;
			p3h.visible=false;
			p4h.visible=false;
			p5h.visible=false;
		}
		public function autodeal( timerEvent:TimerEvent ):void {
			if (!deck.isEmpty()) {
				p1h.addC(deck.deal());
				p2h.addC(deck.deal());
				p3h.addC(deck.deal());
				p4h.addC(deck.deal());
				p5h.addC(deck.deal());
				for(var b:Number = 0; b < players.length; b++){
				if(players[b]!=human){
					if(players[b].wantsToDeclare()!=null && !declared) {
					players[b].declare(players[b].wantsToDeclare());
					declared = true;
					players[b].jugg=true;
				}
				if(!finalized && players[b].wantsToFinalizeOverTurn()!=null){
					for(var c:Number = 0; c < players.length; c++){	
					if(human.jugg) p1h.returnCard();
					if(players[c].jugg) players[c].purgeToPlay();
					players[c].jugg=false;
						}
						players[b].finalizeOverTurn(players[b].wantsToFinalizeOverTurn());
					finalized = true;
					declared = true;
					players[b].jugg=true;
				}
				}
			}
				if ((human.canDeclareS()&& !declared) || (!finalized && human.canOverturn("S") && !human.isDeclared()) || (!finalized && human.isDeclared() && trumpc.returnSuit() == "S" && human.hasCard(trumpc))) {
					dS.visible=true;
				} else dS.visible=false;
				if ((human.canDeclareH()&&! declared)|| (!finalized && human.canOverturn("H") && !human.isDeclared()) || (!finalized && human.isDeclared() && trumpc.returnSuit() == "H" && human.hasCard(trumpc))) {
					dH.visible=true;
				}  else dH.visible=false;
				if ((human.canDeclareD()&&! declared)|| (!finalized && human.canOverturn("D") && !human.isDeclared()) || (!finalized && human.isDeclared() && trumpc.returnSuit() == "D" && human.hasCard(trumpc))) {
					dD.visible=true;
				} else dD.visible=false;
				if ((human.canDeclareC()&&! declared)|| (!finalized && human.canOverturn("C") && !human.isDeclared()) || (!finalized && human.isDeclared() && trumpc.returnSuit() == "C" && human.hasCard(trumpc))) {
					dC.visible=true;
				} else dC.visible=false;
				if (deck.isEmpty()) {
					drawButton.visible=false;
				}
			} else {
				for each (var person:Player in players) {
					if (person.jugg) {
						jugtimer.visible = true;
						overTurn.addEventListener( TimerEvent.TIMER, giveJugg );
						overTurn.start();
						return;
					}
				}
			}
		}

		public function giveJugg( timerEvent:TimerEvent ):void {
			if (jugtimer.currentValue==0) {
				dS.visible=false;
				dH.visible=false;
				dD.visible=false;
				dC.visible=false;
				while(!players[0].jugg){
				players.push(players.shift());
				}
				jugtimer.visible = false;
				finalized = true;
				Card.resort(trumpc.cardname);
				overTurn.stop();
				gameTimer.stop();
				trumpc.setPosition(37.5, 256);
				addChild(trumpc);
				for(var i:Number = 0; i < suitArray.length; i++){
					if(suitArray[i] == trumpc.returnSuit())
						suitArray.splice(i,1);
				}
				trace("the suit array is " + suitArray);
				for each (var person:Player in players) {
					if (person.jugg) {
						makeJugg(person);
						if(person == human){
						while (deck.size()!=0) {
							p1h.addC(deck.deal());
							}
						jugg.discard();
						p1h.returnCard();
						discarding=true;
						} else { 
						while (deck.size()!=0) {
							person.hand.addC(deck.deal());
							}
						jugg.discardAI();
						bottom.visible = false;
						jugg.callPartner(trumpc);
						}
						p1h.resort();
						p2h.resort();
						p3h.resort();
						p4h.resort();
						p5h.resort();
						person.purgeToPlay();
						person.removetoPlay();
					}
				}
				for each (var player:Player in players) {
				if (player.number!="1") {
					player.newBrain();
					player.rememberMine();
					}
				}
				if(jugg != human)
						compStartGame();
						for(var b:Number = 0; b < players.length; b++){
				if(!onTeam(players[b])){
					//trace(players[b] + "is not on the team");
				}
			}
			} else {
				jugtimer.addToValue(-1);
			}
		}
		
		function compStartGame():void {
			
		board.removeBoard(jugg);
		started=true;
		hasPartner = false;
		//trace("does he have a partner?" + hasPartner + " and the partner is " + partner + " and the jugg is " + jugg);
		firstOrOther.visible = true;
		if(jugg.hasCard(jugg.getCalledCard()) || bottom.hasCard(jugg.getCalledCard().getName())) { firstOrOther.setText("Only other"); onlyOther = true;} else firstOrOther.setText("First");
		setCalledCard(jugg.getCalledCard());
		popup = new PopUpCalled(jugg, firstOrOther.gettext(), jugg.getCalledCard());
		addChild(popup);
		popup.addEventListener( CardEvent.START, compStart );
		}
		function compStart(cardEvent:CardEvent):void {
			removeChild(popup);
		newRound()
		}

		public function wait( timerEvent:TimerEvent ):void {
			if (discarding) {
				for each (var card:Card in p1h.hand) {
					card.makeClickable();
				}
				if (Card.clickedarray.length==8) {
					tossButton.visible=true;
				} else {
					tossButton.visible=false;
				}
			} else {
				if (started&&players[0]=="1") {
					//autoPlayforMe();
					for each (var card:Card in p1h.hand) {
						card.makeunClickable();
						if(card.isClicked())
							card.makeClickable();
					}
					//if i am leading, i can click any card
					if (leader=="1") {
						for each (var card:Card in p1h.hand) {
							card.makeClickable();
						}//auto includes pairs
					} else //if i am following a suit, i can play any cards if i don't have it
					if (!pairs && !leadingHand.firstCard().isTrump() && !p1h.hasSuit(leadingHand.firstCard().returnSuit())) {
						for each (var card:Card in p1h.hand) {
							card.makeClickable();
						}
					} 
					else //or if it is trump and i don't have any trumps...
					if (!pairs && leadingHand.firstCard().isTrump() && !p1h.hasTrump()) {
						for each (var card:Card in p1h.hand) {
							card.makeClickable();
						}
					} //of if it is pairs and i only have one card of that suit make rest clickable
					else					
					if ((pairs && !leadingHand.firstCard().isTrump() && p1h.sumSuit(leadingHand.firstCard().returnSuit())==0 && Card.clickedarray.length > 0 && Card.clickedarray[0].returnSuit()==leadingHand.firstCard().returnSuit()) || (pairs && leadingHand.firstCard().isTrump() && p1h.numTrumps()==1 && Card.clickedarray.length > 0 && Card.clickedarray[0].isTrump())) {
						for each (var card:Card in p1h.hand) {
							card.makeClickable();
						}
					}else					//if it is pairs and i dont have the suit
					if ((pairs && !leadingHand.firstCard().isTrump() && !p1h.hasSuit(leadingHand.firstCard().returnSuit())) || (pairs && leadingHand.firstCard().isTrump() && !p1h.hasTrump())) {
						for each (var card:Card in p1h.hand) {
							card.makeClickable();
						}
					}else	//if it is pairs and i have pairs of the suit, only make the pairs clickable
					if (pairs && !leadingHand.firstCard().isTrump() && human.hasPair(leadingHand.firstCard().returnSuit()) ) {
						for each (var card:Card in p1h.hand) {
							if(card.returnSuit() == leadingHand.firstCard().returnSuit() && p1h.hasPair(card) && (Card.clickedarray.length==0 || card.isSameCard(Card.clickedarray[0]))) 
							card.makeClickable();
						}
					}else	//if it is pairs and i have pairs of the suit, only make the pairs clickable
					if (pairs && leadingHand.firstCard().isTrump() && human.hasTrumpPair() ) {
						for each (var card:Card in p1h.hand) {
							if(card.isTrump() && p1h.hasPair(card) && (Card.clickedarray.length==0 || card.isSameCard(Card.clickedarray[0]))) 
							card.makeClickable();
						}
					}else {
						for each (var card:Card in p1h.hand) {
							if((card.returnSuit()==leadingHand.firstCard().returnSuit() && !leadingHand.firstCard().isTrump() && !card.isTrump()) || (card.isTrump() && leadingHand.firstCard().isTrump())) 
							{
							card.makeClickable();
							}
						}
					} 
				} else {
					for each (var card:Card in p1h.hand) {
						card.makeunClickable();
					}
				}
				if (started&&Card.clickedarray.length>0 && !pairs) {
					playButton.visible=true;
				} else if (started && pairs &&Card.clickedarray.length==2) {
					playButton.visible=true;
				} else {
					playButton.visible=false;
				}
				//if(started)autoPlayClick();
			}
		}

		public function onClickDeal( mouseEvent:MouseEvent ):void {
			if (! deck.isEmpty()) {
				p1h.addC(deck.deal());
				deck.deal();
				deck.deal();
				deck.deal();
				deck.deal();
				if (deck.isEmpty()) {
					drawButton.visible=false;
					playButton.visible=true;
				}
			}
		}
		
		public function autoPlayClick(mouseEvent:MouseEvent):void {
			if(players[0]=="1"){
			if(leader=="1") p1h.getRandomCard().setClicked(); else
			p1h.validCard(leadingHand.firstCard()).setClicked();
			players.push(players.shift());
			dispatchEvent( new CardEvent( CardEvent.PLAY ) );
			}
		}
		
		public function autoPlayforMe():void {
			if(players[0]=="1"){
				if(leader=="1") p1h.getRandomCard().setClicked(); else
			if (pairs){p1h.validCard(leadingHand.firstCard()).setClicked();
			p1h.anotherCard(leadingHand.firstCard()).setClicked();
			} else p1h.validCard(leadingHand.firstCard()).setClicked();
			players.push(players.shift());
			dispatchEvent( new CardEvent( CardEvent.PLAY ) );
			}
		}

		public function onClickPlay( mouseEvent:MouseEvent ):void {
			dispatchEvent( new CardEvent( CardEvent.PLAY ) );
		}
		
		function afterPlayerGoes():void{
			if (p1h.led()) {
				leader="1";
				leadingHand=p1h.toPlay;
				if(leadingHand.size()==2) pairs = true; else pairs = false;
				if (pairs&&! consecutives) {
					pile.includeHand(leadingHand.getAll());
				}
				if (! pairs&&! consecutives) {
					pile.includein(p1h.toPlay.firstCard());
				}
			} else {
				if (pairs&&! consecutives) {
					pile.includeHand(p1h.toPlay.getAll());
				}
				if (! pairs&&! consecutives) {
					pile.includein(p1h.toPlay.firstCard());
				}
			}
			if((firstOrOther.gettext()=="Only other" && p1h.toPlay.hasCard(calledC.getName()) && !human.isJugg()) || (p1h.toPlay.hasCard(calledC.getName()) && !hasPartner && !human.isJugg())){
					makePartner(human);
				}
				lastHand[0] = new PlayerHandHorizontal;
			lastHand[0].adaptFrom(p1h.toPlay);
			for each (var player:Player in players) {
					if (player.number!="1") {
					player.grade();
					}
				}
			players.push(players.shift());
			while (players[0].number != leader) {
				players[0].go();
				if((firstOrOther.gettext()=="Only other" && players[0].toPlay.hasCard(calledC.getName())  && !players[0].isJugg()) || (players[0].toPlay.hasCard(calledC.getName()) && !hasPartner && !players[0].isJugg())){
					makePartner(players[0]);
				}
				if (pairs&&! consecutives) {
					pile.includeHand(players[0].toPlay.getAll());
				}
				if (! pairs&&! consecutives) {
					pile.includein(players[0].toPlay.firstCard());
				}
				
				for each (var player:Player in players) {
					if (player.number!="1") {
					player.grade();
					}
				}

				
				players.push(players.shift());
			}
			determineWinner();
			started=false;
			betweenRounds.start();
		}
		function newRound():void{
			started=true;
			if(players[0].handSize()==0){ //last round
				newGame();
			} else {
			if (players[0]!="1") {
				players[0].beginRound();
				if((firstOrOther.gettext()=="Only other" && players[0].toPlay.hasCard(calledC.getName()) && !players[0].isJugg()) || (players[0].toPlay.hasCard(calledC.getName()) && !hasPartner) && !players[0].isJugg()){
					makePartner(players[0]);
				}
				leadingHand = players[0].toPlay;
				if (pairs&&! consecutives) {
					pile.includeHand(players[0].toPlay.getAll());
				}
				if (! pairs&&! consecutives) {
					pile.includein(players[0].toPlay.firstCard());
				}
				
				if(leadingHand.size()==2) pairs = true; else pairs = false;
				players.push(players.shift());
			}
			while (players[0].number != "1") {
				players[0].go();
				if((firstOrOther.gettext()=="Only other" && players[0].toPlay.hasCard(calledC.getName()) && !players[0].isJugg()) || (players[0].toPlay.hasCard(calledC.getName()) && !hasPartner && !players[0].isJugg())){
					makePartner(players[0]);
				}
					if (pairs&&! consecutives) {
					pile.includeHand(players[0].toPlay.getAll());
				}
				if (! pairs&&! consecutives) {
					pile.includein(players[0].toPlay.firstCard());
				}
				for each (var player:Player in players) {
					if (player.number!="1") {
					player.grade();
					}
				}
				players.push(players.shift());
			}
		}
		}
		function playCard(cardEvent:CardEvent):void {
			p1h.iClicked();
			afterPlayerGoes();
		}

		public function betweenRoundWait( timerEvent:TimerEvent ):void {
			for each (var player:Player in players) {
				if (player.number!="1") {
					player.purgeToPlay();
					player.clearit();
					player.removetoPlay();
				}
			}
			cleanWinIndicator();
			p1h.clearit();
			betweenRounds.stop();
			newRound();
			previousButton.visible=true;
		}
		
		public function onClickPrevious( mouseEvent:MouseEvent ):void {
			lastShow = new LastHand();
			addChild(lastShow);
			lastShow.addEventListener( CardEvent.CONTINUE, closeShow );
		}

		public function onClickRedo( mouseEvent:MouseEvent ):void {
			for each (var player:Player in players) {
				if (player.number!="1"&&!player.toPlay.isempty()) {
					player.clearit();
				}
			}
			removeChild(p1h);
			nextRound();
			addChild(p1h);
		}
		public function onClickDeclareS( mouseEvent:MouseEvent ):void {
			if(declared && !human.isDeclared()) { 
			finalized = true;
			p1h.overturn("S");
			for(var c:Number = 0; c < players.length; c++){	
				if(players[c].jugg) players[c].purgeToPlay();
					players[c].jugg=false;
				}
			}
			else if(declared && human.isDeclared()){//finalizing
			finalized = true;
			p1h.finalize("S");
			}
			else
			p1h.declare("S");
			human.declared();
			human.jugg=true;
			dS.visible=false;
			dC.visible=false;
			dH.visible=false;
			dD.visible=false;
			declared=true;
		}
		public function onClickDeclareD( mouseEvent:MouseEvent ):void {
			if(declared && !human.isDeclared()) { 
			finalized = true;
						p1h.overturn("D");
			for(var c:Number = 0; c < players.length; c++){	
				if(players[c].jugg) players[c].purgeToPlay();
					players[c].jugg=false;
				}
			}else if(declared && human.isDeclared()){//finalizing
			finalized = true;
			p1h.finalize("D");
			}
			else p1h.declare("D");
			human.declared();
			human.jugg=true;
			dS.visible=false;
			dC.visible=false;
			dH.visible=false;
			dD.visible=false;
			declared=true;
		}
		public function onClickDeclareH( mouseEvent:MouseEvent ):void {
			if(declared && !human.isDeclared()) { 
			finalized = true; 
			p1h.overturn("H");
			for(var c:Number = 0; c < players.length; c++){	
				if(players[c].jugg) players[c].purgeToPlay();
					players[c].jugg=false;
				}
			
			}else if(declared && human.isDeclared()){//finalizing
			finalized = true;
			p1h.finalize("H");
			}
			else
			p1h.declare("H");
			human.declared();
						human.jugg=true;
			dS.visible=false;
			dC.visible=false;
			dH.visible=false;
			declared=true;
			dD.visible=false;
		}
		public function onClickDeclareC( mouseEvent:MouseEvent ):void {
			if(declared && !human.isDeclared()) { 
			finalized = true; 
			p1h.overturn("C");
			for(var c:Number = 0; c < players.length; c++){	
				if(players[c].jugg)
					players[c].purgeToPlay();
					players[c].jugg=false;
				}
			}else if(declared && human.isDeclared()){//finalizing
			finalized = true;
			p1h.finalize("C");
			}
			else p1h.declare("C");
			human.declared();
			human.jugg=true;
			dS.visible=false;
			dC.visible=false;
			dH.visible=false;
			declared=true;
			dD.visible=false;
		}

		public function onClickToss( mouseEvent:MouseEvent ):void {
			callWindow = new DeclareWindow;
			addChild(callWindow);
			callWindow.addEventListener( CardEvent.START, startGame );
			discarding=false;
			tossButton.visible=false;
			p1h.toss();
			addChild(bottom);
			bottom.visible = false;
		}

		private function determineWinner():void {
			previousButton.visible=false;
			for(var i:int = 0; i < players.length; i++){
				if(players[i]==human){
					lastHand[0] = new PlayerHandHorizontal;
					lastHand[1] = new PlayerHandHorizontal;
					lastHand[2] = new PlayerHandHorizontal;
					lastHand[3] = new PlayerHandHorizontal;
					lastHand[4] = new PlayerHandHorizontal;
					lastHand[0].adaptFrom(p1h.toPlay);
					lastHand[1].adaptFrom(players[(i+1)%5].toPlay);
					lastHand[2].adaptFrom(players[(i+2)%5].toPlay);
					lastHand[3].adaptFrom(players[(i+3)%5].toPlay);
					lastHand[4].adaptFrom(players[(i+4)%5].toPlay);
				}
			}
			for each (var player:Player in players) {
				if (player.number!="1") {
					var othersPlayed:PlayerHand = new PlayerHand;
					othersPlayed.includeHand(p1h.toPlay.getAll());
					for each (var person:Player in players) {
						if (person.number!=player.number && person.number != "1") {
							othersPlayed.includeHand(person.toPlay.getAll());
							}
						}
					player.remember(othersPlayed);
				}
			}
			if(pairs){
				var winner:Card=pile.determineBiggestPair(pile.firstS());
				for(var i:int = 0; i < Math.floor(pile.getIndex(winner)/2); i++){
					players.push(players.shift());
				}
			} else{
			var winner:Card=pile.determineLargest(pile.firstS());
			for(var i:int = 0; i < pile.getIndex(winner); i++){
			players.push(players.shift());
			}
			}
		leader=players[0];
		switch(players[0].getName()){
		case "1": p1Win.visible = true; break;
		case "2": p2Win.visible = true; break;
		case "3": p3Win.visible = true; break;
		case "4": p4Win.visible = true; break;
		default: p5Win.visible = true;
		}
		players[0].addPoints(pile.getPoints());
		board.updatePoints(players[0].number, pile.getPoints());
		pairs = false;
		if(!players[0].handSize()==0){
		pile.empty();
		}
	}
	
	public function setCalledCard(called:Card){
		calledC = new Card(called.getName());
		calledC.setPosition(43.5, 425);
		addChild(calledC);
	}
	
	function startGame(cardEvent:CardEvent):void {
		board.p1Score.visible = false;
		started=true;
		hasPartner = false;
		partner = Player.NONE;
		//trace( "the partner should be none. " + partner);
		firstOrOther.visible = true;
		if(jugg.hasCard(callWindow.getCalledCard()) || bottom.hasCard(callWindow.getCalledCard().getName())) { onlyOther = true; firstOrOther.setText("Only other"); } else firstOrOther.setText("First");
		//calledSuit.setText(callWindow.getSuit());
		setCalledCard(callWindow.getCalledCard());
		removeChild(callWindow);
		}
		
			function closeShow(cardEvent:CardEvent):void {
				removeChild(lastShow);
		}
		
		
	static function onTeam(player:Player):Boolean{
		return (jugg==player || partner == player);
	}
	
	function updateRound():void{
		for(var b:Number = 0; b < players.length; b++){
							if(players[b].getName() == "1"){
								board.p1Number.setText(players[b].getRound());
							} else if(players[b].getName() == "2"){
								board.p2Number.setText(players[b].getRound());
							} else if(players[b].getName() == "3"){
								board.p3Number.setText(players[b].getRound());
							} else if(players[b].getName() == "4"){
								board.p4Number.setText(players[b].getRound());
							} else {
								board.p5Number.setText(players[b].getRound());
							}
						}
	}
	
	function newGame():void{
		var bottomPts:Number = 0;
		for(var b:Number = 0; b < players.length; b++){
				if(!onTeam(players[b])){
					trace(players[b] + "'s points are " + players[b].getPoints());
					totalPoints += players[b].getPoints();
				}
			}
			trace(totalPoints + " is the total points?");
			if(!onTeam(players[0])) bottomPts = 2 * bottom.getPoints();
			var oldT:Number = totalPoints;
			totalPoints += bottomPts;
			trace(totalPoints + " is the total points + bottom?");
			if(totalPoints>=100){
				if(totalPoints >= 150){
					if(totalPoints >= 200){
						for(var b:Number = 0; b < players.length; b++){
							if(!onTeam(players[b])){
								players[b].addRound(3);
							}
						}
					} else {
						for(var b:Number = 0; b < players.length; b++){
							if(!onTeam(players[b])){
								players[b].addRound(2);
							}
						}
					}
				} else {
					for(var b:Number = 0; b < players.length; b++){
							if(!onTeam(players[b])){
								players[b].addRound(1);
							}
						}
				}
			} else{
				if(totalPoints < 50 && totalPoints != 0){
					for(var b:Number = 0; b < players.length; b++){
							if(onTeam(players[b])){
								players[b].addRound(2);
							}
						}
				} else if(totalPoints == 0){
						for(var b:Number = 0; b < players.length; b++){
							if(onTeam(players[b])){
								players[b].addRound(3);
							}
						}
					} else { 
					for(var b:Number = 0; b < players.length; b++){
							if(onTeam(players[b])){
								players[b].addRound(1);
							}
						}
				}
			}
			for(var b:Number = 0; b < players.length; b++){
			if (players[b].returnRound() > 14)
				over = true;
			}
			finalWindow = new FinalScore(oldT, bottomPts);
			finalWindow.addEventListener( CardEvent.RESETIT, resetIt );
			addChild(finalWindow);
			
	}
	
	function nextRound():void{
		bottom.empty();
		Card.defaultRank();
			for(var b:Number = 0; b < players.length; b++){
				players[b].purgeToPlay();
				//if(isChildOf(players[b].toPlay, players[b])) 
					//players[b].clearit();
				players[b].jugg = false;
				players[b].resetPoints();
				players[b].removetoPlay();
				players[b].resetMe();
			}
			declared = false;
			if(started) {
				removeChild(calledC);
			}
			if(finalized){
				removeChild(trumpc);
			}
			lastHand = new Array;
			finalized = false;
			totalPoints = 0;
			cleanWinIndicator();
			firstOrOther.visible= false;
			onlyOther = false;
			hideStuff();
			pile=new PlayerHand;
			started=false;
			consecutives=false;
			pairs=false;
			trumpc=null;
			discarding=false;
			trump="";
			deck = new Decks();
			p1h.purge();
			p2h.purge();
			p3h.purge();
			p4h.purge();
			p5h.purge();
			jugtimer.visible = false;
			overTurn.stop();
			gameTimer.stop();
			jugtimer.reset();
			gameTimer.start();
			jugtimer.addToValue(5);
			previousButton.visible=false;
			board.resetPoints();
			board.p1Score.visible = true;
			board.p2Score.visible = true; 
			board.p3Score.visible = true; 
			board.p4Score.visible = true; 
			board.p5Score.visible = true; 
			addChild(deck);
			suitArray[0] = "S";
			suitArray[1] = "C";
			suitArray[2] = "D";
			suitArray[3] = "H";
	}
	function resetIt(cardEvent:CardEvent):void {
		removeChild(finalWindow);
		updateRound();
			nextRound();
		}
		
		function startAllOver():void {
		over = false;
		for each (var player:Player in players) {
				if (player.number!="1"&&!player.toPlay.isempty()) {
					player.clearit();
				}
			}
			removeChild(p1h);
			nextRound();
			addChild(p1h);
		}
		
		static function getPlayed():PlayerHand {
			return pile;
		}
		/*function isChildOf(displayObjectContainer:DisplayObjectContainer, displayObject:DisplayObject):Boolean {   
		for(var i:uint = 0; i < displayObjectContainer.numChildren; i++)   {     
		if(displayObjectContainer.getChildAt(i) == displayObject)     
		return true;   
		}   
		return false; }
*/
		function makeJugg(player:Player):void{
			jugg = player;
			declared = true;
			finalized = true;
			leader = player.getName();
			switch(jugg.getName()){
			case "1": board.p1Score.visible = false; p1Team.visible = true; break;
			case "2": board.p2Score.visible = false; p2Team.visible = true; break;
			case "3": board.p3Score.visible = false; p3Team.visible = true; break;
			case "4": board.p4Score.visible = false; p4Team.visible = true;break;
			default: board.p5Score.visible = false; p5Team.visible = true;
			}
		}
		function makePartner(player:Player):void{
			partner = player;
			trace(player + " is the partner!");
			hasPartner = true;
			switch(partner.number){
			case "1": board.p1Score.visible = false; p1Team.visible = true; break;
			case "2": board.p2Score.visible = false; p2Team.visible = true; break;
			case "3": board.p3Score.visible = false; p3Team.visible = true; break;
			case "4": board.p4Score.visible = false; p4Team.visible = true;break;
			default: board.p5Score.visible = false; p5Team.visible = true;
			}
		}
		
		function hideStuff():void{
			p1Team.visible = false;
			p2Team.visible = false;
			p3Team.visible = false;
			p4Team.visible = false;
			p5Team.visible = false;
			}
			
			function cleanWinIndicator():void{
			p1Win.visible = false;
			p2Win.visible = false;
			p3Win.visible = false;
			p4Win.visible = false;
			p5Win.visible = false;
			}
			
			public static function largestSoFar():String {
				var oldPile = pile.copyMe();
				trace("the old pile was " + oldPile);
			if(pairs){
				var winner:Card=oldPile.determineBiggestPair(oldPile.firstS());
				var pileWinningIndex=pile.getIndex(winner);
				pileWinningIndex = Math.floor(pileWinningIndex/2);
			} else{
			var winner:Card=oldPile.determineLargest(oldPile.firstS());
			var pileWinningIndex=pile.getIndex(winner);
			}
			var leadingPlayer:Number=Number(GameWindow.leader);
			var theWinner:Number=0;
			if (pileWinningIndex+leadingPlayer<=5) {
				theWinner=pileWinningIndex+leadingPlayer;
			} else {
				theWinner = (pileWinningIndex+leadingPlayer)%5;
			}
			return String(theWinner);
			}
		}
}