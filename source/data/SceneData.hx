package data;

typedef SceneFunc = {
    var func:String;
    var args:Array<Dynamic>;
}

typedef SceneData = {
    var name:String;
    var funcs:Array<SceneFunc>;
}