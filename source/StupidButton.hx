package;

import data.dialogue.DialogueData.Choice;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class StupidButton extends FlxSpriteGroup {
    public var cb:Void->Void;
    public var label:FlxText;
    public var box:FlxSprite; // later
    public function new(?X:Float, ?Y:Float, ?Size:Int = 32, ?Text:String, ?Callback:Void->Void) {
        super(X, Y);
        cb = Callback;
        label = new FlxText(0, 0, 0, Text, Size);
        add(label);
        updateHitbox();
    }

    override function update(elapsed:Float) {
        if (FlxG.mouse.overlaps(this) && FlxG.mouse.justPressed) {
            cb();
        }
        super.update(elapsed);
    }
}