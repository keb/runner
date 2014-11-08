package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.group.FlxGroup;
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
	private var _player:Player;
	private var _walls:FlxGroup;
	private var _ground:FlxSprite;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//20,400 is starting position
		_player = new Player(FlxG.width/2,400);
		//Scale x2 and update Hitbox
		// _player.scale.set(3,3);
		// _player.updateHitbox();

		//bg color (still havent found out that value type tho)
		FlxG.camera.bgColor = 0xff131c1b;

		_walls = new FlxGroup();
		_ground = new FlxSprite(0,FlxG.height - 16);

		//Create Ground Sprites and add to _walls group
		_ground.makeGraphic(FlxG.width, 16, FlxColor.WHITE);
		_ground.immovable = true;
		_walls.add(_ground);


		add(_player);
		add(_walls);

		
		//FlxG.camera.setBounds((_player.x - FlxG.width/2), 0, (_player.x + FlxG.width/2), FlxG.height, true);
		FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER, 1);
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
		trace(_player.y);
		trace(_player.x);

		// trace(_ground.y);
		// trace(_ground.x);

		trace(FlxG.worldBounds);
		trace(FlxG.worldBounds.width);
		trace(FlxG.worldBounds.x);

		//Collisions
		FlxG.collide(_player, _walls);

		//Bounds Update
		FlxG.worldBounds.set((_player.x - FlxG.width/2) + 16, 0, (_player.x + FlxG.width/2), FlxG.height);

		//Ground Update
		_ground.makeGraphic(Std.int(FlxG.worldBounds.width) + 1, 16, FlxColor.WHITE);
		
	}	
}