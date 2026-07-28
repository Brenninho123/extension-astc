package astc;

import sys.FileSystem;
import sys.io.Process;
import sys.io.File;

class BuildASTC
{
	public static function main():Void
	{
		var args = Sys.args();

		if (args.length < 2)
		{
			Sys.println("Usage: haxelib run extension-astc <inputDir> <outputDir> [blockSize] [quality]");
			Sys.exit(1);
		}

		var inputDir = args[0];
		var outputDir = args[1];
		var blockSize = (args.length > 2) ? args[2] : "6x6";
		var quality = (args.length > 3) ? args[3] : "-medium";

		if (!FileSystem.exists(inputDir))
		{
			Sys.println("Input directory not found: " + inputDir);
			Sys.exit(1);
		}

		if (!FileSystem.exists(outputDir))
		{
			FileSystem.createDirectory(outputDir);
		}

		processDirectory(inputDir, outputDir, blockSize, quality);
	}

	private static function processDirectory(inputDir:String, outputDir:String, blockSize:String, quality:String):Void
	{
		for (entry in FileSystem.readDirectory(inputDir))
		{
			var inputPath = inputDir + "/" + entry;

			if (FileSystem.isDirectory(inputPath))
			{
				var nestedOutput = outputDir + "/" + entry;

				if (!FileSystem.exists(nestedOutput))
				{
					FileSystem.createDirectory(nestedOutput);
				}

				processDirectory(inputPath, nestedOutput, blockSize, quality);
				continue;
			}

			if (!StringTools.endsWith(entry, ".png"))
			{
				continue;
			}

			var outputPath = outputDir + "/" + entry.substr(0, entry.length - 4) + ".astc";
			encode(inputPath, outputPath, blockSize, quality);
		}
	}

	private static function encode(inputPath:String, outputPath:String, blockSize:String, quality:String):Void
	{
		if (FileSystem.exists(outputPath) && FileSystem.stat(outputPath).mtime.getTime() >= FileSystem.stat(inputPath).mtime.getTime())
		{
			Sys.println("Skipping (up to date): " + inputPath);
			return;
		}

		Sys.println("Encoding: " + inputPath + " -> " + outputPath);

		var process = new Process("astcenc", ["-cl", inputPath, outputPath, blockSize, quality]);
		var exitCode = process.exitCode();

		if (exitCode != 0)
		{
			Sys.println("astcenc failed for " + inputPath + ":");
			Sys.println(process.stderr.readAll().toString());
		}

		process.close();
	}
}
