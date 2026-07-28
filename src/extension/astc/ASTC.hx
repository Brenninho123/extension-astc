package extension.astc;

import lime.utils.Bytes;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLTexture;

class ASTC
{
	public static inline var MAGIC:Int = 0x5CA1AB13;

	public static function parseHeader(bytes:Bytes):ASTCHeader
	{
		var magic = bytes.get(0) | (bytes.get(1) << 8) | (bytes.get(2) << 16) | (bytes.get(3) << 24);

		if (magic != MAGIC)
		{
			throw "Invalid ASTC file";
		}

		var blockWidth = bytes.get(4);
		var blockHeight = bytes.get(5);
		var blockDepth = bytes.get(6);

		var width = bytes.get(7) | (bytes.get(8) << 8) | (bytes.get(9) << 16);
		var height = bytes.get(10) | (bytes.get(11) << 8) | (bytes.get(12) << 16);
		var depth = bytes.get(13) | (bytes.get(14) << 8) | (bytes.get(15) << 16);

		return
		{
			blockWidth: blockWidth,
			blockHeight: blockHeight,
			blockDepth: blockDepth,
			width: width,
			height: height,
			depth: depth,
			dataOffset: 16
		};
	}

	public static function getGLFormat(blockWidth:Int, blockHeight:Int):Int
	{
		return switch [blockWidth, blockHeight]
		{
			case [4, 4]: ASTCFormat.RGBA_4x4;
			case [5, 4]: ASTCFormat.RGBA_5x4;
			case [5, 5]: ASTCFormat.RGBA_5x5;
			case [6, 5]: ASTCFormat.RGBA_6x5;
			case [6, 6]: ASTCFormat.RGBA_6x6;
			case [8, 5]: ASTCFormat.RGBA_8x5;
			case [8, 6]: ASTCFormat.RGBA_8x6;
			case [8, 8]: ASTCFormat.RGBA_8x8;
			case [10, 5]: ASTCFormat.RGBA_10x5;
			case [10, 6]: ASTCFormat.RGBA_10x6;
			case [10, 8]: ASTCFormat.RGBA_10x8;
			case [10, 10]: ASTCFormat.RGBA_10x10;
			case [12, 10]: ASTCFormat.RGBA_12x10;
			case [12, 12]: ASTCFormat.RGBA_12x12;
			default: throw "Unsupported ASTC block size: " + blockWidth + "x" + blockHeight;
		}
	}

	public static function createTexture(bytes:Bytes):GLTexture
	{
		var header = parseHeader(bytes);
		var format = getGLFormat(header.blockWidth, header.blockHeight);
		var data = bytes.sub(header.dataOffset, bytes.length - header.dataOffset);

		var texture = GL.createTexture();
		GL.bindTexture(GL.TEXTURE_2D, texture);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
		GL.compressedTexImage2D(GL.TEXTURE_2D, 0, format, header.width, header.height, 0, data);
		GL.bindTexture(GL.TEXTURE_2D, null);

		return texture;
	}
}

typedef ASTCHeader =
{
	var blockWidth:Int;
	var blockHeight:Int;
	var blockDepth:Int;
	var width:Int;
	var height:Int;
	var depth:Int;
	var dataOffset:Int;
}

class ASTCFormat
{
	public static inline var RGBA_4x4:Int = 0x93B0;
	public static inline var RGBA_5x4:Int = 0x93B1;
	public static inline var RGBA_5x5:Int = 0x93B2;
	public static inline var RGBA_6x5:Int = 0x93B3;
	public static inline var RGBA_6x6:Int = 0x93B4;
	public static inline var RGBA_8x5:Int = 0x93B5;
	public static inline var RGBA_8x6:Int = 0x93B6;
	public static inline var RGBA_8x8:Int = 0x93B7;
	public static inline var RGBA_10x5:Int = 0x93B8;
	public static inline var RGBA_10x6:Int = 0x93B9;
	public static inline var RGBA_10x8:Int = 0x93BA;
	public static inline var RGBA_10x10:Int = 0x93BB;
	public static inline var RGBA_12x10:Int = 0x93BC;
	public static inline var RGBA_12x12:Int = 0x93BD;
}
