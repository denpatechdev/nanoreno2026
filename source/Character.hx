package;

import flixel.FlxSprite;

class Character extends FlxSprite {
	public var name:String;
	public var expression:String;
	public var position:String;

	public var assetsPath:String;
	public var expressionMap:Map<String, String> = [];

	public var defaultY:Float;
	public var defaultExpression:String = "idle";


	public function new(name:String)
	{
		super();
		y = defaultY;
	}
}