package;

import flixel.FlxGame;
import openfl.display.Sprite;
import src.PlayState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(640, 480, PlayState, 0.5, 60, 60, true, false));
	}
}
