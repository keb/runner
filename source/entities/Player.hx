
package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;

class Player extends FlxSprite
{
	//making float variable for speed
	public var speed:Float = 600;
	public var gravity:Int = 800;
	public var jumpSpeed:Int = 300;
	public var sword:FlxSprite;

	private var _jumpDuration:Float = -1;
	private var _attackDuration:Float = 0;

	public function new(X:Float=0, Y:Float=0){
		//super calls parent class (FlxSprite)
		super(X, Y);
		makeGraphic(16,16, FlxColor.WHITE);

		//Drag in HaxeFlixel slows down object when not moving
		drag.set(speed * 5, speed * 5);
		maxVelocity.set(speed,jumpSpeed);
		
		//Set gravity
		acceleration.x = 0;
		acceleration.y = gravity;

		//Create Sword Sprite
		sword = new FlxSprite();
		sword.loadGraphic(AssetPaths.slash__png, false, 8, 22);
		sword.scale.set(2,2);
		sword.visible = false;
		FlxG.state.add(sword);
	}

	// public function sword(X:Float=0, Y:Float=0){
	// 	makeGraphic(16,2, FlxColor.White);
	// }

	//Field update should be declared with 'override' since it is inherited from superclass
	override public function update():Void
	{
		//Player Controls
		updateMovement();
		jump();
		attack();

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

	private function attack():Void{
		var _attack:Bool = false;
		sword.visible = false;

		//Controls
		_attack = FlxG.keys.anyPressed(["C"]);

		if(_attack && _attackDuration < .20){
			sword.x = x + 28;
			sword.y = y;
			sword.visible = true;
		}

		if(_attack){
			_attackDuration+= FlxG.elapsed;
		}

		else{
			_attackDuration = 0;
		}

	}

}