package ui;

import data.Save;
import data.SceneData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class LoadSlot extends FlxSpriteGroup {
    public var bg:FlxSprite;
    public var saveSlotText:FlxText;
    public var sceneText:FlxText;

	public var saveSlot:String;
    public var sceneName:String;

	public function new(x:Float, y:Float, SaveSlot:String)
	{
        super(x, y);
		saveSlot = SaveSlot;
		// trace("Save Data: ", FlxG.save.data.saves);
		if (FlxG.save.data.saves != null && FlxG.save.data.saves.get(saveSlot) != null)
		{
			sceneName = FlxG.save.data.saves.get(saveSlot).data.scene;
        } else {
            sceneName = "No Scene";
        }
        bg = new FlxSprite().makeGraphic(800, 150);
        saveSlotText = new FlxText(20, 20, 0, 'Slot ${saveSlot}', 48);
        saveSlotText.color = FlxColor.BLACK;
        var timeSaved = 0;
		if (FlxG.save.data.saves != null && FlxG.save.data.saves.get(saveSlot) != null)
		{
			timeSaved = FlxG.save.data.saves.get(saveSlot).timeSaved;
        }
        sceneText = new FlxText(20, saveSlotText.y + saveSlotText.height + 16, sceneName, 32);
        if (timeSaved != 0)
            sceneText.text += ' (' + DateTools.format(Date.fromTime(timeSaved), "%Y-%m-%d %H:%M:%S") + ')';
        sceneText.color = FlxColor.BLACK;
        add(bg);
        add(saveSlotText);
        add(sceneText);
    }

    var hovering:Bool = false;
    var clickedThis:Bool = false;

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.mouse.overlaps(this)) {
            if (!hovering && !FlxG.mouse.pressed || clickedThis && FlxG.mouse.justReleased) {
                onHover();
                clickedThis = false;
            }

            if (FlxG.mouse.justPressed) {
				if (FlxG.save.data.saves.get(saveSlot) != null)
					FlxG.switchState(() -> new PlayState(null, saveSlot));
            }

            hovering = true;
        } else if (!FlxG.mouse.overlaps(this)) {
            hovering = false;
            theDefault();
        }
    }

    function theDefault() {
        saveSlotText.borderSize = 0;
        sceneText.borderSize = 0;
    }

    function onHover() {
        saveSlotText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 8, 1);
        sceneText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 6, 1);
    }

    function onClick() {

    }
}