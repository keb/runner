private function updateMovement():Void{
	var _right:Bool = false;
	var _left:Bool = false;

	//Controls
	_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
	_left = FlxG.keys.anyPressed(["LEFT", "A"]);

	//If not pressing, acceleration = 0
	acceleration.x = 0;
	if(_right){
		acceleration.x = drag.x;
		//facing = FlxObject.RIGHT;
	}
	else if(_left){
		acceleration.x = -drag.x; 
		//facing = FlxObject.LEFT;
	}

	//Cancel opposite directions
	if(_left && _right)
		_left = _right = false;

	//Prevent falling off map (NOT NEEDED IN ENDLESS RUNNER duh)
	if(this.x <= 0)
		this.x = 0;
	if((this.x + this.width) > FlxG.width)
		this.x = FlxG.width - this.width;

		/* FOR USE WITH SPRITE */
	if((velocity.x != 0 || velocity.y != 0)){
		switch(facing){
			case FlxObject.LEFT, FlxObject.RIGHT:
				animation.play("LR");
		}
	}
}