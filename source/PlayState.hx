package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	//Player Variables
	private var _player:Player;

	//Ground Variables
	private var _ground:FlxSpriteGroup;
	private var _groundWidth:Float;

	//Obstacle/Enemy Variables
	private var _obstacles:FlxSpriteGroup;

	//Camera Variables
	private var cameraOffset_x:Int = 100;
	private var cameraOffset_y:Int = 350;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{

		/******* PLAYER ATTRIBUTES *******/
		//starting position
		_player = new Player(FlxG.width/2, 400);

		//Scale x2 and update Hitbox
		// _player.scale.set(3,3);
		// _player.updateHitbox();


		/******* CREATE GROUND *******/
		//Intialize starting groundWidth for ground creation
		_groundWidth = 0;

		var ground_poolSize = 50;
		_ground = new FlxSpriteGroup(0,0,ground_poolSize);

		for(i in 0...ground_poolSize){
			var ground = new Ground();
			//ground.kill();
			_ground.add(ground);
		}

		while(_groundWidth < FlxG.width + 200){
			trace(FlxG.width);
			createGround();
		}

		/******* CREATE OBSTACLES *******/
		var obst_poolSize = 10;
		_obstacles = new FlxSpriteGroup(0,0,obst_poolSize);

		for(i in 0...obst_poolSize){
			var obstacle = new Ground();
			_obstacles.add(obstacle);
		}




		/******* ADD ALL OBJECTS *******/
		add(_player);
		add(_ground);
		add(_obstacles);
		
		//bg color (still havent found out that value type tho)
		FlxG.camera.bgColor = 0xff131c1b;

		// FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER, 1);
		FlxG.worldBounds.set((_player.x - FlxG.width/2) + 16, 0, (_player.x + FlxG.width/2), FlxG.height);
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		//Trace Tests
		trace(_player.y);
		trace(_player.x);
		trace(_ground);
		trace(_groundWidth);
		trace(FlxG.worldBounds);
		trace(FlxG.worldBounds.width);
		trace(FlxG.worldBounds.x);

		//Camera Movement
		FlxG.camera.scroll.x = _player.x - cameraOffset_x;
		FlxG.camera.scroll.y = _player.y - cameraOffset_y;

		//Collisions
		FlxG.collide(_player, _ground);
		FlxG.collide(_player, _obstacles);

		//Bounds Update
		FlxG.worldBounds.set((_player.x - FlxG.width/2) + 16, 0, (_player.x + FlxG.width/2), FlxG.height);

		//Ground Update
		if(_groundWidth < FlxG.width + FlxG.camera.scroll.x){
			createGround();
		}

		//Obstacles Update
		if(_groundWidth % 600 == 0){
			createObstacle();
		}
		
	}	

	private function createGround():Void
	{
		var ground = _ground.recycle(Ground);
		ground.x = _groundWidth;
		ground.y = FlxG.height - 16;

		_groundWidth += ground.width;
	}

	private function createObstacle():Void
	{
		var obstacle = _obstacles.recycle(Ground);
		obstacle.x = _groundWidth + 20;
		obstacle.y = FlxG.height - 32;
	}
}