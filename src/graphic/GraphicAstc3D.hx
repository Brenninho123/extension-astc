package graphic;

import graphic.Astc3D;
import extension.astc.ASTC;
import extension.astc.ASTC.ASTCHeader;
import lime.utils.Bytes;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;
import lime.utils.Assets;

class GraphicAstc3D
{
	public var texture(default, null):GLTexture;
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var depth(default, null):Int;
	public var blockWidth(default, null):Int;
	public var blockHeight(default, null):Int;
	public var blockDepth(default, null):Int;

	private var disposed:Bool = false;

	public function new(texture:GLTexture, header:ASTCHeader)
	{
		this.texture = texture;
		this.width = header.width;
		this.height = header.height;
		this.depth = header.depth;
		this.blockWidth = header.blockWidth;
		this.blockHeight = header.blockHeight;
		this.blockDepth = header.blockDepth;
	}

	public static function fromBytes(bytes:Bytes):GraphicAstc3D
	{
		var header = ASTC.parseHeader(bytes);
		var texture = Astc3D.createTexture3D(bytes);

		return new GraphicAstc3D(texture, header);
	}

	public static function fromFile(path:String):GraphicAstc3D
	{
		var bytes = Assets.getBytes(path);

		if (bytes == null)
		{
			throw "Could not load ASTC 3D file: " + path;
		}

		return fromBytes(bytes);
	}

	public function dispose():Void
	{
		if (disposed) return;

		GL.deleteTexture(texture);
		disposed = true;
	}
}
