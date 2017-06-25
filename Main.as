package{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.*;
	import flash.events.Event; //used for ENTER_FRAME event
	
	public class Main extends MovieClip{
		
		//variables
		var paddle;
		var ball;
		var paddleSpeed:Number;
		var ballXSpeed:Number;
		var ballYSpeed:Number;
		var ballOnPaddle:Boolean;
		var gameWon:Boolean;
		var score:Number;
		var life:Number;
		
		//Arrays
		var bricks:Array = new Array;
		
		
		public function Main(){
			init();
		}
		
		function init():void {
			
			//initialize variables
			paddleSpeed = 0;
			ballXSpeed = 10;
			ballYSpeed = 10;
			ballOnPaddle = true;
			gameWon = false;
			life = 3;
			
			//create the bricks
			var k=0;
			for(var i = 0; i<4; ++i){
				for(var j=0; j<15;++j){
					var tmpBrick = new Brick();
					tmpBrick.x = 20 + j*36;
					tmpBrick.y = 20+i*52;
					addChild(tmpBrick);
					bricks[k++] = tmpBrick; 
				}
			}
			
			//create the paddle
			paddle = new Paddle();
			paddle.x = stage.stageWidth/2;
			paddle.y = 375;
			addChild(paddle);
			
			
			//create the ball
			ball = new Ball();
			ball.x = paddle.x;
			ball.y = paddle.y - (paddle.height/2 + ball.height/2);
			addChild(ball);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
			addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			
		}
		
		function keyDownHandler(event:KeyboardEvent){
			if(event.keyCode == Keyboard.LEFT){
				paddleSpeed = -10;
            }
			if(event.keyCode == Keyboard.RIGHT){
				paddleSpeed = 10;
            }
			
			if(event.keyCode == Keyboard.SPACE){
				ballOnPaddle = false;
			}
		}
		
		function keyUpHandler(event:KeyboardEvent){
			if(event.keyCode == Keyboard.LEFT){
				paddleSpeed = 0;
            }
			if(event.keyCode == Keyboard.RIGHT){
				paddleSpeed = 0;
            }
		}
		
		function enterFrameHandler(event:Event){
			
			//move paddle
			paddle.x += paddleSpeed;
			
			//collision between paddle and the stage
			if(paddle.x - paddle.width/2 < 0 ){
				paddle.x = paddle.width/2;
			}else if(paddle.x + paddle.width/2 > stage.stageWidth ){
				paddle.x = stage.stageWidth - paddle.width/2;
			}
			
			//check if ball is on the paddle
			if(ballOnPaddle == true){
				ball.x = paddle.x;
				ball.y = paddle.y - (paddle.height/2 + ball.height/2);
			}else{
				//if not update the ball
				ball.x += ballXSpeed;
				ball.y -= ballYSpeed;
				
				//check for collision between ball and stage
				if(ball.x + ball.width/2 > stage.stageWidth || ball.x - ball.width/2 < 0){
					ballXSpeed *= -1;
				}
				if(ball.y - ball.height/2 < 0){
					ballYSpeed *= -1;
				}
				
				//if ball goes down the stage don't check for collision just reduce life bring it onto paddle
				if(ball.y > stage.stageHeight){
					ballOnPaddle = true;
					life = life-1;
					
					//If life becomes 0 then game over
					if(life <= 0){
						stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
						stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
						removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
						removeChild(ball);
						removeChild(paddle);
						
						statusTxt.text = "You Lost!"
					}
				}
				
				//check for collision between ball and paddle
				if(paddle.hitTestPoint(ball.x,ball.y,true)){
					
					var diff = 0;
					if (ball.x < paddle.x){     //If the ball is on the right side of the paddle
						diff = paddle.x - ball.x;
						ballXSpeed = (-0.4 * diff);     
					}else if (ball.x > paddle.x){   //If ball is on right side of the paddle
						diff = ball.x - paddle.x;
						ballXSpeed= (0.4 * diff);
					}
					
					ballYSpeed *= -1;
				}
				
				//check for collision between ball and paddle
				gameWon = true;
				for (var i=0; i<bricks.length; ++i){
					if(bricks[i] != null){
						gameWon = false;
						if(bricks[i].hitTestObject(ball)){
							ballYSpeed *= -1;
							removeChild(bricks[i]);
							bricks[i] = null;
						}
					}
				}
				
				//If all the bricks were null then the game was won
				if(gameWon == true){
					stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
					stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler);
					removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
					removeChild(ball);
					removeChild(paddle);
					
					
					statusTxt.text = "You won!"
				}
				
			}
		}
		
	}
}