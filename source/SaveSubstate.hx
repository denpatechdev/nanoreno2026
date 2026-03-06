package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import ui.SaveSlot;

class SaveSubstate extends FlxSubState {
    var bg:FlxSprite;
    public function new() {
        super(FlxColor.GRAY);
    }

    override function create() {
        super.create();
        var slot1 = new SaveSlot(60, 60, 1);
        add(slot1);
        var slot2 = new SaveSlot(60, slot1.y+slot1.height+50, 2);
        add(slot2);
        var slot3 = new SaveSlot(60, slot2.y+slot2.height+50, 3);
        add(slot3);
        trace("SAVEDATA\n",FlxG.save.data);
        PlayState.instance.camera.filtersEnabled = false;
    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ENTER) {
            PlayState.instance.UIcam.visible = true;
            PlayState.instance.camera.filtersEnabled = true;
            close();
        }
        super.update(elapsed);
    }
}