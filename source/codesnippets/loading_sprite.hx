/* FOR USE WITH SPRITE */
	//tells sprite user player.png, that animated=true, each frame is 16x16
loadGraphic(AssetPaths.player__png, true, 16, 16);

	//don't flip when facing Left (because sprite already faces left)
	//DO flip horizontally when facing Right
setFacingFlip(FlxObject.LEFT, false, false);
setFacingFlip(FlxObject.RIGHT, true, false);

	//Define Animations
animation.add("LR", [3,4,3,5], 6, false);