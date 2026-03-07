package;

import data.SaveData;
import data.dialogue.DialogueData.Choice;
import data.dialogue.DialogueData.DialogueBlock;
import data.dialogue.DialogueData.DialogueEvent;
import data.dialogue.DialogueData.EventFunc;
import filters.FilterThing;
import filters.Grain;
import filters.Scanline;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
import openfl.filters.ShaderFilter;

class DialogueEngine {
    public var startBranch:String = "start";
    public var branches:Map<String, Array<DialogueBlock>> = []; 
    
	public var bgPath:String;
	public var bgmPath:String;
	public var dialoguePath:String;
	public var filterNames:Array<String> = [];

    public var curIdx:Int = 0;
    public var curBranchName:String;
	public var curBranch:Array<DialogueBlock> = [];
	public var curBlock:DialogueBlock;
	public var curChoices:Array<Choice> = [];

    public var defaultTypingSpeed:Float = 1/26;

    public var events:Map<String, EventFunc> = [];

    public var nameText:FlxText;
    public var dialogueText:FlxTypeText;
    public var choices:FlxTypedGroup<FlxButton>;
    public var bg:FlxSprite;
    public var characters:FlxTypedGroup<Character>;
    public var characterTags:Map<String, Character> = [];
    public var filters:Array<FilterThing> = [];
	public var varsMap:Map<String, Dynamic> = [];

    public var typingDone:Bool = true;
    public var selectingChoices:Bool = false;

    public var dialogueFinished:Bool = false;

	public var curFile:String;

    public function new(?path:String) {
		if (path != null && Assets.exists(path))
		{
            branches = loadFromFile(path);
			setBranch(startBranch);
		}
		else
		{
			trace('DialogueEngine.new - File at path $path not found');
        }
    }

    public function isDialogueDone() {
        return typingDone && curIdx >= curBranch.length - 1;
    }

    public function progressDialogue() 
    {
        if (!typingDone) {
            skipDialogue();
        } else if (!selectingChoices && typingDone && curIdx < curBranch.length - 1) {
            curIdx++;
            curBlock = curBranch[curIdx];
            curChoices = curBlock.choices;
            runDialogue();
        }
    }

	public function runDialogue(?idx:Null<Int> = null)
	{
		if (idx != null)
		{
			curBlock = curBranch[curIdx];
			curChoices = curBlock.choices;
		}
		trace(curBlock, 'THE CUR BLOCK');

		var typingSpeed = FlxG.save.data.settings.defaultTypingSpeed;
        for (attr in curBlock.attrs) {
            if (attr.name == "typing_speed") {
                typingSpeed = attr.value;
            }
        }
        nameText.text = curBlock.name;
        dialogueText.resetText(curBlock.text);
        dialogueText.start(typingSpeed);
        typingDone = false;

        for (ev in curBlock.events) {
            handleEvent(ev);
        }
    }

    public function skipDialogue() {
        dialogueText.skip();
        typingDone = true;
        showChoices();
    }

    function handleEvent(ev:DialogueEvent, ?isChoice:Bool = false) {
        switch (ev.name) {
			case 'load_state':
				if (Assets.exists(ev.args[0]))
				{
					FlxG.switchState(() -> new PlayState(ev.args[0]));
				}
				else
				{
					trace('(load_state) File not found at ${ev.args[0]}');
				}
            case 'set_branch':
            if (branches.exists(ev.args[0])) {
                    if (!isChoice) {
                        curIdx = -1;
                        curBranch = branches[ev.args[0]];
                    } else {
                        curIdx = 0;
                        curBranch = branches[ev.args[0]];
                        curBlock = curBranch[curIdx];
                        curChoices = curBlock.choices;
                        runDialogue();
                    }
                } else {
                    trace("(set_branch) Could not find branch " + ev.args[0]);
                }
            case 'set_bg':
                if (Assets.exists(ev.args[0]))
                    bg.loadGraphic(ev.args[0]);
                else
                    trace("(set_bg) Could not find file at " + ev.args[0]);
            case 'set_bgm':
                if (Assets.exists(ev.args[0]))
                    FlxG.sound.playMusic(ev.args[0]);
                else
                    trace("(set_bgm) Could not find file at " + ev.args[0]);
            case 'play_sound':
                if (Assets.exists(ev.args[0]))
                    FlxG.sound.play(ev.args[0]);
                else
                    trace("(play_sound) Could not find file at " + ev.args[0]);
            case 'filter':
                applyFilter(ev.args[0]);
			case 'char':
				createChar(ev.args[0], ev.args[1]);
			case 'move_char':
				moveChar(ev.args[0], ev.args[1]);
			case 'change_char':
				changeChar(ev.args[0], ev.args[1]);
			case 'hide_char':
				hideChar(ev.args[0]);
			case 'show_char':
				showChar(ev.args[0]);
			case 'del_char':
				delChar(ev.args[0]);
		}
	}

	public function createChar(tag:String, graphic:String)
	{
		if (!Assets.exists(graphic))
		{
			trace("(char) Could not find file at " + graphic);
			return;
		}
		var sprite = new Character(tag);
		sprite.loadGraphic(graphic);
		characterTags[tag] = sprite;
		characters.add(sprite);
	}

