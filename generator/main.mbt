// Main generator program

import "xml_parser" as xml
import "vk_parser" as vk
import "moonbit_gen" as gen
import "moonbit/io" as io
import "moonbit/core" as core

fn main() {
  let args = core::get_args()

  let xml_path = match core::get_at(args, 1) {
    None => {
      io::println("Usage: generator <vk.xml> [output_file]")
      return
    }
    Some(p) => p
  }

  let output_path = core::get_at(args, 2).unwrap_or("target/vulkan.mbt")

  io::println("Reading XML from: " + xml_path)

  let content = match io::read_file(xml_path) {
    Ok(c) => c
    Err(e) => {
      io::println("Error reading file: " + e)
      return
    }
  }

  io::println("Parsing Vulkan registry...")

  let registry = match vk::parse_vk_registry(content) {
    Ok(r) => r
    Err(e) => {
      io::println("Error parsing XML: " + e)
      return
    }
  }

  io::println("  - Enums: " + core::int_to_string(registry.enums.length))
  io::println("  - Structs: " + core::int_to_string(registry.structs.length))
  io::println("  - Handles: " + core::int_to_string(registry.handles.length))
  io::println("  - Commands: " + core::int_to_string(registry.commands.length))

  // MVP: Only generate minimal subset
  let selected_types = [
    "VkResult",
    "VkInstance",
    "VkPhysicalDevice",
    "VkApplicationInfo",
    "VkInstanceCreateInfo",
    "VkStructureType"
  ]

  let selected_commands = [
    "vkCreateInstance",
    "vkEnumeratePhysicalDevices"
  ]

  io::println("Generating MoonBit bindings...")
  let generated = gen::generate_bindings(registry, selected_types, selected_commands)

  io::println("Writing to: " + output_path)

  match io::write_file(output_path, generated) {
    Ok(_) => io::println("Done!")
    Err(e) => io::println("Error writing file: " + e)
  }
}
