package data;

typedef CharacterData = {
    var characterName:String;
    var expression:String;
    var position:String;
}

typedef SaveData = {
	var scene:String;
    var bg:String;
    var bgm:String;
	var characters:Map<String, CharacterData>;
    var dialogueFile:String;
    var branch:String;
    var dialogueIdx:Int;
    var filters:Array<String>;
	var vars:Map<String, Dynamic>;
}