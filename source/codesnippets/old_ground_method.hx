		/******* CREATE GROUND *******/
		//Intialize starting groundWidth for ground creation
		_groundWidth = 0;

		_walls = new FlxGroup();
		_ground = new FlxSprite(0,FlxG.height - 16);

		//Create Ground Sprites and add to _walls group
		_ground.makeGraphic(FlxG.width, 16, FlxColor.WHITE);
		_ground.immovable = true;
		_walls.add(_ground);

		/******* ADD ALL OBJECTS *******/
		add(_player);
		add(_walls);

		//Ground Update
		//_ground.makeGraphic(Std.int(FlxG.worldBounds.width) + 1, 16, FlxColor.WHITE);