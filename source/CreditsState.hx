import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;

class CreditsState extends FlxState {
    public var creditsArray:Array<Array<String>> = [];
    public var creditsTexts:FlxTypedGroup<FlxText>;

    public function new() {
        super();
        creditsArray = [
            ["denpatech", "Programmer and Writer", "https://x.com/denpatech"],
            ["Chaos", "Artist", ""],
            ["lemma", "Writer", ""],
            ["borgarlover", "Writer", ""],
            ["spuds", "Artist", ""],
            ["Krystian", "Composer", ""]
        ];
    }

    override function create() {
        super.create();
        creditsTexts = new FlxTypedGroup<FlxText>();
    }

    function onSelect(name:String) {
        for (i in creditsTexts.members) {
            for (j in 0...creditsArray.length) {
                if (i.text == creditsArray[j][0]) {
                    FlxG.openURL(creditsArray[j][2]);
                }
            }
        }
    }
}