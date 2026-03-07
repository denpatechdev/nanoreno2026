package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

/*
	\
	{
	"defaultTypingSpeed": 0.03846153846,
	"textBGColor": "0x000000",
	"textColor": "0xFFFFFF",
	}
 */
typedef Settings =
{
	var defaultTypingSpeed:Float;
	var textBGColor:Int;
	var textColor:Int;
}

class SettingsState extends FlxState
{
	override function create()
	{
		super.create();
		add(new FlxText(50, 50, 0, "To be implemented", 32));
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