package src;

import haxe.Timer;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.effects.particles.FlxEmitter;
import flixel.util.helpers.FlxRangeBounds;
import flixel.system.FlxSound;

import src.entity.Player;
import src.entity.Enemy;
import src.env.Ground;
import src.ui.HUD;
import src.Reg;

class PlayState extends FlxState
{
	private var _player:Player;
	private var _alive:Bool = true;

	private var _ground:FlxSpriteGroup;
	private var _groundWidth:Float;

	private var _enemies:FlxSpriteGroup;
	private var _explosion:FlxEmitter;
	private var _timer:Timer;

	private var _cameraOffsetX:Int = 100;
	private var _cameraOffsetY:Int = 350;

	private var _hud:HUD;

	private var _sndDie:FlxSound;
	private var _sndKill:FlxSound;

	private var _timeStart:Float;
	private var _currentTime:Float;
	private var _bpm = 141;

	override public function create():Void
	{
		this._timeStart = FlxG.elapsed * 1000;
		this._currentTime = FlxG.elapsed * 1000;

		this._player = new Player(FlxG.width / 2, 400);
		this.add(this._player);

		/** 
		* Create Ground Pool
		**/
		var groundPoolSize:Int = 50;
		this._groundWidth = 0.0;
		this._ground = new FlxSpriteGroup(0.0, 0.0, groundPoolSize);

		for (i in 0...groundPoolSize) {
			this._ground.add(new Ground());
		}

		while (this._groundWidth < FlxG.width + 200) {
			this._createGround();
		}

		this.add(this._ground);

		/**
		* Create Enemy Pool
		**/
		var enemyPoolSize = 10;
		this._enemies = new FlxSpriteGroup(0.0, 0.0, enemyPoolSize);

		for (i in 0...enemyPoolSize) {
			this._enemies.add(new Enemy());
		}

		this.add(this._enemies);

		/**
		* Create Particles
		**/
		this._explosion = new FlxEmitter();
		this._explosion.loadParticles(AssetPaths.particle__png, 100, 2, false, false);
		this._explosion.launchMode = FlxEmitterMode.CIRCLE;
		// this._explosion.alpha = new FlxRangeBounds(1.0, 1.0, 0.0, 0.0);

		this.add(this._explosion);

		/**
		* Create HUD
		**/
		Reg.score = 0;
		this._hud = new HUD();
		this.add(this._hud);

		/**
		* Create Sound/Music
		**/

		FlxG.sound.playMusic(AssetPaths.atownsyear__ogg, 1, true);
		this._sndDie = FlxG.sound.load(AssetPaths.die__ogg);
		this._sndKill = FlxG.sound.load(AssetPaths.kill__ogg);

		FlxG.camera.bgColor = 0xff131c1b;
		FlxG.mouse.visible = false;
		FlxG.worldBounds.set((this._player.x - FlxG.width / 2) + 16, 0, (this._player.x + FlxG.width / 2), FlxG.height);

		super.create();
	}

	override public function destroy():Void
	{
		this._player.destroy();
		this._ground.destroy();
		this._enemies.destroy();
		this._explosion.destroy();
		this._hud.destroy();
		super.destroy();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		//Camera Movement
		FlxG.camera.scroll.x = this._player.x - this._cameraOffsetX;
		FlxG.camera.scroll.y = this._player.y - this._cameraOffsetY;

		//Collisions
		FlxG.collide(this._player, this._ground);
		FlxG.overlap(this._player, this._enemies, this._playerTouchObstacle);
		FlxG.overlap(this._player.sword, this._enemies, this._playerAttackObstacle);
		this._explosion.update(elapsed);

		//Bounds Update
		FlxG.worldBounds.set((this._player.x - FlxG.width / 2) + 16, 0, (this._player.x + FlxG.width / 2), FlxG.height);

		//Ground Update
		if (this._groundWidth < FlxG.width + FlxG.camera.scroll.x) {
			this._createGround();
		}

		//Obstacles/Enemy Update
		this._currentTime += FlxG.elapsed * 1000;
		if (this._alive && this._currentTime - this._timeStart >= 60000/this._bpm) {
			this._createObstacle();
			this._timeStart += 60000 / this._bpm;
		}

		//PlayState Update
		//If Dead, R to Restart
		if (!this._alive) {
			if (FlxG.keys.justPressed.R) {
				FlxG.switchState(new PlayState());
			}
		}

		//HUD Update
		this._hud.updateHUD(Reg.score, this._alive);
	}

	private function _createGround():Void
	{
		var ground = this._ground.recycle(Ground);
		ground.x = this._groundWidth;
		ground.y = FlxG.height - 16;

		this._groundWidth += ground.width;
	}

	private function _createObstacle():Void
	{
		var obstacle = this._enemies.recycle(Enemy);
		obstacle.x = this._groundWidth + 20;
		obstacle.y = FlxG.height - 32;
	}

	private function _playerTouchObstacle(p:Player, e:Enemy):Void
	{
		this._explode(p.x, p.y);
		this._sndDie.play();
		p.kill();
		this._alive = false;
	}

	private function _playerAttackObstacle(s:FlxSprite, e:Enemy):Void
	{
		trace('playerattack obstacle');
		this._explode(e.x, e.y);
		this._sndKill.play();
		e.kill();
		Reg.score += 1;
	}

	private function _explode(xco:Float = 0, yco:Float = 0):Void
	{
		if (this._explosion.visible) {
			this._explosion.x = xco;
			this._explosion.y = yco;
			this._explosion.start(true, 2, 250);
		}
	}

	private function _callEnemy():Void
	{
		if (FlxG.keys.anyPressed(['E'])) {
			this._createObstacle();
		}
	}
}
