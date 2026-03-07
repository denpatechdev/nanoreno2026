package;

import djFlixel.D;
import djFlixel.gfx.SpriteEffects;
import djFlixel.gfx.pal.Pal_DB32;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MainMenuState extends FlxState {
    
	public var texts:Array<{obj:FlxText, cb:Void->Void}> = [];

	override function create()
	{
		super.create();
		var newGame = new FlxText(50, 50, 0, "New Game", 32);
		var loadGame = new FlxText(50, newGame.y + newGame.height + 32, 0, "Load Game", 32);
		var settings = new FlxText(50, loadGame.y + loadGame.height + 32, 0, "Settings", 32);
		var credits = new FlxText(50, settings.y + settings.height + 32, 0, "Credits", 32);

		texts = [
			{
				obj: newGame,
				cb: onNewGame
			},
			{
				obj: loadGame,
				cb: onLoadGame
			},
			{
				obj: settings,
				cb: onSettings
			},
			{
				obj: credits,
				cb: onCredits
			}
		];

		add(newGame);
		add(loadGame);
		add(settings);
		add(credits);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		for (pair in texts)
		{
			if (FlxG.mouse.overlaps(pair.obj))
			{
				pair.obj.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 6);
				if (FlxG.mouse.justPressed)
				{
					pair.cb();
				}
			}
			else
			{
				pair.obj.setBorderStyle(FlxTextBorderStyle.NONE, 0, 0);
			}
		}
	}

	public function onNewGame()
	{
		FlxG.switchState(() -> new PlayState(null, null));
    }

    public function onLoadGame() {
		FlxG.switchState(LoadState.new);
    }

    public function onSettings() {
		FlxG.switchState(SettingsState.new);
    }

    public function onCredits() {
		FlxG.switchState(CreditsState.new);
    }
}