
package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	private var _txtScore:FlxText;
	private var _gameOver:FlxText;

	public function new()
	{
		super();
		_txtScore = new FlxText(10, 10, 0, "0", 16);
		_txtScore.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1,1);
		_txtScore.scrollFactor.set();

		_gameOver = new FlxText(0, 30, FlxG.width);
		_gameOver.setFormat(null, 36, FlxColor.WHITE, "center");
		_gameOver.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1,1);
		_gameOver.visible = false;
		_gameOver.scrollFactor.set(0,0);

		add(_txtScore);
		add(_gameOver);
	}
	
	public function updateHUD(Score:Int = 0, alive:Bool):Void
	{
		_txtScore.text = Std.string(Score);
		if(!alive){
			_gameOver.text = "You are dead! Your final score is " + Std.string(Score) +".\n Press 'R' to restart.";
			_gameOver.visible = true;
			_txtScore.visible = false;
		}	
	}

}