package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.geom.Matrix;
	
	public class BrickBreaker extends Sprite
	{
		private var brickHolder:Sprite=new Sprite();
		private var powerUpHolder:Sprite=new Sprite();
		private var ballHolder:Sprite=new Sprite();
		private var laserShotHolder:Sprite=new Sprite();
		private var levelArray:Array=new Array();
		private var paddle:Sprite=new Sprite();
		private var paddle2:Sprite=new Sprite();
		private var ball:Sprite=new Sprite();
		private var keyPressed:int=0;
		private var xdir:Number=0;
		private var ydir:Number=0;
		private var xdir2:Number=0;
		private var ydir2:Number=0;
		private var xdir3:Number=0;
		private var ydir3:Number=0;
		private var xdir4:Number=0;
		private var ydir4:Number=0;
		private var xSpeed:Number=0;
		private var ySpeed:Number=0;
		private var right:Boolean=false;
		private var left:Boolean=false;
		private var up:Boolean=true;
		private var down:Boolean=false;
		private var right2:Boolean=false;
		private var left2:Boolean=false;
		private var up2:Boolean=false;
		private var down2:Boolean=false;
		private var right3:Boolean=false;
		private var left3:Boolean=false;
		private var up3:Boolean=false;
		private var down3:Boolean=false;
		private var right4:Boolean=false;
		private var left4:Boolean=false;
		private var up4:Boolean=false;
		private var down4:Boolean=false;
		private var givenRight:Boolean=false;
		private var givenLeft:Boolean=false;
		private var givenUp:Boolean=false;
		private var givenDown:Boolean=false;
		private var xdirAdder:Number=0;
		private var ydirAdder:Number=0;
		private var temp:Boolean=false;
		private var temp2:Boolean=false;
		private var started:Boolean=false;
		private var score:uint=0;
		private var scoreText:TextField=new TextField;  
		private var level:uint=1;
		private var levelText:TextField=new TextField;
		private var lives:uint=3;
		private var livesText:TextField=new TextField;
		private var ammo:uint=0;
		private var ammoText:TextField=new TextField;
		private var stop:Boolean=false;
		private var messageTimer:Timer=new Timer(100);
		private var hit:Boolean=false;
		private var groundTimer:Timer=new Timer(100);
		private var powerUpTimer:Timer=new Timer(100);
		private var superBallTimer:Timer=new Timer(100);
		private var spacebarMessage:TextField=new TextField;
		private var powerUpMessage:TextField=new TextField;
		private var dropX:uint=0;
		private var dropY:uint=0;
		private var groundLock:Boolean=false;
		private var ground:Sprite=new Sprite(); 
		private var distMove:int=20;
		private var superBallOn:Boolean=false;
		private var laser1:Sprite=new Sprite();
		private var laser2:Sprite=new Sprite();
		private var laserOn:Boolean=false;
		private var mySound:Sound=new Sound();
		private var mySound2:Sound=new Sound();
		private var mySound3:Sound=new Sound();
		private var mySound4:Sound=new Sound();
		private var mySound5:Sound=new Sound();
		private var mySound6:Sound=new Sound();
		private var mySound7:Sound=new Sound();
		private var song:Sound=new Sound();
		private var channel:SoundChannel=new SoundChannel();
		private var channel2:SoundChannel=new SoundChannel();
		private var url:String ="background.jpg";
		private var loader:Loader=new Loader();
		public function BrickBreaker()
		{
			addMusic();
			//makeBackground();
			createBorder();
			createPaddle();
			createBricks();
			createBall();
			addText();
			updateSpeed();
			addChild(brickHolder);
			addChild(laserShotHolder);
			addChild(laser1);
			addChild(laser2);
			addChild(powerUpHolder);
			addChild(ballHolder);
			addChild(paddle);
			spacebarMessage.text="Press the Spacebar";
			spacebarMessage.textColor=0x000000;
			spacebarMessage.height=20;
			spacebarMessage.width=200;
			spacebarMessage.x=205;
			spacebarMessage.y=170;
			spacebarMessage.alpha=1;
			addChild(spacebarMessage);
			drawMessage();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, hearKey);
			stage.frameRate=36;
		}
		private function makeBackground():void{	
			var request:URLRequest=new URLRequest(url);
			loader.load(request);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, drawImage);
			//loader.contentLoaderInfo.addEventListener(
		}
		private function drawImage(event:Event):void{		
			var mySprite:Sprite=new Sprite();
			var myBitmap:BitmapData=new BitmapData(loader.width,loader.height,true);			
			myBitmap.draw(loader, new Matrix());		
			var matrix:Matrix=new Matrix();
			//matrix.rotate(Math.PI/4);			
			mySprite.graphics.beginBitmapFill(myBitmap, matrix, true);
			mySprite.graphics.drawRect(0,0,400,300);
			mySprite.x=50;
			mySprite.y=35;
			//mySprite.graphics.endFill();	
			addChild(mySprite);
		}
		private function addMusic():void{
			song.load(new URLRequest("Grease Monkey.mp3"));
			//channel=song.play(0,1000);
			mySound.load(new URLRequest("Pop2.mp3"));
			mySound2.load(new URLRequest("Power-Up.mp3"));
			mySound3.load(new URLRequest("miss.mp3"));
			mySound4.load(new URLRequest("Applause.mp3"));
			mySound5.load(new URLRequest("Sad Trombone Sound.mp3"));
			mySound6.load(new URLRequest("Fireworks.mp3"));
			mySound7.load(new URLRequest("Laser.mp3"));
		}
		private function createBorder():void{
			var border:Sprite=new Sprite();
			border.graphics.lineStyle(1,0x000000);
			border.graphics.beginFill(0x008CFF);
			border.graphics.drawRect(0,0,400,300);
			border.x=50;
			border.y=35;
			addChild(border);
		}
		private function createBricks():void{
			levelArray.splice(0,levelArray.length);
			if (level==1){
				levelArray.push(0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
			}
			else if (level==2){
				levelArray.push(0,0,0,0,0,0,0,0,0,0,0,1,1,0,2,2,0,3,3,0,0,1,1,0,2,2,0,3,3,0,0,0,0,0,0,0,0,0,0,0,0,4,4,0,5,5,0,1,1,0,0,4,4,0,5,5,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,2,2,0,3,3,0,4,4,0,0,2,2,0,3,3,0,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
			}
			else if (level==3){
				levelArray.push(0,0,0,0,0,0,0,0,0,0,1,2,1,2,1,2,0,0,0,0,0,3,2,3,2,3,2,0,0,0,0,0,3,4,3,4,3,4,0,0,0,0,0,5,4,5,4,5,4,0,0,0,0,0,5,6,5,6,5,6,0,0,0,5,4,5,4,5,4,0,0,0,3,4,3,4,3,4,0,0,0,3,2,3,2,3,2,0,0,0,1,2,1,2,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
			}
			else if (level==4){
				levelArray.push(0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,1,2,3,0,0,4,0,0,2,3,0,0,1,0,0,2,0,0,5,1,0,0,4,0,0,5,1,2,3,4,5,1,2,0,0,3,4,5,0,0,3,4,5,0,0,1,2,3,0,0,1,2,3,0,0,4,5,1,2,3,4,5,1,0,0,2,0,0,5,1,0,0,4,0,0,5,0,0,3,4,0,0,2,0,0,3,4,5,1,2,3,4,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
			}
			else if (level==5){
				levelArray.push(1,2,3,4,5,6,1,2,3,4,0,0,0,0,0,0,0,0,0,5,5,6,1,2,3,4,5,6,0,6,4,0,0,0,0,0,0,1,0,1,3,0,1,2,3,4,0,2,0,2,2,0,6,0,0,5,0,3,0,3,1,0,5,0,5,6,0,4,0,4,6,0,4,0,4,1,0,5,0,5,5,0,3,0,3,2,0,6,0,6,4,0,2,0,0,0,0,1,0,1,3,0,1,6,5,4,3,2,0,2,2,0,0,0,0,0,0,0,0,3,1,6,5,4,3,2,1,6,5,4)
			}
			else if (level==6){
				levelArray.push(0,0,0,0,0,0,0,0,0,0,0,1,0,6,0,0,6,0,1,0,0,0,1,5,5,5,5,1,0,0,0,6,5,1,4,4,1,5,6,0,0,0,5,4,3,3,4,5,0,0,0,0,5,4,3,3,4,5,0,0,0,6,5,1,4,4,1,5,6,0,0,0,1,5,5,5,5,1,0,0,0,1,0,6,0,0,6,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
			}
			else if (level==7){
				levelArray.push(0,0,2,1,2,1,2,1,0,0,0,2,1,2,1,2,1,2,1,0,2,1,2,1,2,1,2,1,2,1,0,0,0,0,0,0,0,0,0,0,4,3,4,3,4,3,4,3,4,3,0,4,3,4,3,4,3,4,3,0,0,0,4,3,4,3,4,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,6,5,6,5,6,0,0,0,5,6,5,6,5,6,5,6,0,5,6,5,6,5,6,5,6,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
			}
			else if (level==8){
				levelArray.push(0,1,2,3,4,5,4,3,2,1,1,2,3,4,5,4,3,2,1,0,6,0,0,0,0,0,0,0,0,6,5,0,3,4,3,4,3,4,0,5,6,0,4,1,2,1,2,3,0,6,5,0,3,2,0,0,1,4,0,5,6,0,4,1,0,0,2,3,0,6,5,0,3,2,0,0,1,4,0,5,6,0,4,1,2,1,2,3,0,6,5,0,3,4,3,4,3,4,0,5,6,0,0,0,0,0,0,0,0,6,0,1,2,3,4,5,4,3,2,1,1,2,3,4,5,4,3,2,1,0)
			}
			else if (level==9){
				levelArray.push(5,2,1,3,2,4,3,5,4,1,4,1,5,2,0,0,2,4,3,5,3,5,0,0,0,0,0,0,2,4,2,4,3,5,0,0,5,2,1,3,1,3,2,4,3,5,4,1,5,2,2,4,3,5,0,0,5,2,1,3,3,5,0,0,0,0,0,0,2,4,4,1,5,2,0,0,2,4,3,5,5,2,1,3,2,4,3,5,4,1,4,1,5,2,0,0,2,4,3,5,3,5,0,0,0,0,0,0,2,4,2,4,3,5,0,0,5,2,1,3,1,3,2,4,3,5,4,1,5,2)
			}
			else if (level==10){
				levelArray.push(1,0,3,0,5,0,2,0,4,0,0,2,0,4,0,1,0,3,0,5,1,0,3,0,5,0,2,0,4,0,0,2,0,4,0,1,0,3,0,5,1,0,3,0,5,0,2,0,4,0,0,2,0,4,0,1,0,3,0,5,1,0,3,0,5,0,2,0,4,0,0,2,0,4,0,1,0,3,0,5,1,0,3,0,5,0,2,0,4,0,0,2,0,4,0,1,0,3,0,5,1,0,3,0,5,0,2,0,4,0,0,2,0,4,0,1,0,3,0,5,1,0,3,0,5,0,2,0,4,0)
			}
			else if (level==11){
				levelArray.push(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,7,0,0,1,1,0,0,7,5,7,7,0,0,2,2,0,0,7,7,0,0,0,0,3,3,0,0,0,0,0,0,0,0,4,4,0,0,0,0,4,7,0,0,5,5,0,0,7,3,7,7,0,0,1,1,0,0,7,7,0,0,0,0,2,2,0,0,0,0,0,0,0,0,3,3,0,0,0,0,2,7,0,0,4,4,0,0,7,1,7,7,0,0,5,5,0,0,7,7,0,0,0,0,0,0,0,0,0,0)
			}
			else if (level==12){
				levelArray.push(0,0,0,0,0,0,0,0,0,0,1,2,3,2,1,2,3,2,1,2,2,0,0,0,0,0,0,0,0,3,3,0,7,7,7,7,7,7,0,2,2,0,7,0,0,0,0,7,0,1,1,0,7,0,5,4,0,7,0,2,2,0,0,0,6,3,0,0,0,3,3,0,7,0,1,2,0,7,0,2,2,0,7,0,0,0,0,7,0,1,1,0,7,7,7,7,7,7,0,2,2,0,0,0,0,0,0,0,0,3,3,2,1,2,3,2,1,2,3,2,0,0,0,0,0,0,0,0,0,0)
			}
			else if (level==13){
				levelArray.push(0,7,7,7,7,7,7,7,7,0,7,0,0,0,0,0,0,0,0,7,7,0,0,7,7,7,7,0,0,7,7,0,7,0,0,0,0,7,0,7,7,0,7,0,0,0,0,7,0,7,7,0,7,0,1,7,0,7,0,7,7,0,7,0,2,7,0,7,0,7,7,0,7,0,3,7,0,7,0,7,7,0,7,0,4,7,0,7,0,7,7,0,7,0,5,7,0,7,0,7,7,0,0,7,7,0,0,7,0,7,7,0,0,0,0,0,0,7,0,7,0,7,7,7,7,7,7,0,0,7)
			}
			else if (level==14){
				levelArray.push(0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,4,5,6,7,0,0,7,0,0,4,5,6,0,7,0,0,7,0,4,5,6,0,0,7,0,0,7,4,5,6,0,0,0,7,0,0,7,0,4,5,6,0,0,7,0,0,7,0,0,4,5,6,0,7,0,0,7,0,0,0,4,5,6,7,0,0,7,0,0,4,5,6,0,7,0,0,7,0,4,5,6,0,0,7,0,0,7,4,5,6,0,0,0,7,0,0,7,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0,0)
			}
			else if (level==15){
				levelArray.push(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,7,7,3,3,3,0,0,1,1,1,7,7,3,3,3,0,0,1,1,1,7,7,3,3,3,0,0,1,1,1,7,7,3,3,3,0,0,7,7,7,7,7,7,7,7,0,0,7,7,7,7,7,7,7,7,0,0,4,4,4,7,7,5,5,5,0,0,4,4,4,7,7,5,5,5,0,0,4,4,4,7,7,5,5,5,0,0,4,4,4,7,7,5,5,5,0,0,0,0,0,0,0,0,0,0,0)
			}
			else if (level==16){
				levelArray.push(0,5,0,0,0,1,0,0,0,3,0,0,0,4,0,0,0,6,0,0,1,0,4,3,4,0,6,5,6,0,0,0,0,4,0,0,0,6,0,0,0,6,0,0,0,3,0,0,0,2,6,5,6,0,3,4,3,0,2,1,0,6,0,0,0,3,0,0,0,2,0,0,0,2,0,0,0,5,0,0,3,0,2,1,2,0,5,6,5,0,0,0,0,2,0,0,0,5,0,0,0,7,0,0,0,7,0,0,0,7,7,0,7,0,7,0,7,0,7,0,0,7,0,0,0,7,0,0,0,7)
			}
			else if (level==17){
				levelArray.push(0,0,0,0,0,0,0,0,0,0,0,7,0,6,0,7,0,5,0,0,0,0,6,0,7,0,5,0,7,0,0,6,0,7,0,5,0,7,0,0,0,0,7,0,5,0,7,0,4,0,0,7,0,5,0,7,0,4,0,0,0,0,5,0,7,0,4,0,7,0,0,5,0,7,0,4,0,7,0,0,0,0,7,0,4,0,7,0,5,0,0,7,0,4,0,7,0,5,0,0,0,0,4,0,7,0,5,0,7,0,0,4,0,7,0,5,0,7,0,0,0,0,7,0,5,0,7,0,6,0)
			}
			else if (level==18){
				levelArray.push(2,3,2,3,2,3,2,3,2,3,0,7,0,0,0,7,0,0,0,7,0,3,4,3,4,3,4,3,4,0,7,0,0,0,7,0,0,0,7,0,0,0,4,5,4,5,4,5,0,0,0,7,0,0,0,7,0,0,0,7,0,5,6,5,6,5,6,5,6,0,7,0,0,0,7,0,0,0,7,0,0,0,4,5,4,5,4,5,0,0,0,7,0,0,0,7,0,0,0,7,0,3,4,3,4,3,4,3,4,0,7,0,0,0,7,0,0,0,7,0,2,3,2,3,2,3,2,3,2,3)
			}
			else if (level==19){
				levelArray.push(6,6,6,6,6,6,5,7,5,6,5,5,5,5,5,5,5,7,5,6,5,7,1,1,1,1,1,7,5,6,5,7,5,5,5,5,5,5,5,6,5,7,2,2,2,7,5,6,6,6,5,5,5,5,5,7,5,5,5,5,6,6,6,6,5,7,3,3,3,7,0,6,5,5,5,5,5,5,5,7,0,6,5,7,4,4,4,4,4,7,0,6,5,7,5,5,5,5,5,5,0,6,5,7,5,6,6,6,6,6,0,6,5,5,5,6,0,0,0,0,0,6,6,6,6,6,0,0,0,0)
			}
			else if (level==20){
				levelArray.push(7,7,7,7,7,7,7,7,7,7,1,0,2,7,3,0,4,7,5,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,0,7,1,0,2,7,3,0,4,7,0,7,7,7,7,7,7,7,7,7,0,0,0,0,0,0,0,0,0,0)
			}
			for (var i:uint=0; i<13; i++){
				for (var j:uint=0; j<10; j++){
					var gridSprite:Sprite=new Sprite();
					gridSprite.graphics.lineStyle(1,0x000000);
					var brick2:Sprite=new Sprite();
					brick2.graphics.lineStyle(1,0x000000);
					brick2.visible=false;
					if (levelArray[(i*10)+j]!=0){
						var chosenColor:uint=levelArray[(i*10)+j];
						if (chosenColor==1){
							gridSprite.graphics.beginFill(0xFF0000);
						}
						else if (chosenColor==2){
							gridSprite.graphics.beginFill(0xFF6200);
						}
						else if (chosenColor==3){
							gridSprite.graphics.beginFill(0xFFF700);
						}
						else if (chosenColor==4){
							gridSprite.graphics.beginFill(0x0ACF00);
						}
						else if (chosenColor==5){
							gridSprite.graphics.beginFill(0x1500FF);
						}
						else if (chosenColor==6){
							gridSprite.graphics.beginFill(0x9000FF);
						}
						else if (chosenColor==7){
							gridSprite.graphics.beginFill(0x616161);
							gridSprite.name="616161";
							brick2.name="616161";
						}
						gridSprite.graphics.drawRect(0,0,40,20);
						gridSprite.x=50+40*j;
						gridSprite.y=35+20*i;
						brick2.graphics.drawRect(0,0,50,30);
						brick2.x=45+40*j;
						brick2.y=30+20*i;
						brickHolder.addChild(brick2);
						brickHolder.addChild(gridSprite);
					}
				}
			}
		}
		private function createPaddle():void{
			paddle.graphics.lineStyle(1,0x000000);
			paddle.graphics.beginFill(0xD4A017);
			paddle.graphics.drawRoundRect(0,0,80,9.5,9.5,9.5);
			paddle.x=210;
			paddle.y=325;
			paddle2.graphics.lineStyle(1,0x000000);
			paddle2.graphics.drawRect(0,0,90,9.5);
			paddle2.visible=false;
			paddle2.x=205;
			paddle2.y=320;
			addChild(paddle2);
		}
		private function createBall():void{
			ball.graphics.lineStyle(1,0x000000);
			ball.graphics.beginFill(0xFF0000);
			ball.graphics.drawCircle(0,0,5);
			ball.x=Math.floor((2*paddle.x+paddle.width)/2);
			ball.y=320;
			ball.name="ball1";
			ballHolder.addChild(ball);
		}
		private function addText():void{
			for (var i:uint=0; i<240; i+=60){
				var rect:Sprite=new Sprite();
				rect.graphics.lineStyle(1,0x000000);
				rect.graphics.beginFill(0x008CFF);
				rect.graphics.drawRect(475,35+i,120,60);
				addChild(rect);
			}
			var scoreTxt:TextField=new TextField;
			scoreTxt.text="Score";
			scoreTxt.textColor=0xFF0000;
			scoreTxt.height=20;
			scoreTxt.width=200
			scoreTxt.x=520;
			scoreTxt.y=40;
			underlineTextField(scoreTxt);
			addChild(scoreTxt);
			var levelTxt:TextField=new TextField;
			levelTxt.text="Level";
			levelTxt.textColor=0xFF0000;
			levelTxt.height=20;
			levelTxt.width=200
			levelTxt.x=520;
			levelTxt.y=100;
			underlineTextField(levelTxt);
			addChild(levelTxt);
			var livesTxt:TextField=new TextField;
			livesTxt.text="Lives";
			livesTxt.textColor=0xFF0000;
			livesTxt.height=20;
			livesTxt.width=200
			livesTxt.x=520;
			livesTxt.y=160;
			underlineTextField(livesTxt);
			addChild(livesTxt);
			var ammoTxt:TextField=new TextField;
			ammoTxt.text="Ammo";
			ammoTxt.textColor=0xFF0000;
			ammoTxt.height=20;
			ammoTxt.width=200
			ammoTxt.x=517;
			ammoTxt.y=220;
			underlineTextField(ammoTxt);
			addChild(ammoTxt);
			var title:TextField=new TextField;
			title.text="Brick Breaker";
			title.textColor=0x000000;
			title.height=20;
			title.width=200
			title.x=535;
			title.y=310; 
			italicizeTextField(title);
			var signature:TextField=new TextField;
			signature.text="By Jeremy Bader"
			signature.textColor=0x000000;
			signature.height=20;
			signature.width=200
			signature.x=525;
			signature.y=325; 
			italicizeTextField(signature);
			var myFormat:TextFormat=new TextFormat();
			myFormat.size=12.5;
			myFormat.align=TextFormatAlign.CENTER;
			scoreText.x=485;
			scoreText.y=60;
			scoreText.defaultTextFormat=myFormat;
			levelText.x=485;
			levelText.y=120;
			levelText.defaultTextFormat=myFormat;
			livesText.x=485;
			livesText.y=180;
			livesText.defaultTextFormat=myFormat;
			ammoText.x=485;
			ammoText.y=240;
			ammoText.defaultTextFormat=myFormat;
			addChild(scoreText);
			addChild(levelText);
			addChild(livesText);
			addChild(ammoText);
			addChild(title);
			addChild(signature);
			updateScore()
			updateLevel()
			updateLives()
			updateAmmo();
		}
		private function underlineTextField(myTextField:TextField):void{ 
			var myInputTextFormat:TextFormat=new TextFormat();
			myInputTextFormat.underline=true;
			myTextField.setTextFormat(myInputTextFormat);
		}
		private function italicizeTextField(myTextField:TextField):void{ 
			var myInputTextFormat:TextFormat=new TextFormat();
			myInputTextFormat.italic=true;
			myInputTextFormat.size=10;
			myTextField.setTextFormat(myInputTextFormat);
		}
		private function updateScore():void {
			scoreText.text=""+score.toString();
		}
		private function updateLevel():void {
			levelText.text=""+level.toString();
		}
		private function updateLives():void {
			livesText.text=""+lives.toString();
		}
		private function updateAmmo():void {
			ammoText.text=""+ammo.toString();
		}
		private function updateSpeed():void{
			var num:Number=Math.random();
			if (num<.5){
				right=true;
				left=false;
				xSpeed=2.5;
			}
			else{
				right=false;
				left=true;
				xSpeed=-2.5;
			}
			ySpeed=2.5;
		}
		private function loseLife():void{
			for (var i:uint=0; i<powerUpHolder.numChildren; i++){
				var powerUp:Sprite=powerUpHolder.getChildAt(i) as Sprite;
				powerUpHolder.removeChild(powerUp);
				i--;
			}
			for (i=0; i<laserShotHolder.numChildren; i++){
				var shotlaserShot:Sprite=laserShotHolder.getChildAt(i) as Sprite;
				laserShotHolder.removeChild(shotlaserShot);
				i--;
			}
			ground.visible=false;
			if (ground.alpha>0){
				paddle.height=10.5;
				ground.alpha=-1;
			}
			ammo=0;
			updateAmmo();
			laserOn=false;
			laser1.visible=false;
			laser2.visible=false;
			superBallOn=false;
			superBallTimer.reset();
			distMove=20;
			stage.frameRate=36;
			powerUpMessage.alpha=0;
			lives--;
			updateLives();
			paddle.width=80;
			paddle2.width=90;
			paddle.x=290-paddle.width-(80-paddle.width)/2;
			paddle.y=325;
			paddle2.x=295-paddle2.width-(90-paddle2.width)/2;
			paddle2.y=320;
			xdir=xSpeed;
			ydir=ySpeed;
			ball.x=Math.floor((2*paddle.x+paddle.width)/2);
			ball.y=320;
			ballHolder.addChild(ball);
			started=false;
			up=true;
			down=false;
			updateSpeed();
			if (lives==0){
				gameOver();
				mySound5.play();
				channel.stop();
			}
			else{
				spacebarMessage.alpha=1;
				addChild(spacebarMessage);
				drawMessage();
				mySound3.play();
			}
		}
		private function drawMessage():void{
			messageTimer.start();
			messageTimer.addEventListener(TimerEvent.TIMER, newMessage)
		}
		private function newMessage(e:TimerEvent):void{
			spacebarMessage.alpha-=.05;
			if (spacebarMessage.alpha<0){ 
				if (contains(spacebarMessage)){
					removeChild(spacebarMessage);
				}	
			}
		}
		private function gameOver():void{				
			stop=true;
			var playAgain:Sprite=new Sprite();
			playAgain.graphics.lineStyle(1,0x000000);
			playAgain.graphics.beginFill(0x008CFF);
			playAgain.graphics.drawRect(-95,35,120,60);
			playAgain.buttonMode=true;
			addChild(playAgain);
			var replay:TextField=new TextField;
			replay.text="Play Again";
			replay.textColor=0xFF0000;
			replay.height=20;
			replay.width=200;
			replay.x=-65;
			replay.y=55;
			replay.selectable=false;
			playAgain.addChild(replay);
			var gameOverMessage:TextField=new TextField;
			gameOverMessage.text="Your Final Score is " + score.toString() + ".";
			gameOverMessage.textColor=0x000000;
			gameOverMessage.height=20;
			gameOverMessage.width=300;
			var helpString:String=score.toString();
			gameOverMessage.x=210-helpString.length*4;
			gameOverMessage.y=160;
			addChild(gameOverMessage);
			playAgain.addChild(gameOverMessage);
			var gameOverMessage2:TextField=new TextField;
			gameOverMessage2.text="Click on 'Play Again' to Start Over.";
			gameOverMessage2.textColor=0x000000;
			gameOverMessage2.height=20;
			gameOverMessage2.width=300;
			gameOverMessage2.x=170;
			gameOverMessage2.y=180;
			addChild(gameOverMessage2);
			playAgain.addChild(gameOverMessage2);
			if (level==21){
				var gameOverMessage3:TextField=new TextField;
				gameOverMessage3.text="Congratulations, You Beat the Game!";
				gameOverMessage3.textColor=0x000000;
				gameOverMessage3.height=20;
				gameOverMessage3.width=300;
				gameOverMessage3.x=162.5;
				gameOverMessage3.y=140;
				addChild(gameOverMessage3);
				playAgain.addChild(gameOverMessage3);
			}
			playAgain.addEventListener(MouseEvent.CLICK,onPlayAgainClicked);
		}
		private function onPlayAgainClicked(e:MouseEvent):void{
			spacebarMessage.alpha=1;
			addChild(spacebarMessage);
			drawMessage();
			e.currentTarget.removeEventListener(MouseEvent.CLICK, onPlayAgainClicked);
			var playAgainToRemove:Sprite=e.currentTarget as Sprite;
			removeChild(playAgainToRemove);
			for (var i:uint=0; i<brickHolder.numChildren; i++){
				var brick:Sprite=brickHolder.getChildAt(i) as Sprite;
				brickHolder.removeChild(brick);
				i--;
			}
			level=1;
			createBricks();
			lives=3;
			score=0;
			updateScore()
			updateLevel()
			updateLives()
			stop=false;
			//channel=song.play(0,1000);
			channel2.stop();
		}
		private function nextLevel():void{
			for (var i:uint=0; i<powerUpHolder.numChildren; i++){
				var powerUp:Sprite=powerUpHolder.getChildAt(i) as Sprite;
				powerUpHolder.removeChild(powerUp);
				i--;
			}
			for (var j:uint=0; j<ballHolder.numChildren; j++){
				var thisBall:Sprite=ballHolder.getChildAt(j) as Sprite;
				ballHolder.removeChild(thisBall);
				j--;
			}
			for (i=0; i<laserShotHolder.numChildren; i++){
				var shotlaserShot:Sprite=laserShotHolder.getChildAt(i) as Sprite;
				laserShotHolder.removeChild(shotlaserShot);
				i--;
			}
			for (i=0; i<brickHolder.numChildren; i++){
				var brickToRemove:Sprite=brickHolder.getChildAt(i) as Sprite;
				brickHolder.removeChild(brickToRemove);
				i--;
			}
			ground.visible=false;
			if (ground.alpha>0){
				paddle.height=10.5;
				ground.alpha=-1;
			}
			ammo=0;
			updateAmmo();
			laserOn=false;
			laser1.visible=false;
			laser2.visible=false;
			superBallOn=false;
			superBallTimer.reset();
			distMove=20;
			stage.frameRate=36;
			powerUpMessage.alpha=0;
			paddle.width=80;
			paddle2.width=90;
			paddle.x=290-paddle.width-(80-paddle.width)/2;
			paddle.y=325;
			paddle2.x=295-paddle2.width-(90-paddle2.width)/2;
			paddle2.y=320;
			xdir=xSpeed;
			ydir=ySpeed;
			ball.x=Math.floor((2*paddle.x+paddle.width)/2);
			ball.y=320;
			ballHolder.addChild(ball);
			started=false;
			up=true;
			down=false;
			updateSpeed();
			level++;
			updateLevel();
			if (level<21){
				createBricks();
				mySound4.play();
				spacebarMessage.alpha=1;
				addChild(spacebarMessage);
				drawMessage();
			}
		}
		private function powerUp():void{
			powerUpTimer.start();
			powerUpTimer.addEventListener(TimerEvent.TIMER, newPowerUp)
		}
		private function newPowerUp(e:TimerEvent):void{
			var num:Number=Math.random();
			if (started==false){
				hit=false;
			}
			if (hit==true){
				var myFormat:TextFormat=new TextFormat();
				myFormat.size=6.5;
				myFormat.align=TextFormatAlign.CENTER;
				var powerUp:Sprite=new Sprite();
				powerUp.graphics.lineStyle(1,0x000000);
				if (num<.02){
					powerUp.name="FF00F7";
					powerUp.graphics.beginFill(0xFF00F7);
					var extraLifeText:TextField=new TextField;  
					extraLifeText.x=-39.5;
					extraLifeText.y=-1;
					extraLifeText.defaultTextFormat=myFormat;
					extraLifeText.textColor=0xFFFFFF;
					extraLifeText.text="Life";
					powerUp.addChild(extraLifeText);
				}
				else if (num<.05){
					if (paddle.width>200){
						num=1;
					}
					else{
						powerUp.name="00A2AD";
						powerUp.graphics.beginFill(0x00A2AD);
						var lengthenPaddleText:TextField=new TextField;  
						lengthenPaddleText.x=-39.5;
						lengthenPaddleText.y=-1;
						lengthenPaddleText.defaultTextFormat=myFormat;
						lengthenPaddleText.textColor=0xFFFFFF;
						lengthenPaddleText.text="Long";
						powerUp.addChild(lengthenPaddleText);
					}
				}
				else if (num<.08){
					powerUp.name="6C2DC7";
					powerUp.graphics.beginFill(0x6C2DC7);
					var shortenPaddleText:TextField=new TextField;  
					shortenPaddleText.x=-39.5;
					shortenPaddleText.y=-1;
					shortenPaddleText.defaultTextFormat=myFormat;
					shortenPaddleText.textColor=0xFFFFFF;
					shortenPaddleText.text="Short";
					powerUp.addChild(shortenPaddleText);
				}
				else if (num<.10){
					powerUp.name="8C8C8C";
					powerUp.graphics.beginFill(0xD4A017);
					var lockGroundText:TextField=new TextField;  
					lockGroundText.x=-39.5;
					lockGroundText.y=-1;
					lockGroundText.defaultTextFormat=myFormat;
					lockGroundText.textColor=0xFFFFFF;
					lockGroundText.text="Lock";
					powerUp.addChild(lockGroundText);
				}
				else if (num<.13){
					var counter:uint=0;
					for (var h:uint=0; h<powerUpHolder.numChildren; h++){
						var droppedPowerUp:Sprite=powerUpHolder.getChildAt(h) as Sprite;
						if (droppedPowerUp.name=="F88017"){
							counter++;
						}
					}
					if (stage.frameRate<36+36*((4/3)*counter)){
						num=1;
					}
					else{
						powerUp.name="F88017";
						powerUp.graphics.beginFill(0xF88017);
						var decreaseSpeedText:TextField=new TextField;  
						decreaseSpeedText.x=-39.5;
						decreaseSpeedText.y=-1;
						decreaseSpeedText.defaultTextFormat=myFormat;
						decreaseSpeedText.textColor=0xFFFFFF;
						decreaseSpeedText.text="Slow";
						powerUp.addChild(decreaseSpeedText);
					}
				}
				else if (num<.16){
					powerUp.name="F62817";
					powerUp.graphics.beginFill(0xF62817);
					var increaseSpeedText:TextField=new TextField;  
					increaseSpeedText.x=-39.5;
					increaseSpeedText.y=-1;
					increaseSpeedText.defaultTextFormat=myFormat;
					increaseSpeedText.textColor=0xFFFFFF;
					increaseSpeedText.text="Fast";
					powerUp.addChild(increaseSpeedText);
				}
				else if (num<.19){
					powerUp.name="0ACF00";
					powerUp.graphics.beginFill(0x0ACF00);
					var flipArrowsText:TextField=new TextField;  
					flipArrowsText.x=-39.5;
					flipArrowsText.y=-1;
					flipArrowsText.defaultTextFormat=myFormat;
					flipArrowsText.textColor=0xFFFFFF;
					flipArrowsText.text="Flip";
					powerUp.addChild(flipArrowsText);
				}
				else if (num<.21){
					var counter2:uint=0;
					for (var g:uint=0; g<powerUpHolder.numChildren; g++){
						var droppedPowerUp2:Sprite=powerUpHolder.getChildAt(g) as Sprite;
						if (droppedPowerUp2.name=="ED61FF"){
							counter2++;
						}
					}
					if (counter2>0&&ballHolder.numChildren==1){
						num=1;
					}
					else if (ballHolder.numChildren>1){
						num=1;
					}
					else{
						powerUp.name="ED61FF";
						powerUp.graphics.beginFill(0xED61FF);
						var multiBallText:TextField=new TextField;  
						multiBallText.x=-39.5;
						multiBallText.y=-1;
						multiBallText.defaultTextFormat=myFormat;
						multiBallText.textColor=0xFFFFFF;
						multiBallText.text="Multi";
						powerUp.addChild(multiBallText);
					}
				}
				else if (num<.23){
					var counter3:uint=0;
					for (var f:uint=0; f<powerUpHolder.numChildren; f++){
						var droppedPowerUp3:Sprite=powerUpHolder.getChildAt(f) as Sprite;
						if (droppedPowerUp3.name=="302ADE"){
							counter3++;
						}
					}
					if (counter3>0||superBallOn){
						num=1;
					}
					else{
						powerUp.name="302ADE";
						powerUp.graphics.beginFill(0x302ADE);
						var superBallText:TextField=new TextField;  
						superBallText.x=-39.5;
						superBallText.y=-1;
						superBallText.defaultTextFormat=myFormat;
						superBallText.textColor=0xFFFFFF;
						superBallText.text="Super";
						powerUp.addChild(superBallText);
					}
				}
				else if (num<.26){
					powerUp.name="9000FF";
					powerUp.graphics.beginFill(0x9000FF);
					var addPointsText:TextField=new TextField;  
					addPointsText.x=-39.5;
					addPointsText.y=-1;
					addPointsText.defaultTextFormat=myFormat;
					addPointsText.textColor=0xFFFFFF;
					addPointsText.text="Bonus";
					powerUp.addChild(addPointsText);
				}
				else if (num<.28){
					var counter4:uint=0;
					for (var r:uint=0; r<powerUpHolder.numChildren; r++){
						var droppedPowerUp4:Sprite=powerUpHolder.getChildAt(r) as Sprite;
						if (droppedPowerUp4.name=="0000FF"){
							counter4++;
						}
					}
					if (counter4>0||laserOn){
						num=1;
					}
					powerUp.name="0000FF";
					powerUp.graphics.beginFill(0x0000FF);
					var addlaserText:TextField=new TextField;  
					addlaserText.x=-39.5;
					addlaserText.y=-1;
					addlaserText.defaultTextFormat=myFormat;
					addlaserText.textColor=0xFFFFFF;
					addlaserText.text="Laser";
					powerUp.addChild(addlaserText);
				}
				powerUp.graphics.drawRoundRect(0,0,20,7.5,7.5,7.5);
				powerUp.x=dropX;
				powerUp.y=dropY;
				if (num<.28){
					powerUpHolder.addChild(powerUp);
				}
				hit=false;
			}
		}
		private function powerUpPlayer(droppedPowerUp:Sprite):void{
			if (droppedPowerUp.name=="FF00F7"){
				powerUpMessage.text="You Gained an Extra Life!";
				powerUpMessage.textColor=0x000000;
				lives++;
				updateLives();
			}
			else if (droppedPowerUp.name=="00A2AD"){
				powerUpMessage.text="You Lengthened Your Paddle";
				powerUpMessage.textColor=0x000000;
				paddle.width+=20;
				paddle2.width+=20;
				if (paddle.x+paddle.width>451){
					paddle.x=451-paddle.width;
					paddle2.x=456-paddle2.width;
				}
				if (laserOn){
					laser1.x=paddle.x+10;
					laser2.x=paddle.x+paddle.width-14;
				}
			}
			else if (droppedPowerUp.name=="6C2DC7"){
				powerUpMessage.text="You Shortened Your Paddle";
				powerUpMessage.textColor=0x000000;
				paddle.scaleX/=1.5;
				paddle2.scaleX/=1.5;
				if (laserOn){
					laser1.x=paddle.x+10;
					laser2.x=paddle.x+paddle.width-14;
				}
			}
			else if (droppedPowerUp.name=="8C8C8C"){
				powerUpMessage.text="You Locked the Ground";
				powerUpMessage.textColor=0x000000;
				if (ground.alpha>0){
					groundLock=true;
					if (paddle.height==10.5){
						paddle.height--;
					}
				}
				ground.graphics.lineStyle(1,0xD4A017);
				ground.graphics.beginFill(0xD4A017);
				ground.graphics.drawRect(0,0,400,2);
				ground.x=50;
				ground.y=334;
				ground.visible=true;
				addChild(ground);
				groundTimer.start();
				groundTimer.addEventListener(TimerEvent.TIMER, newGround)
			}
			else if (droppedPowerUp.name=="F88017"){
				powerUpMessage.text="You Decreased the Ball's Speed";
				powerUpMessage.textColor=0x000000;
			}
			else if (droppedPowerUp.name=="F62817"){
				powerUpMessage.text="You Increased the Ball's Speed";
				powerUpMessage.textColor=0x000000;
			}
			else if (droppedPowerUp.name=="0ACF00"){
				powerUpMessage.text="You Flipped the Keyboard Arrows";
				powerUpMessage.textColor=0x000000;
				distMove=-distMove;
			}
			else if (droppedPowerUp.name=="ED61FF"){
				powerUpMessage.text="You Initiated Multi-Ball";
				powerUpMessage.textColor=0x000000;
				for (var h:int=0; h<3; h++){
					var newBall:Sprite=new Sprite();
					newBall.graphics.lineStyle(1,0x000000);
					newBall.graphics.beginFill(0xFF0000);
					newBall.graphics.drawCircle(0,0,5);
					if (ball.x%2.5==0&&ball.x%5!=0){
						if(left){
							ball.x-=2.5;
						}
						else if(right){
							ball.x+=2.5;
						}
					}
					if (ball.y%2.5==0&&ball.y%5!=0){
						if(up){
							ball.y-=2.5;
						}
						else if(down){
							ball.y+=2.5;
						}
					}
					newBall.x=ball.x;
					newBall.y=ball.y;
					for (var g:int=0; g<brickHolder.numChildren; g++){
						var thisBrick:Sprite=brickHolder.getChildAt(g) as Sprite;
						if (thisBrick.hitTestPoint(ball.x,ball.y,false)){
							brickHolder.removeChild(thisBrick);
							var nextBrick:Sprite=brickHolder.getChildAt(g) as Sprite;
							brickHolder.removeChild(nextBrick);
						}
					}
					if (h==0){
						newBall.name="ball2";
						var ball2:TextField=new TextField;
						ball2.text="2";
						ball2.textColor=0x000000;
						ball2.height=20;
						ball2.width=200;
						ball2.x=-5;
						ball2.y=-7;
						ball2.selectable=false;
					}
					else if (h==1){
						newBall.name="ball3";
						var ball3:TextField=new TextField;
						ball3.text="3";
						ball3.textColor=0x000000;
						ball3.height=20;
						ball3.width=200;
						ball3.x=-5;
						ball3.y=-7;
						ball3.selectable=false;
					}
					else if (h==2){
						newBall.name="ball4";
						var ball4:TextField=new TextField;
						ball4.text="4";
						ball4.textColor=0x000000;
						ball4.height=20;
						ball4.width=200;
						ball4.x=-5;
						ball4.y=-7;
						ball4.selectable=false;
					}
					ballHolder.addChild(newBall);
				}
				if (right&&up){
					right2=true;
					up2=false;
					down2=true;
					left2=false;
					xdir2=2.5;
					ydir2=-2.5;
					right3=false;
					up3=true;
					down3=false;
					left3=true;
					xdir3=-2.5;
					ydir3=2.5;
					right4=false;
					up4=false;
					down4=true;
					left4=true;
					xdir4=-2.5;
					ydir4=-2.5;
				}
				else if (right&&down){
					right2=true;
					up2=true;
					down2=false;
					left2=false;
					xdir2=2.5;
					ydir2=2.5;
					right3=false;
					up3=true;
					down3=false;
					left3=true;
					xdir3=-2.5;
					ydir3=2.5;
					right4=false;
					up4=false;
					down4=true;
					left4=true;
					xdir4=-2.5;
					ydir4=-2.5;
				}
				else if (left&&up){
					right2=false;
					up2=false;
					down2=true;
					left2=true;
					xdir2=-2.5;
					ydir2=-2.5;
					right3=true;
					up3=true;
					down3=false;
					left3=false;
					xdir3=2.5;
					ydir3=2.5;
					right4=true;
					up4=false;
					down4=true;
					left4=false;
					xdir4=2.5;
					ydir4=-2.5;
				}
				else if (left&&down){
					right2=false;
					up2=true;
					down2=false;
					left2=true;
					xdir2=-2.5;
					ydir2=2.5;
					right3=true;
					up3=true;
					down3=false;
					left3=false;
					xdir3=2.5;
					ydir3=2.5;
					right4=true;
					up4=false;
					down4=true;
					left4=false;
					xdir4=2.5;
					ydir4=-2.5;
				}
			}
			else if (droppedPowerUp.name=="302ADE"){
				powerUpMessage.text="You Initiated Super-Ball";
				powerUpMessage.textColor=0x000000;
				superBallOn=true;
				superBallTimer.start();
				superBallTimer.addEventListener(TimerEvent.TIMER, newSuperBall)
			}
			else if (droppedPowerUp.name=="9000FF"){
				powerUpMessage.text="You Received a Point Bonus";
				powerUpMessage.textColor=0x000000;
				score+=50;
				updateScore();
			}
			else if (droppedPowerUp.name=="0000FF"){
				powerUpMessage.text="Press the Spacebar to Shoot";
				powerUpMessage.textColor=0x000000;
				laser1.graphics.lineStyle(1,0x000000);
				laser1.graphics.beginFill(0xD4A017);
				laser1.graphics.drawRect(0,0,4,10);
				laser1.x=paddle.x+10;
				laser1.y=318.5;
				laser1.visible=true;
				laser2.graphics.lineStyle(1,0x000000);
				laser2.graphics.beginFill(0xD4A017);
				laser2.graphics.drawRect(0,0,4,10);
				laser2.x=paddle.x+paddle.width-14;
				laser2.y=318.5;
				laser2.visible=true;
				laserOn=true;
				ammo+=10;
				updateAmmo();
			}
			powerUpMessage.height=20;
			powerUpMessage.width=200;
			powerUpMessage.x=185;
			powerUpMessage.y=170;
			powerUpMessage.visible=true;
			powerUpMessage.alpha=1;
			addChild(powerUpMessage);
			drawPowerUpMessage();
		}
		private function newSuperBall(e:TimerEvent):void{
			if (superBallTimer.currentCount>50){
				powerUpMessage.alpha=1;
				powerUpMessage.text="Super-Ball has been Terminated";
				powerUpMessage.visible=true;
				addChild(powerUpMessage);
				drawPowerUpMessage();
				superBallTimer.reset();
				superBallOn=false;
			}
		}
		private function newGround(e:TimerEvent):void{
			ground.alpha-=.0125;
			if (ground.alpha<=0){
				ground.visible=false;
				if (ground.alpha>-.009){
					paddle.height=10.5;
					powerUpMessage.alpha=1;
					powerUpMessage.text="The Ground has been Unlocked";
					powerUpMessage.visible=true;
					addChild(powerUpMessage);
					drawPowerUpMessage();
				}
				groundLock=false;
			}
		}
		private function drawPowerUpMessage():void{
			messageTimer.addEventListener(TimerEvent.TIMER, newExtraLifeMessage)
		}
		private function newExtraLifeMessage(e:TimerEvent):void{
			powerUpMessage.alpha-=.05;
			if (powerUpMessage.alpha==0){
				powerUpMessage.visible=false;
			}
		}
		private function hearKey(yourEvent:KeyboardEvent):void{
			if (stop==false){
				if (yourEvent.keyCode==Keyboard.RIGHT){
					paddle.x+=distMove;
					paddle2.x+=distMove;
					if (paddle.x+paddle.width>451){
						paddle.x=451-paddle.width;
						paddle2.x=456-paddle2.width;
					}
					else if (paddle.x<50){
						paddle.x=50;
						paddle2.x=45;
					}
					if (laserOn){
						laser1.x=paddle.x+10;
						laser2.x=paddle.x+paddle.width-14;
					}
					if (started==false){
						ball.x=Math.floor((2*paddle.x+paddle.width)/2);
					}
				};
				if (yourEvent.keyCode==Keyboard.UP){
					for (var i:int=0; i<brickHolder.numChildren; i++){
						var brickToRemove:Sprite=brickHolder.getChildAt(i) as Sprite;
						brickHolder.removeChild(brickToRemove);
						i--;
					}
				}
				if (yourEvent.keyCode==Keyboard.DOWN){
					paddle.width-=20;
					paddle2.width-=20;
				}
				if (yourEvent.keyCode==Keyboard.LEFT){
					paddle.x-=distMove;
					paddle2.x-=distMove;
					if (paddle.x<50){
						paddle.x=50;
						paddle2.x=45;
					}
					else if (paddle.x+paddle.width>451){
						paddle.x=451-paddle.width;
						paddle2.x=456-paddle2.width;
					}
					if (laserOn){
						laser1.x=paddle.x+10;
						laser2.x=paddle.x+paddle.width-14;
					}
					if (started==false){
						ball.x=Math.floor((2*paddle.x+paddle.width)/2);
					}
				}
				if (yourEvent.keyCode==32){
					if (started==false){
						xdir=xSpeed;
						ydir=ySpeed;
						stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
					}
					if (laserOn){
						mySound7.play();
						var laserShot:Sprite=new Sprite();
						laserShot.graphics.lineStyle(1,0x000000);
						laserShot.graphics.beginFill(0x02EB21);
						laserShot.graphics.drawRect(0,0,2.5,5);
						laserShot.x=paddle.x+11;
						laserShot.y=316;
						laserShotHolder.addChild(laserShot);
						var laserShot2:Sprite=new Sprite();
						laserShot2.graphics.lineStyle(1,0x000000);
						laserShot2.graphics.beginFill(0x02EB21);
						laserShot2.graphics.drawRect(0,0,2.5,5);
						laserShot2.x=paddle.x+paddle.width-13;
						laserShot2.y=316;
						laserShotHolder.addChild(laserShot2);
						ammo-=2;
						updateAmmo();
						if (ammo==0){
							laserOn=false;
							laser1.visible=false;
							laser2.visible=false;
							powerUpMessage.alpha=1;
							powerUpMessage.text="You Ran Out of Laser Ammo";
							powerUpMessage.height=20;
							powerUpMessage.width=200;
							powerUpMessage.x=185;
							powerUpMessage.y=170;
							powerUpMessage.visible=true;
							powerUpMessage.alpha=1;
							addChild(powerUpMessage);
							drawPowerUpMessage();
						}
					}
					started=true;
				};
			};
		}
		private function onEnterFrame(e:Event):void{
			if (started==true){
				for (var k:uint=0; k<ballHolder.numChildren; k++){
					var givenBall:Sprite=ballHolder.getChildAt(k) as Sprite;
					var givenDown:Boolean;
					if (givenBall.name=="ball1"){
						givenDown=down;
						givenBall.x+=xdir;
						givenBall.y-=ydir;
					}
					else if (givenBall.name=="ball2"){
						givenDown=down2;
						givenBall.x+=xdir2;
						givenBall.y-=ydir2;
					}
					else if (givenBall.name=="ball3"){
						givenDown=down3;
						givenBall.x+=xdir3;
						givenBall.y-=ydir3;
					}
					else if (givenBall.name=="ball4"){
						givenDown=down4;
						givenBall.x+=xdir4;
						givenBall.y-=ydir4;
					}
					if ((paddle2.hitTestPoint(givenBall.x,givenBall.y,false))&&(givenDown==true)&&givenBall.y==320){
						if (givenBall.name=="ball1"){
							ydir=-ydir;
							down=false;
							up=true;
						}	
						else if (givenBall.name=="ball2"){
							ydir2=-ydir2;
							down2=false;
							up2=true;
						}
						else if (givenBall.name=="ball3"){
							ydir3=-ydir3;
							down3=false;
							up3=true;
						}
						else if (givenBall.name=="ball4"){
							ydir4=-ydir4;
							down4=false;
							up4=true;
						}
					}
					if (givenBall.x<55){
						givenBall.x=55;
					}
					else if (givenBall.x>445){
						givenBall.x=445;
					}
					else if (givenBall.y<40){
						givenBall.y=40;
					}
					else if (givenBall.y>330){
						givenBall.y=330;
					}
					if ((givenBall.x==55)||(givenBall.x==445)){
						if (givenBall.name=="ball1"){
							xdir=-xdir;
							if (left){
								left=false;
								right=true;
							}
							else if (right){
								right=false;
								left=true;
							}
						}
						else if (givenBall.name=="ball2"){
							xdir2=-xdir2;
							if (left2){
								left2=false;
								right2=true;
							}
							else if (right2){
								right2=false;
								left2=true;
							}
						}
						else if (givenBall.name=="ball3"){
							xdir3=-xdir3;
							if (left3){
								left3=false;
								right3=true;
							}
							else if (right3){
								right3=false;
								left3=true;
							}
						}
						else if (givenBall.name=="ball4"){
							xdir4=-xdir4;
							if (left4){
								left4=false;
								right4=true;
							}
							else if (right4){
								right4=false;
								left4=true;
							}
						}
					}
					else if (givenBall.y==40){
						if (givenBall.name=="ball1"){
							ydir=-ydir;
							up=false;
							down=true;
						}
						else if (givenBall.name=="ball2"){
							ydir2=-ydir2;
							up2=false;
							down2=true;
						}
						else if (givenBall.name=="ball3"){
							ydir3=-ydir3;
							up3=false;
							down3=true;
						}
						else if (givenBall.name=="ball4"){
							ydir4=-ydir4;
							up4=false;
							down4=true;
						}
					}
					else if (givenBall.y==330){
						if (groundLock){
							if (givenBall.name=="ball1"){
								ydir=-ydir;
								down=false;
								up=true;
							}
							else if (givenBall.name=="ball2"){
								ydir2=-ydir2;
								down2=false;
								up2=true;
							}
							else if (givenBall.name=="ball3"){
								ydir3=-ydir3;
								down3=false;
								up3=true;
							}
							else if (givenBall.name=="ball4"){
								ydir4=-ydir4;
								down4=false;
								up4=true;
							}
							
						}
						else{
							if (ballHolder.numChildren==1){
								ballHolder.removeChild(givenBall);
								loseLife();
							}
							else{
								ballHolder.removeChild(givenBall);
								if (ballHolder.numChildren==1){
									if (ballHolder.getChildAt(0).name=="ball2"){
										ball.x=ballHolder.getChildAt(0).x;
										ball.y=ballHolder.getChildAt(0).y;
										xdir=xdir2;
										ydir=ydir2;
										right=right2;
										left=left2;
										down=down2;
										up=up2;
										ballHolder.removeChild(ballHolder.getChildAt(0));
										ballHolder.addChild(ball);
									}
									else if (ballHolder.getChildAt(0).name=="ball3"){
										ball.x=ballHolder.getChildAt(0).x;
										ball.y=ballHolder.getChildAt(0).y;
										xdir=xdir3;
										ydir=ydir3;
										right=right3;
										left=left3;
										down=down3;
										up=up3;
										ballHolder.removeChild(ballHolder.getChildAt(0));
										ballHolder.addChild(ball);
									}
									else if (ballHolder.getChildAt(0).name=="ball4"){
										ball.x=ballHolder.getChildAt(0).x;
										ball.y=ballHolder.getChildAt(0).y;
										xdir=xdir4;
										ydir=ydir4;
										right=right4;
										left=left4;
										down=down4;
										up=up4;
										ballHolder.removeChild(ballHolder.getChildAt(0));
										ballHolder.addChild(ball);
									}
								}
							}
						}
					}
					for (var i:uint=0; i<brickHolder.numChildren; i++){
						var brick:Sprite=brickHolder.getChildAt(i) as Sprite;
						if (temp==true){
							brickHolder.removeChild(brick);
							temp=false;
						}
						else{
							if (brick.hitTestPoint(givenBall.x,givenBall.y,false)){
								if (brick.name!="616161"){
									hit=true;
									dropX=(2*brick.x+30)/2;
									dropY=brick.y+25;
									brickHolder.removeChild(brick);
									mySound.play();
									score+=5;
									updateScore()
									i--;
									powerUp();
									temp=true;
								}
								if (!superBallOn||brick.name=="616161"){
									if (givenBall.name=="ball1"){
										if (((givenBall.x-45)%40==0)&&(right==true)){
											xdir=-xdir;
											right=false;
											left=true;
										}
										else if (((givenBall.x-55)%40==0)&&(left==true)){
											xdir=-xdir;
											left=false;
											right=true;
										}
										else if (((givenBall.y-30)%20==10)&&(up==true)){
											ydir=-ydir;
											up=false;
											down=true;
										}
										else if (((givenBall.y-40)%20==10)&&(down==true)){
											ydir=-ydir;
											down=false;
											up=true;
										}
									}
									else if (givenBall.name=="ball2"){
										if (((givenBall.x-45)%40==0)&&(right2==true)){
											xdir2=-xdir2;
											right2=false;
											left2=true;
										}
										else if (((givenBall.x-55)%40==0)&&(left2==true)){
											xdir2=-xdir2;
											left2=false;
											right2=true;
										}
										else if (((givenBall.y-30)%20==10)&&(up2==true)){
											ydir2=-ydir2;
											up2=false;
											down2=true;
										}
										else if (((givenBall.y-40)%20==10)&&(down2==true)){
											ydir2=-ydir2;
											down2=false;
											up2=true;
										}
									}
									else if (givenBall.name=="ball3"){
										if (((givenBall.x-45)%40==0)&&(right3==true)){
											xdir3=-xdir3;
											right3=false;
											left3=true;
										}
										else if (((givenBall.x-55)%40==0)&&(left3==true)){
											xdir3=-xdir3;
											left3=false;
											right3=true;
										}
										else if (((givenBall.y-30)%20==10)&&(up3==true)){
											ydir3=-ydir3;
											up3=false;
											down3=true;
										}
										else if (((givenBall.y-40)%20==10)&&(down3==true)){
											ydir3=-ydir3;
											down3=false;
											up3=true;
										}
									}
									else if (givenBall.name=="ball4"){
										if (((givenBall.x-45)%40==0)&&(right4==true)){
											xdir4=-xdir4;
											right4=false;
											left4=true;
										}
										else if (((givenBall.x-55)%40==0)&&(left4==true)){
											xdir4=-xdir4;
											left4=false;
											right4=true;
										}
										else if (((givenBall.y-30)%20==10)&&(up4==true)){
											ydir4=-ydir4;
											up4=false;
											down4=true;
										}
										else if (((givenBall.y-40)%20==10)&&(down4==true)){
											ydir4=-ydir4;
											down4=false;
											up4=true;
										}
									}
								}
							}
						}
					}
				}
				var brickRemains:Boolean=false;
				for (var b:uint=0; b<brickHolder.numChildren; b++){
					var checkBrick:Sprite=brickHolder.getChildAt(b) as Sprite;
					if (checkBrick.name!="616161"){
						brickRemains=true;
					}
				}
				if (brickHolder.numChildren==0||!brickRemains){
					if (level<20){
						nextLevel();
					}
					else{
						if (!stop){
							nextLevel();
							gameOver();
							channel.stop();
							channel2=mySound6.play();
							level--;
							updateLevel();
						}
					}
				}
				for (i=0; i<powerUpHolder.numChildren; i++){
					var droppedPowerUp:Sprite=powerUpHolder.getChildAt(i) as Sprite;
					droppedPowerUp.y++;
					if (paddle2.hitTestPoint(droppedPowerUp.x,droppedPowerUp.y+2.5,false)||paddle2.hitTestPoint(droppedPowerUp.x+20,droppedPowerUp.y+2.5,false)){
						if (droppedPowerUp.name=="8C8C8C"){
							ground.alpha=1;
						}
						else if (droppedPowerUp.name=="F88017"){
							stage.frameRate/=(4/3);
						}
						else if (droppedPowerUp.name=="F62817"){
							stage.frameRate*=(4/3);
						}
						powerUpPlayer(droppedPowerUp);
						powerUpHolder.removeChild(droppedPowerUp);
						mySound2.play();
					}
					else if (droppedPowerUp.y>327.5){
						powerUpHolder.removeChild(droppedPowerUp);
					}
				}
				for (i=0; i<laserShotHolder.numChildren; i++){
					var shotlaserShot:Sprite=laserShotHolder.getChildAt(i) as Sprite;
					shotlaserShot.y-=2;
					if (shotlaserShot.y<35){
						laserShotHolder.removeChild(shotlaserShot);
					}
					for (var r:uint=0; r<brickHolder.numChildren; r++){
						var hitBrick:Sprite=brickHolder.getChildAt(r) as Sprite;
						if (temp2==true){
							brickHolder.removeChild(hitBrick);
							temp2=false;
						}
						else{
							if (hitBrick.hitTestPoint(shotlaserShot.x,shotlaserShot.y+5,false)){
								hit=true;
								dropX=(2*hitBrick.x+30)/2;
								dropY=hitBrick.y+25;
								brickHolder.removeChild(hitBrick);
								laserShotHolder.removeChild(shotlaserShot);
								mySound.play();
								score+=5;
								updateScore()
								r--;
								powerUp();
								temp2=true;
							}
						}
					}
				}
			}
		}
	}
}