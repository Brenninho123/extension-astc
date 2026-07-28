# extension-astc

A Haxe extension for loading and using [ASTC](https://www.khronos.org/opengl/wiki/ASTC_Texture_Compression) (Adaptive Scalable Texture Compression) compressed textures, built on top of [Lime](https://lime.software).

ASTC lets you ship GPU-compressed textures with a much smaller footprint than uncompressed PNGs, while decoding directly on the GPU at render time. This library parses `.astc` files and uploads them straight to an OpenGL texture, without any CPU-side decompression.

## Features

- Parses standard `.astc` file headers (magic number, block dimensions, image dimensions)
- Supports all 14 ASTC 2D block sizes (4x4 through 12x12)
- Uploads compressed data directly via `glCompressedTexImage2D`, no software decoding
- Minimal dependencies — only requires Lime

## Requirements

- A GPU/driver with support for `GL_KHR_texture_compression_astc_ldr` (most Android and iOS devices from the last several years, Apple Silicon Macs, and many desktop GPUs)
- No fallback for unsupported hardware yet — see [Limitations](#limitations)

## Installation

```bash
haxelib git extension-astc https://github.com/Brenninho123/extension-astc
```

## Usage

### Low-level: raw GL texture

```haxe
import extension.astc.ASTC;
import lime.utils.Assets;

var bytes = Assets.getBytes("assets/texture.astc");
var texture = ASTC.createTexture(bytes);
```

### High-level: `GraphicASTC` wrapper

```haxe
import astc.GraphicASTC;

var graphic = GraphicASTC.fromFile("assets/texture.astc");

trace(graphic.width, graphic.height);

// when done with it
graphic.dispose();
```

## Producing `.astc` files

This library only handles loading — it does not encode textures. To generate `.astc` files from PNGs, use ARM's [astcenc](https://github.com/ARM-software/astc-encoder):

```bash
astcenc -cl input.png output.astc 6x6 -medium
```

Pick a block size that balances quality and file size for your use case (smaller blocks = higher quality, larger files).

## Limitations

- No sRGB profile support yet (only linear RGBA formats)
- No fallback path for platforms/GPUs without native ASTC support (Flash, HTML5, and older desktop GPUs will fail to create the texture)
- 3D textures are parsed but not currently uploaded (`blockDepth`/`depth` are read but unused)

## License

Licensed under the Apache-2.0 License. See [LICENSE](LICENSE) for details.
