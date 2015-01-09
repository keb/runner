
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

	public function new()
	{
		super();
		_txtScore = new FlxText(10, 10, 0, "0", 16);
		_txtScore.setBorderStyle(FlxText.BORDER_SHADOW, FlxColor.GRAY, 1,1);

		_txtScore.scrollFactor.set();

		add(_txtScore);
	}
	
	public function updateHUD(Score:Int = 0):Void
	{
		_txtScore.text = Std.string(Score);
	}

}