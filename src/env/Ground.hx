package src.env;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Ground extends FlxSprite
{
    public function new(xco:Float = 0, yco:Float = 0)
    {
        super(xco, yco);
        this.makeGraphic(16, 16, FlxColor.WHITE);
        this.immovable = true;
    }
}