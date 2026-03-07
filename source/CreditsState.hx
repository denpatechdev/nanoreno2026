import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class CreditsState extends FlxState {
    public var creditsArray:Array<Array<String>> = [];
    public var creditsTexts:FlxTypedGroup<FlxText>;

    public function new() {
        super();
        creditsArray = [
            ["denpatech", "Programmer and Writer", "https://x.com/denpatech"],
			["c3ntaureajuno", "Artist", "https://itch.io/profile/c3ntaureajuno"],
			["lemma", "Writer", "https://itch.io/profile/lemma42"],
			["borgarlover", "Writer", "https://borgarlover.itch.io/"],
            ["spuds", "Artist", ""],
			["Krystian", "Composer", "https://open.spotify.com/artist/00ST2tnvDk5snHIxbcMukQ"]
        ];
    }

    override function create() {
        super.create();
        creditsTexts = new FlxTypedGroup<FlxText>();
		var prev:FlxText = null;
		for (i in creditsArray)
		{
			var text = new FlxText(50, 50, 0, i[0] + ' - ' + i[1], 32);
			if (prev != null)
			{
				text.y = prev.y + prev.height + 32;
			}
			prev = text;
			creditsTexts.add(text);
		}
		add(creditsTexts);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(MainMenuState.new);
		}
		for (t in creditsTexts.members)
		{
			if (FlxG.mouse.overlaps(t))
			{
				t.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.GRAY, 6);
				if (FlxG.mouse.justPressed)
				{
					for (c in creditsArray)
					{
						// whatever
						if (t.text.split(' ')[0] == c[0])
						{
							onSelect(c[0]);
						}
					}
				}
			}
			else
			{
				t.setBorderStyle(FlxTextBorderStyle.NONE, 0, 0);
			}
		}
		super.update(elapsed);
	}

	function onSelect(name:String)
	{
		for (j in 0...creditsArray.length)
		{
			if (name == creditsArray[j][0])
			{
				FlxG.openURL(creditsArray[j][2]);
            }
        }
    }
}