package filters;

import openfl.filters.BitmapFilter;

typedef FilterThing = {
    var shader:BitmapFilter;
    var onUpdate:Float->Void;
}