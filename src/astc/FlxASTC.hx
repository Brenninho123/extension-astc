package astc;

import astc.GraphicASTC;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxImageFrame;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;
import lime.graphics.opengl.GLTexture;

class FlxASTC
{
	public static function fromFile(path:String, ?key:String):FlxGraphic
	{
		var cacheKey = (key != null) ? key : path;
		var cached = FlxGraphic.findGraphic(cacheKey);

		if (cached != null)
		{
			return cached;
		}

		var graphic = GraphicASTC.fromFile(path);
		var bitmapData = wrapTexture(graphic);

		var flxGraphic = FlxGraphic.fromBitmapData(bitmapData, false, cacheKey);
		flxGraphic.persist = true;

		return flxGraphic;
	}

	private static function wrapTexture(graphic:GraphicASTC):BitmapData
	{
		var bitmapData = BitmapData.fromTexture(cast graphic.texture);

		if (bitmapData == null)
		{
			throw "Failed to wrap ASTC GLTexture into BitmapData — check OpenFL backend GL texture support";
		}

		return bitmapData;
	}
}
