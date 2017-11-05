package src.entity;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
    public var hasCollided:Bool = false;

    public function new(xco:Float = 0, yco:Float = 0)
    {
        super(xco, yco);
        this.makeGraphic(16, 16, FlxColor.WHITE);
    }
}