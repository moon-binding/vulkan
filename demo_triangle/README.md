# MoonBit Vulkan Triangle Demo

This is a demo program that shows how to use the MoonBit Vulkan bindings to render a triangle.

## Requirements

- MoonBit compiler
- Vulkan SDK installed at `~/Source/sdk/vulkan/default`
- GLFW library
- C compiler (gcc or clang)

## Building

```bash
cd demo_triangle
moon build --target native
```

## Running

```bash
moon run --target native
```

## Current Status

This demo currently shows basic Vulkan initialization:
- Window creation using GLFW
- Vulkan instance creation
- Surface creation (via C code)
- Physical device enumeration and selection
- Queue family detection

Full triangle rendering is under development and will be implemented in future commits.

## Project Structure

- `src/main.mbt` - Main MoonBit code using Vulkan bindings
- `src/window.c` - C code for window and surface management (GLFW)
- `src/moon.pkg.json` - Package configuration with native linking

## Vulkan Binding Library

The main Vulkan binding library is located in the `src/` directory of the parent project. It provides:
- Complete Vulkan API FFI bindings
- Vulkan types and structures
- Helper functions for Vulkan object creation

## Notes

- Surface creation uses C code (GLFW) as requested
- All other Vulkan functionality uses the MoonBit Vulkan bindings
- This is a work-in-progress demo to demonstrate the bindings
