package astc.gles;

import lime.graphics.opengl.GL;

class GLES
{
	private static var extensionsCache:Array<String> = null;

	public static function getExtensions():Array<String>
	{
		if (extensionsCache == null)
		{
			var raw = GL.getParameter(GL.EXTENSIONS);
			extensionsCache = (raw != null) ? raw.split(" ") : [];
		}

		return extensionsCache;
	}

	public static function hasExtension(name:String):Bool
	{
		return getExtensions().indexOf(name) != -1;
	}

	public static function supportsASTC():Bool
	{
		return hasExtension("GL_KHR_texture_compression_astc_ldr") || hasExtension("GL_OES_texture_compression_astc");
	}

	public static function supportsASTC3D():Bool
	{
		return hasExtension("GL_KHR_texture_compression_astc_hdr") || hasExtension("GL_OES_texture_compression_astc");
	}

	public static function supportsTexture3D():Bool
	{
		#if (lime_gles3 || desktop)
		return true;
		#else
		return hasExtension("GL_OES_texture_3D");
		#end
	}

	public static function getVersionString():String
	{
		return GL.getParameter(GL.VERSION);
	}
}
