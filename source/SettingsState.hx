package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxInputText;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class SettingsState extends FlxState
{
	var defaultTypingSpeedIn:FlxInputText;
	var textBGColorHexIn:FlxInputText;
	var textColorIn:FlxInputText;

	override function create()
	{
		super.create();
		// add(new FlxText(50, 50, 0, "To be implemented", 32));
		createLabelsAndInputs();
	}

	function createLabelsAndInputs()
	{
		var lbl1 = new FlxText(50, 50, 0, "Default typing speed (chars/sec)", 32);
		add(lbl1);
		defaultTypingSpeedIn = new FlxInputText(lbl1.x + lbl1.width + 32, lbl1.y, 0, Std.string(1 / FlxG.save.data.settings.defaultTypingSpeed), 32);
		add(defaultTypingSpeedIn);
		var lbl2 = new FlxText(50, lbl1.y + lbl1.height + 32, 0, "Dialogue text BG color (hex code)", 32);
		add(lbl2);
		textBGColorHexIn = new FlxInputText(lbl1.x + lbl1.width + 32, lbl2.y, 0, '0x' + StringTools.hex(FlxG.save.data.settings.textBGColor, 6), 32);
		add(textBGColorHexIn);
		var lbl3 = new FlxText(50, lbl2.y + lbl2.height + 32, 0, "Dialogue text color (hex code)", 32);
		add(lbl3);
		textColorIn = new FlxInputText(lbl1.x + lbl1.width + 32, lbl3.y, 0, '0x' + StringTools.hex(FlxG.save.data.settings.textColor, 6), 32);
		add(textColorIn);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			if (Std.parseFloat(defaultTypingSpeedIn.text) != null)
				FlxG.save.data.settings.defaultTypingSpeed = 1 / Std.parseFloat(defaultTypingSpeedIn.text);
			if (Std.parseInt(textBGColorHexIn.text) != null)
				FlxG.save.data.settings.textBGColor = textBGColorHexIn.text;
			if (Std.parseInt(textColorIn.text) != null)
				FlxG.save.data.settings.textColor = textColorIn.text;
			FlxG.save.flush();
			FlxG.switchState(MainMenuState.new);
		}
		super.update(elapsed);
	}
}