	public function moveChar(tag:String, location:String)
	{
		if (!characterTags.exists(tag))
		{
			trace("(move_char) Tag not found");
			return;
		}
		var char = characterTags[tag];

		switch (location)
		{
			case 'left':
				char.x = 0;
			case 'center':
				char.screenCenter(X);
			case 'right':
				char.x = FlxG.width - char.width;
		}
	}

	public function changeChar(tag:String, graphic:String)
	{
		if (characterTags.exists(tag))
			characterTags[tag].loadGraphic(graphic);
		else
			trace("(change_char) Tag not found");
	}

	public function hideChar(tag:String)
	{
		if (characterTags.exists(tag))
		{
			characterTags[tag].visible = false;
		}
		else
		{
			trace("(hide_char) Tag not found");
		}
	}

	public function showChar(tag:String)
	{
		if (characterTags.exists(tag))
		{
			characterTags[tag].visible = true;
		}
		else
		{
			trace("(show_char) Tag not found");
		}
	}

	public function delChar(tag:String)
	{
		if (characterTags.exists(tag))
		{
			characters.remove(characterTags[tag]);
			characterTags[tag].kill();
			characterTags.remove(tag);
		}
		else
		{
			trace("(del_char) Tag not found");
        }
    }

    public function applyFilter(filterName:String) {
        filterName = filterName.toLowerCase();

        switch (filterName) {
            case 'scanline':
                addFilter(new ShaderFilter(new Scanline()), (elapsed) -> {});
            case 'grain':
                var grain:Grain = new Grain();
                grain.uTime.value = [0];
                addFilter(new ShaderFilter(grain), (elapsed) -> {
                    grain.uTime.value[0] += elapsed;
                });
			case 'invert':
				var matrix:Array<Float> = [
					-1,  0,  0, 0, 255,
					 0, -1,  0, 0, 255,
					 0,  0, -1, 0, 255,
					 0,  0,  0, 1,   0,
				];
			
				addFilter(new ColorMatrixFilter(matrix), (elapsed) -> {});
			case 'grayscale':
				var matrix:Array<Float> = [
					0.5, 0.5, 0.5, 0, 0,
					0.5, 0.5, 0.5, 0, 0,
					0.5, 0.5, 0.5, 0, 0,
					  0,   0,   0, 1, 0,
				];

				addFilter(new ColorMatrixFilter(matrix), (elapsed) -> {});
			case 'blur':
				addFilter(new BlurFilter(), (elapsed) -> {});
			case 'clear':
				filters = [];
            default:
                trace("(filter) Filter " + filterName + " not found");
            
        }

		filterNames.push(filterName);

        var actualFilters:Array<BitmapFilter> = [];
        for (i in filters) {
            actualFilters.push(i.shader);
        }

        PlayState.instance.filters = filters;
        FlxG.camera.filters = actualFilters;
    }

    function addFilter(shader:BitmapFilter, onUpdate:Float->Void) {
        filters.push({
            shader: shader,
            onUpdate: onUpdate
        });
    }
    

    function showChoices() {
        if (curChoices.length == 0) return;
        selectingChoices = true;

        for (i in 0...curChoices.length) {
            var choice = curChoices[i];

            function onChoiceSelect() {
                handleEvent(choice.event, true);
                for (btn in choices) {
                    btn.kill();
                }

                choices.clear();
                curChoices = [];
                selectingChoices = false;
            }

            var btn = new FlxButton(20 + i * 140, dialogueText.y + dialogueText.height + 16, choice.text, onChoiceSelect);
            @:privateAccess
            btn.label.color = FlxColor.WHITE;
            btn.label.size = 16;
            btn.label.updateHitbox();
            btn.makeGraphic(Std.int(btn.label.width)+40, Std.int(btn.label.height)+20, FlxColor.TRANSPARENT);
            choices.add(btn);
        }
    }

    public function loadFromFile(path:String) {
		if (!Assets.exists(path))
		{
			trace('DialogueEngine.loadFromFile - File at ${path} not found');
			return null;
		}

        var ret:Map<String, Array<DialogueBlock>> = [];

		dialoguePath = path;

        var jsonData = Json.parse(Assets.getText(path));
        var allDialogue:Array<Dynamic> = jsonData.dialogue;
        var branchNames:Array<String> = jsonData.branches;

        for (branch in allDialogue) {
            for (name in branchNames) {
                if (Reflect.field(branch, name) != null) {
                    ret.set(name, Reflect.field(branch, name));
                }
            }
        }
        branches = ret;
        return ret;
    }

    public function setBranch(name:String) {
        curBranchName = name;
        curBranch = branches[name];
        curIdx = 0;
        curBlock = curBranch[curIdx];
        curChoices = curBlock.choices;
    }

    public function bind(NameText:FlxText, DialogueText:FlxTypeText, Choices:FlxTypedGroup<FlxButton>, BG:FlxSprite, Characters:FlxTypedGroup<Character>, Filters:Array<FilterThing>) {
        nameText = NameText;
        dialogueText = DialogueText;
        choices = Choices;
        bg = BG;
        characters = Characters;
        filters = Filters;
        dialogueText.completeCallback = () -> {
            typingDone = true;
            showChoices();
        }
    }

	function loadSaveData() {
        
	}
}