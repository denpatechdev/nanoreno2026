package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import ui.LoadSlot;

class LoadState extends FlxState
{
	var bg:FlxSprite;

	public function new()
	{
		super();
	}

	override function create()
	{
		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		add(bg);
		super.create();
		var slot1 = new LoadSlot(60, 60, "1");
		add(slot1);
		var slot2 = new LoadSlot(60, slot1.y + slot1.height + 50, "2");
		add(slot2);
		var slot3 = new LoadSlot(60, slot2.y + slot2.height + 50, "3");
		add(slot3);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(MainMenuState.new);
		}
		super.update(elapsed);
	}
}