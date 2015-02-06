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
import flixel.system.FlxSound;

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
	private var _enemies:FlxSpriteGroup;
	private var _explosion:FlxEmitterExt;
	private var _timer:haxe.Timer;

	//Camera Variables
	private var cameraOffset_x:Int = 100;
	private var cameraOffset_y:Int = 350;

	//HUD Variables
	private var _hud:HUD;

	//Sound Variables
	private var _sndDie:FlxSound;
	private var _sndKill:FlxSound;

	private var _timeStart:Float;
	private var _currentTime:Float;
	private var _bpm = 141; //bpm of music track

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{

		/** 
		* create timer
		*/

		_timeStart = FlxG.elapsed * 1000;
		_currentTime = FlxG.elapsed * 1000;

		/** 
		* create player
		*/

		_player = new Player(FlxG.width/2, 400);
		add(_player);

		/** 
		* create ground pool
		*/

		var ground_poolSize = 50;
		_groundWidth = 0;
		_ground = new FlxSpriteGroup(0,0,ground_poolSize);

		for(i in 0...ground_poolSize){
			var ground = new Ground();
			_ground.add(ground);
		}

		while(_groundWidth < FlxG.width + 200){
			createGround();
		}

		add(_ground);

		/** 
		* create enemy pool
		*/
		
		var enemy_poolSize = 10;
		_enemies = new FlxSpriteGroup(0,0,enemy_poolSize);

		for(i in 0...enemy_poolSize){
			var enemy = new Enemy();
			_enemies.add(enemy);
		}

		add(_enemies);

		/** 
		* create particles
		*/

		_explosion = new FlxEmitterExt();
		_explosion.setRotation(0,0);
		_explosion.setXSpeed(300,500);
		_explosion.setYSpeed(300,500);
		_explosion.setMotion(45, 350, 0.4, 360, 450, 1.2);
		_explosion.makeParticles("assets/images/particle.png", 100, 0, false, 0);
		_explosion.setAlpha(1,1,0,0);

		add(_explosion);

		/** 
		* create HUD
		*/

		Reg.score = 0;
		_hud = new HUD();
		add(_hud);

		/** 
		* create sound/music
		*/

		FlxG.sound.playMusic(AssetPaths.atownsyear__wav, 1, true);
		_sndDie = FlxG.sound.load(AssetPaths.die__wav);
		_sndKill = FlxG.sound.load(AssetPaths.kill__wav);
		
		//(still havent found out that value type tho)
		FlxG.camera.bgColor = 0xff131c1b;
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
		_enemies.destroy();
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
		FlxG.overlap(_player, _enemies, playerTouchObstacle);
		FlxG.overlap(_player.sword, _enemies, playerAttackObstacle);

		//Bounds Update
		FlxG.worldBounds.set((_player.x - FlxG.width/2) + 16, 0, (_player.x + FlxG.width/2), FlxG.height);

		//Ground Update
		if(_groundWidth < FlxG.width + FlxG.camera.scroll.x){
			createGround();
		}

		//Obstacles Update
		_currentTime += FlxG.elapsed * 1000;

		if(_alive && _currentTime - _timeStart >= 60000/_bpm){
			createObstacle();
			_timeStart += 60000/_bpm;
		}

		callEnemy();

		//PlayState Update
		//If Dead, Press R to Restart
		if(!_alive){
			if(FlxG.keys.justPressed.R){
				FlxG.switchState(new PlayState());
			}
		}

		//HUD Update
		_hud.updateHUD(Reg.score, _alive);
		
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
		var obstacle = _enemies.recycle(Enemy);
		obstacle.x = _groundWidth + 20;
		obstacle.y = FlxG.height - 32;
	}

	private function playerTouchObstacle(P:Player, E:Enemy):Void
	{
		explode(P.x, P.y);
		_sndDie.play();
		P.kill();
		_alive = false;
	}

	private function playerAttackObstacle(S:FlxSprite, E:Enemy):Void{
		trace("kill");
		explode(E.x, E.y);
		_sndKill.play();
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