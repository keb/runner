package;

import flixel.FlxG;
import flixel.FlxObject;
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
import flixel.effects.particles.FlxEmitterExt;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	//Player Variables
	private var _player:Player;
	private var _alive:Bool = true;

	//Ground Variables
	private var _ground:FlxSpriteGroup;
	private var _groundWidth:Float;

	//Obstacle/Enemy Variables
	private var _obstacles:FlxSpriteGroup;
	private var _explosion:FlxEmitterExt;
	private var _timer:haxe.Timer;

	//Camera Variables
	private var cameraOffset_x:Int = 100;
	private var cameraOffset_y:Int = 350;

	//HUD Variables
	private var _hud:HUD;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{

		_timer = new haxe.Timer(1000);

		/******* PLAYER ATTRIBUTES *******/
		//starting position
		_player = new Player(FlxG.width/2, 400);

		//Scale x2 and update Hitbox for scale resize
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
			// trace(FlxG.width);
			createGround();
		}

		/******* CREATE OBSTACLE POOL *******/
		var obst_poolSize = 10;
		_obstacles = new FlxSpriteGroup(0,0,obst_poolSize);

		for(i in 0...obst_poolSize){
			var obstacle = new Enemy();
			_obstacles.add(obstacle);
		}

		/******* CREATE PARTICLE EMITTERS *******/

		//setMotion(Angle:Float, Distance:Float, Lifespan:Float, ?AngleRange:Float = 0, ?DistanceRange:Float = 0, ?LifespanRange:Float = 0):Void

		_explosion = new FlxEmitterExt();

		_explosion.setRotation(0,0);
		_explosion.setXSpeed(300,500);
		_explosion.setYSpeed(300,500);
		_explosion.setMotion(45, 350, 0.4, 360, 450, 1.2);
		_explosion.makeParticles("assets/images/particle.png", 100, 0, false, 0);
		_explosion.setAlpha(1,1,0,0);

		/******* CREATE HUD *******/
		Reg.score = 0;
		_hud = new HUD();

		/******* ADD ALL OBJECTS *******/
		add(_player);
		add(_ground);
		add(_obstacles);
		add(_explosion);
		add(_hud);
		
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
		_player.destroy();
		_ground.destroy();
		_obstacles.destroy();
		_explosion.destroy();
		_hud.destroy();
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		//Trace Tests
		// trace(_player.y);
		// trace(_player.x);
		// trace(_ground);
		// trace(_groundWidth);
		// trace(FlxG.worldBounds);
		// trace(FlxG.worldBounds.width);
		// trace(FlxG.worldBounds.x);

		//Camera Movement
		FlxG.camera.scroll.x = _player.x - cameraOffset_x;
		FlxG.camera.scroll.y = _player.y - cameraOffset_y;

		//Collisions
		FlxG.collide(_player, _ground);
		FlxG.overlap(_player, _obstacles, playerTouchObstacle);
		FlxG.overlap(_player.sword, _obstacles, playerAttackObstacle);

		//Bounds Update
		FlxG.worldBounds.set((_player.x - FlxG.width/2) + 16, 0, (_player.x + FlxG.width/2), FlxG.height);

		//Ground Update
		if(_groundWidth < FlxG.width + FlxG.camera.scroll.x){
			createGround();
		}

		//Obstacles Update
		_timer.run = function():Void{
			createObstacle();
		};

		callEnemy(); //used for testing; spawn enemy at will

		//PlayState Update
		//If Dead, Press R to Restart
		if(!_alive){
			if(FlxG.keys.justPressed.R){
				FlxG.switchState(new PlayState());
			}
		}

		//HUD Update
		_hud.updateHUD(Reg.score);
		
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
		trace("created");
		var obstacle = _obstacles.recycle(Enemy);
		obstacle.x = _groundWidth + 20;
		obstacle.y = FlxG.height - 32;
	}

	private function playerTouchObstacle(P:Player, E:Enemy):Void
	{
		explode(P.x, P.y);
		P.kill();
		_alive = false;
		_timer.stop();
	}

	private function playerAttackObstacle(S:FlxSprite, E:Enemy):Void{
		trace("kill");
		explode(E.x, E.y);
		E.kill();
		Reg.score++;
	}

	private function explode(X:Float = 0, Y:Float = 0):Void
	{
		if(_explosion.visible){
			_explosion.x = X;
			_explosion.y = Y;
			_explosion.start(true, 2, 0, 400);
			_explosion.update();
		}
	}

	private function callEnemy():Void
	{
		if(FlxG.keys.anyJustPressed(["E"])){
			trace("spawn enemy");
			createObstacle();
		}
	}
}