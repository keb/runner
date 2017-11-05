package src.entity;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

class Player extends FlxSprite
{
    public var speed:Float = 600;
    public var gravity:Int = 800;
    public var jumpSpeed:Int = 300;
    public var sword:FlxSprite;

    private var _jumpDuration:Float = -1;
    private var _attackDuration:Float = 0;
    private var _sndSword:FlxSound;
    private var _sndJump:FlxSound;

    public function new(xco:Float = 0, yco:Float = 0)
    {
        super(xco, yco);
        this.makeGraphic(16, 16, FlxColor.WHITE);

        //drag slows down obj when not moving
        this.drag.set(this.speed * 5, this.speed * 5);
        this.maxVelocity.set(this.speed, this.jumpSpeed);

        //set gravity
        this.acceleration.x = this.drag.x;
        this.acceleration.y = this.gravity;

        //sword
        this.sword = new FlxSprite();
        this.sword.loadGraphic(AssetPaths.slash__png, false, 8, 22);
        this.sword.scale.set(2, 2);
        this.sword.visible = false;
        FlxG.state.add(this.sword);

        //load sounds
        this._sndSword = FlxG.sound.load(AssetPaths.sword__ogg, 0.6);
        this._sndJump = FlxG.sound.load(AssetPaths.jump__ogg, 0.3);
    }

    override public function update(elapsed:Float):Void
    {
        //controls
        this._jumpAction();
        this._attackAction();

        super.update(elapsed);
    }

    private function _moveAction():Void
    {
        var right:Bool = false;
        var left:Bool = false;

        right = FlxG.keys.anyPressed(['RIGHT', 'D']);
        left = FlxG.keys.anyPressed(['LEFT', 'A']);

        //if not pressing, acceleration = 0
        this.acceleration.x = 0;
        if (right) {
            this.acceleration.x = this.drag.x;
            //facing = FlxObject.RIGHT;
        } else if (left) {
            this.acceleration.x = -this.drag.x;
            //facing = FlxObject.LEFT;
        }

        // Cancel opposite directions
        if (left && right) {
            left = false;
            right = false;
        }
    }

    private function _jumpAction():Void
    {
        var jump:Bool = false;

        //controls
        jump = FlxG.keys.anyPressed(['UP']);

        if (jump && this.isTouching(FlxObject.FLOOR)) {
            // FlxObject.FLOOR is a special-case constant meaning 'down'
            // used mainly by allowCollisions and touching
            this._jumpDuration = 0;
            this._sndJump.play();
        }

        if (this._jumpDuration >= 0 && this._jumpDuration < 0.30) {
            this._jumpDuration += FlxG.elapsed;
        }

        if (jump && this._jumpDuration >= 0) {
            this.velocity.y = -0.6 * this.maxVelocity.y;
            if (this._jumpDuration == 0.30) {
                this._jumpDuration = -1;
            }
        }

        if (FlxG.keys.anyJustReleased(['UP'])) {
            this._jumpDuration = -1;
        }
    }

    private function _attackAction():Void
    {
        var attack:Bool = false;
        this.sword.visible = false;

        //controls
        attack = FlxG.keys.anyPressed(['C']);

        if (attack && this._attackDuration < 0.01) {
            this._sndSword.play();
        }

        if (attack && this._attackDuration < 0.20) {
            this.sword.x = this.x + 28;
            this.sword.y = this.y;
            this.sword.visible = true;
        }

        if (attack) {
            this._attackDuration += FlxG.elapsed;
        } else {
            this._attackDuration = 0;
        }
    }

    private function _duckAction():Void
    {
        var duck:Bool = false;

        //controls
        duck = FlxG.keys.anyPressed(['DOWN']);

        if (duck) {
            this.height = this.height / 2;
            this.scale.set(1.0, 0.5);
            this.offset.set(16, 8);
        } else {
            this.resetSize();
        }
    }
}
