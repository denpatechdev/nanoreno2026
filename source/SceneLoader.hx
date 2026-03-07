package;

import data.SceneData;
import filters.FilterThing;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import haxe.Json;
import lime.utils.Assets;

class SceneLoader {

    var nameText:FlxText;
    var dialogueText:FlxTypeText;
    var choices:FlxTypedGroup<FlxButton>;
    var bg:FlxSprite;
    var characters:FlxTypedGroup<Character>;
    var filters:Array<FilterThing> = [];

	public var data:SceneData;

    public function new(?path:String) {
        if (path != null) {
            data = dataFromPath(path);
			PlayState.instance.sceneName = data.name;
        }
    }

    public function dataFromPath(scenePath:String) {
        return cast Json.parse(Assets.getText(scenePath));
    }

    public function loadScene() {
        var funcs:Array<SceneFunc> = data.funcs;

        for (fn in funcs) {
            switch (fn.func) {
            case 'set_bg':
					if (Assets.exists(fn.args[0]))
					{
                    bg.loadGraphic(fn.args[0]);
						PlayState.instance.engine.bgPath = fn.args[0];
					}
                else
                    trace("(set_bg) Could not find file at " + fn.args[0]);
            case 'set_bgm':
					if (Assets.exists(fn.args[0]))
					{
                    FlxG.sound.playMusic(fn.args[0]);
						PlayState.instance.engine.bgmPath = fn.args[0];
					}
                else
                    trace("(set_bgm) Could not find file at " + fn.args[0]);
            }
        }
    }

    public function bind(NameText:FlxText, DialogueText:FlxTypeText, Choices:FlxTypedGroup<FlxButton>, BG:FlxSprite, Characters:FlxTypedGroup<Character>, Filters:Array<FilterThing>) {
        nameText = NameText;
        dialogueText = DialogueText;
        choices = Choices;
        bg = BG;
        characters = Characters;
        filters = Filters;
    }
}