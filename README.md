# MoonBit Vulkan SDK Bindings

Complete Vulkan SDK bindings for MoonBit, providing direct mappings to Vulkan C API without abstraction.

## Project Structure

```
vulkan/
├── src/
│   ├── core.mbt          # Core types and result codes
│   ├── handles.mbt       # Vulkan handle types
│   ├── constants.mbt    # Vulkan constants
│   ├── enums.mbt        # Vulkan enum types
│   ├── structs.mbt      # Vulkan structure types
│   └── commands.mbt     # Vulkan API commands
├── example/             # Demo applications
└── README.md           # This file
```

## Building

```bash
moon build
```

## Usage

```moonbit
import "moonbit/vulkan"

fn main() -> Unit {
  // TODO: Add usage examples
}
```

## License

MIT

## Vulkan Version

Targeting Vulkan 1.3+

## Status

Currently in active development. See implementation progress in project issues.
