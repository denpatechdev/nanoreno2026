package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import ui.LoadSlot;

class LoadSubstate extends FlxSubState
{
	var bg:FlxSprite;

	public function new()
	{
		super(FlxColor.GRAY);
	}

	override function create()
	{
		super.create();
		var slot1 = new LoadSlot(60, 60, "1");
		add(slot1);
		var slot2 = new LoadSlot(60, slot1.y + slot1.height + 50, "2");
		add(slot2);
		var slot3 = new LoadSlot(60, slot2.y + slot2.height + 50, "3");
		add(slot3);
		PlayState.instance.camera.filtersEnabled = false;
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			PlayState.instance.UIcam.visible = true;
			PlayState.instance.camera.filtersEnabled = true;
			close();
		}
		super.update(elapsed);
	}
}