package;

import data.Save;
import data.SaveData;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import openfl.Assets;

// TODO: just scrap this? maybe?
class IntroState extends FlxState {

    var introText:FlxText;

    var randTextArray:Array<String> = [];

    public function new() {
        super();
        init();
    }

    override function create() {
        FlxG.sound.play('assets/sounds/startup.mp3');
        introText = new FlxText(20, 20, 0, "", 32);
        randTextArray = Assets.getText("assets/data/introText.txt").split('\n');
        add(introText);
        addText(.1, "GAME NAME HERE\n");
        addText(.2, "Made by\n");
        addText(.3, "denpatech");
        addText(.4, ", Chaos");
        addText(.5, ", lemma");
        addText(.6, ",\nKrystian");
        addText(.7, ", borgarlover");
        addText(.8, ", spuds\n");
        addText(.9, "Built with\n");
        addText(1, "HaxeFlixel\n");
        addText(1.1, "Made for\n");
		addText(1.2, "The 2026 NaNoRenO game jam\n");
		addText(1.3, '----------------------------------------------------------------------------------------------------------');
		new FlxTimer().start(2.6, _ ->
		{
            FlxG.switchState(() -> new PlayState());
        });
        super.create();
    }

    function randText() {
        var randText = FlxG.random.getObject(randTextArray);
        randTextArray.remove(randText);
        return randText;
    }

    function addText(time:Float, text:String) {
        new FlxTimer().start(time, _ -> {
            introText.text += text;
        });
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
		#if debug
		if (FlxG.keys.justPressed.C)
		{
			FlxG.save.erase();
			FlxG.resetState();
		}
		#end
    }

    function init() {
		FlxG.save.bind('nanoreno2026', 'denpatech');
		if (FlxG.save.data.saves == null)
		{
			FlxG.save.data.saves = new Map<String, Save>();
			FlxG.save.flush();
		}
		FlxG.save.flush();
    }
}