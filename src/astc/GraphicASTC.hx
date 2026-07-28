package astc;

import extension.astc.ASTC;
import extension.astc.ASTC.ASTCHeader;
import lime.utils.Bytes;
import lime.graphics.opengl.GLTexture;
import lime.utils.Assets;

class GraphicASTC
{
	public var texture(default, null):GLTexture;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var blockWidth(default, null):Int;
	public var blockHeight(default, null):Int;

	private var disposed:Bool = false;

	public function new(texture:GLTexture, header:ASTCHeader)
	{
		this.texture = texture;
		this.width = header.width;
		this.height = header.height;
		this.blockWidth = header.blockWidth;
		this.blockHeight = header.blockHeight;
	}

	public static function fromBytes(bytes:Bytes):GraphicASTC
	{
		var header = ASTC.parseHeader(bytes);
		var texture = ASTC.createTexture(bytes);

		return new GraphicASTC(texture, header);
	}

	public static function fromFile(path:String):GraphicASTC
	{
		var bytes = Assets.getBytes(path);

		if (bytes == null)
		{
			throw "Could not load ASTC file: " + path;
		}

		return fromBytes(bytes);
	}

	public function dispose():Void
	{
		if (disposed) return;

		lime.graphics.opengl.GL.deleteTexture(texture);
		disposed = true;
	}
}
