
package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;

class Player extends FlxSprite
{
	//making float variable for speed
	public var speed:Float = 200;
	public var gravity:Int = 800;
	public var jumpSpeed:Int = 300;

	private var _jumpDuration:Float = -1;

	public function new(X:Float=0, Y:Float=0){
		//super calls parent class (FlxSprite)
		super(X, Y);
		makeGraphic(16,16, FlxColor.WHITE);

		
		/* FOR USE WITH SPRITE */
			//tells sprite user player.png, that animated=true, each frame is 16x16
		// loadGraphic(AssetPaths.player__png, true, 16, 16);

			//don't flip when facing Left (because sprite already faces left)
			//DO flip horizontally when facing Right
		// setFacingFlip(FlxObject.LEFT, false, false);
		// setFacingFlip(FlxObject.RIGHT, true, false);

			//Define Animations
		// animation.add("LR", [3,4,3,5], 6, false);


		//Drag in HaxeFlixel slows down object when not moving
		drag.set(speed * 8, speed * 8);
		maxVelocity.set(speed,jumpSpeed);
		//Set gravity
		acceleration.y = gravity;
	}

	//Field update should be declared with 'override' since it is inherited from superclass
	override public function update():Void
	{
		updateMovement();
		jump();
		super.update();
	}	
	
	private function updateMovement():Void{
		var _right:Bool = false;
		var _left:Bool = false;

		//Controls
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);

		//If not pressing, acceleration = 0
		acceleration.x = 0;
		if(_right){
			acceleration.x = drag.x;
			//facing = FlxObject.RIGHT;
		}
		else if(_left){
			acceleration.x = -drag.x; 
			//facing = FlxObject.LEFT;
		}

		//Cancel opposite directions
		if(_left && _right)
			_left = _right = false;

		//Prevent falling off map (NOT NEEDED IN ENDLESS RUNNER duh)
		// if(this.x <= 0)
		// 	this.x = 0;
		// if((this.x + this.width) > FlxG.width)
		// 	this.x = FlxG.width - this.width;

			/* FOR USE WITH SPRITE */
		// if((velocity.x != 0 || velocity.y != 0)){
		// 	switch(facing){
		// 		case FlxObject.LEFT, FlxObject.RIGHT:
		// 			animation.play("LR");
		// 	}
		// }
	}

	private function jump():Void{	//clean this shit up
		var _jump:Bool = false;

		//Controls
		_jump = FlxG.keys.anyPressed(["UP"]);

		if(_jump && isTouching(FlxObject.FLOOR)){
			//FlxObject.FLOOR: Special-case constant meaning down, used mainly by allowCollisions and touching.
			_jumpDuration = 0; //just started jumping

		}

		if(_jumpDuration >= 0 && _jumpDuration < 0.30){
			_jumpDuration += FlxG.elapsed;
		}

		if(_jump && _jumpDuration >= 0){
			this.velocity.y =  -0.6 * maxVelocity.y;
			if(_jumpDuration > 0.30){
				_jumpDuration = -1;
			}
		}

		if(FlxG.keys.anyJustReleased(["UP"])){
			_jumpDuration = -1;
		}

		//test purposes
		// trace(isTouching(FlxObject.FLOOR));
		// trace(FlxG.elapsed);

	}

}