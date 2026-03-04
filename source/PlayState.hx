package;

import data.StateData;
import filters.FilterThing;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;

class PlayState extends FlxState
{
	public var loader:SceneLoader;
	public var engine:DialogueEngine;

	public var dialogueBg:FlxSprite;
	public var nameText:FlxText;
    public var dialogueText:FlxTypeText;
    public var choices:FlxTypedGroup<FlxButton>;
    public var bg:FlxSprite;
    public var characters:FlxTypedGroup<Character>;
	public var filters:Array<FilterThing> = [];


	public var UIgroup:FlxGroup;
	public var UIcam:FlxCamera;

	public static var instance:PlayState;

	public function new(?statePath:String) {
		super();
		instance = this;
		preInit(statePath);
	}

	override public function create()
	{
		super.create();
		init();
		initCams();
	}

	function preInit(statePath:String) {
		var stateData:StateData;
		if (statePath == null || !Assets.exists(statePath)) {
			stateData = cast Json.parse(Assets.getText("assets/data/state.json"));
			trace("statePath is null or points to non-existent file");
		} else {
			stateData = cast Json.parse(Assets.getText(statePath)); 
		}
		var scenePath = stateData.scene;
		var dialoguePath = stateData.dialogue;
		loader = new SceneLoader(scenePath);
		engine = new DialogueEngine(dialoguePath);
	}

	function init() {
		dialogueBg = new FlxSprite().makeGraphic(FlxG.width, Std.int(FlxG.height / 2), FlxColor.BLACK);
		dialogueBg.alpha = .5;
		characters = new FlxTypedGroup<Character>();
		bg = new FlxSprite();
		nameText = new FlxText(20, 20, 0, "Name", 16);
		dialogueText = new FlxTypeText(20, nameText.y + nameText.height + 16, FlxG.width - 40, "Dialogue text", 16);
		choices = new FlxTypedGroup<FlxButton>();
		UIgroup = new FlxGroup();

		add(bg);
		add(characters);
		add(UIgroup);
		UIgroup.add(dialogueBg);
		UIgroup.add(nameText);
		UIgroup.add(dialogueText);
		UIgroup.add(choices);

		loader.bind(nameText, dialogueText, choices, bg, characters, filters);
		engine.bind(nameText, dialogueText, choices, bg, characters, filters);
		
		loader.loadScene();
		engine.runDialogue();
	}

	function initCams() {
		UIcam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		UIcam.bgColor = FlxColor.TRANSPARENT;
		UIgroup.camera = UIcam;
		FlxG.cameras.add(UIcam, false);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		updateDialogue();
		updateFilters(elapsed);
	}

	function updateFilters(elapsed:Float) {
		for (f in filters) {
			f.onUpdate(elapsed);
		}
	}

	function updateDialogue() {
		if (FlxG.keys.justPressed.ENTER || (FlxG.mouse.justPressed && !engine.selectingChoices)) {
			engine.progressDialogue();
		}
	}
}
