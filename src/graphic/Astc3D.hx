package graphic;

import extension.astc.ASTC;
import extension.astc.ASTC.ASTCHeader;
import extension.astc.ASTC.ASTCFormat;
import lime.utils.Bytes;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;

class Astc3D
{
	public static function getGLFormat3D(blockWidth:Int, blockHeight:Int, blockDepth:Int):Int
	{
		return switch [blockWidth, blockHeight, blockDepth]
		{
			case [3, 3, 3]: ASTCFormat3D.RGBA_3x3x3;
			case [4, 3, 3]: ASTCFormat3D.RGBA_4x3x3;
			case [4, 4, 3]: ASTCFormat3D.RGBA_4x4x3;
			case [4, 4, 4]: ASTCFormat3D.RGBA_4x4x4;
			case [5, 4, 4]: ASTCFormat3D.RGBA_5x4x4;
			case [5, 5, 4]: ASTCFormat3D.RGBA_5x5x4;
			case [5, 5, 5]: ASTCFormat3D.RGBA_5x5x5;
			case [6, 5, 5]: ASTCFormat3D.RGBA_6x5x5;
			case [6, 6, 5]: ASTCFormat3D.RGBA_6x6x5;
			case [6, 6, 6]: ASTCFormat3D.RGBA_6x6x6;
			default: throw "Unsupported ASTC 3D block size: " + blockWidth + "x" + blockHeight + "x" + blockDepth;
		}
	}

	public static function createTexture3D(bytes:Bytes):GLTexture
	{
		var header = ASTC.parseHeader(bytes);

		if (header.depth <= 1)
		{
			throw "Not a 3D ASTC texture (depth = " + header.depth + "), use ASTC.createTexture instead";
		}

		var format = getGLFormat3D(header.blockWidth, header.blockHeight, header.blockDepth);
		var data = bytes.sub(header.dataOffset, bytes.length - header.dataOffset);

		var texture = GL.createTexture();
		GL.bindTexture(GL.TEXTURE_3D, texture);
		GL.texParameteri(GL.TEXTURE_3D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_3D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_3D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_3D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_3D, GL.TEXTURE_WRAP_R, GL.CLAMP_TO_EDGE);
		GL.compressedTexImage3D(GL.TEXTURE_3D, 0, format, header.width, header.height, header.depth, 0, data);
		GL.bindTexture(GL.TEXTURE_3D, null);

		return texture;
	}
}

class ASTCFormat3D
{
	public static inline var RGBA_3x3x3:Int = 0x93C0;
	public static inline var RGBA_4x3x3:Int = 0x93C1;
	public static inline var RGBA_4x4x3:Int = 0x93C2;
	public static inline var RGBA_4x4x4:Int = 0x93C3;
	public static inline var RGBA_5x4x4:Int = 0x93C4;
	public static inline var RGBA_5x5x4:Int = 0x93C5;
	public static inline var RGBA_5x5x5:Int = 0x93C6;
	public static inline var RGBA_6x5x5:Int = 0x93C7;
	public static inline var RGBA_6x6x5:Int = 0x93C8;
	public static inline var RGBA_6x6x6:Int = 0x93C9;
}
