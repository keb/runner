
package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;

class Enemy extends FlxSprite
{
	public var hasCollided:Bool = false;

	public function new(X:Float=0, Y:Float=0){
		super(X,Y);
		makeGraphic(16,16, FlxColor.WHITE);
		immovable = false;
	}

	private function resetCollision():Void{
		hasCollided = false;
	}
	
}