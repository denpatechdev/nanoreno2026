package;

import LoadSubState.LoadSubstate;
import data.SaveData;
import data.StateData;
import filters.FilterThing;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.plugin.FlxScrollingText;
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

	public var saveSlot:String;
	public var sceneName:String;

	public static var instance:PlayState;

	public function new(?statePath:String, ?saveSlot:String = null)
	{
		super();
		instance = this;
		this.saveSlot = saveSlot;
		preInit(statePath);
	}

	override public function create()
	{
		super.create();
		init();
		initCams();
	}

	function preInit(statePath:String) {
		if (saveSlot == null)
		{
			var stateData:StateData;
			if (statePath == null || !Assets.exists(statePath))
			{
				stateData = cast Json.parse(Assets.getText("assets/data/state.json"));
				trace("statePath is null or points to non-existent file");
			}
			else
			{
				stateData = cast Json.parse(Assets.getText(statePath));
			}
			var scenePath = stateData.scene;
			var dialoguePath = stateData.dialogue;
			loader = new SceneLoader(scenePath);
			engine = new DialogueEngine(dialoguePath);
		}
		else
		{
			if (FlxG.save.data.saves.exists(saveSlot))
			{
				var saveData:SaveData = FlxG.save.data.saves.get(saveSlot).data;
				trace(saveData, ",_, the save data ok");
				trace(saveData.dialogueFile);
				engine = new DialogueEngine(saveData.dialogueFile);
				engine.curIdx = saveData.dialogueIdx;
				if (saveData.filters != null)
				{
					for (f in saveData.filters)
					{
						engine.applyFilter(f);
					}
				}
				if (saveData.vars != null)
				{
					engine.varsMap = saveData.vars;
				}
			}
			else
			{
				saveSlot = null;
			}
		}
	}

	function init() {
		dialogueBg = new FlxSprite().makeGraphic(FlxG.width, Std.int(FlxG.height / 2), FlxColor.fromString(FlxG.save.data.settings.textBGColor));
		dialogueBg.alpha = .5;
		characters = new FlxTypedGroup<Character>();
		bg = new FlxSprite();
		nameText = new FlxText(20, 20, 0, "Name", 32);
		nameText.color = FlxColor.fromString(FlxG.save.data.settings.textColor);
		dialogueText = new FlxTypeText(20, nameText.y + nameText.height + 32, FlxG.width - 40, "Dialogue text", 32);
		dialogueText.color = FlxColor.fromString(FlxG.save.data.settings.textColor);
		choices = new FlxTypedGroup<FlxButton>();
		UIgroup = new FlxGroup();
		add(bg);
		add(characters);
		add(UIgroup);
		UIgroup.add(dialogueBg);
		UIgroup.add(nameText);
		UIgroup.add(dialogueText);
		UIgroup.add(choices);

		if (loader != null)
			loader.bind(nameText, dialogueText, choices, bg, characters, filters);
		engine.bind(nameText, dialogueText, choices, bg, characters, filters);
		
		var savedIdx:Null<Int> = null;

		if (saveSlot != null)
		{
			var saveData:SaveData = FlxG.save.data.saves.get(saveSlot).data;
			bg.loadGraphic(saveData.bg);
			FlxG.sound.playMusic(saveData.bgm);
			savedIdx = saveData.dialogueIdx;
		}

		if (loader != null)
			loader.loadScene();
		engine.runDialogue(savedIdx);
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

		if (FlxG.keys.justPressed.S)
		{
			UIcam.visible = false;
			openSubState(new SaveSubstate());
		}

		if (FlxG.keys.justPressed.L)
		{
			UIcam.visible = false;
			openSubState(new LoadSubstate());
		}

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
	public function createSaveData()
	{
		var charactersMap:Map<String, CharacterData> = [];
		for (k => v in engine.characterTags)
		{
			charactersMap[k] = {
				characterName: v.name,
				expression: v.expression,
				position: v.position
			};
		}

		var saveData:SaveData = {
			scene: sceneName,
			bg: engine.bgPath,
			bgm: engine.bgmPath,
			characters: charactersMap,
			dialogueFile: engine.dialoguePath,
			branch: engine.curBranchName,
			dialogueIdx: engine.curIdx,
			filters: engine.filterNames,
			vars: engine.varsMap
		};

		return saveData;
	}
}
