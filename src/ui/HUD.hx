package src.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText.FlxTextAlign;
import flixel.util.FlxColor;

class HUD extends FlxTypedGroup<FlxSprite>
{
    private var _textScore:FlxText;
    private var _gameOver:FlxText;

    public function new()
    {
        super();
        this._textScore = new FlxText(10, 10, 0, '0', 16);
        this._textScore.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1.0, 1.0);
        this._textScore.scrollFactor.set();

        this._gameOver = new FlxText(0, 30, FlxG.width);
        this._gameOver.setFormat(null, 36, FlxColor.WHITE, FlxTextAlign.CENTER);
        this._gameOver.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 1.0, 1.0);
        this._gameOver.visible = false;
        this._gameOver.scrollFactor.set(0, 0);

        this.add(this._textScore);
        this.add(this._gameOver);
    }

    public function updateHUD(score:Int = 0, alive:Bool):Void
    {
        this._textScore.text = Std.string(score);

        if (!alive) {
            this._gameOver.text = 'You are dead! Your final score is ${ this._textScore.text }\nPress R to restart.';
            this._gameOver.visible = true;
            this._textScore.visible = false;
        }
    }
}