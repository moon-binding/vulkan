///|
/// MoonBit Vulkan Triangle Demo
/// A native program that renders a colorful triangle using Vulkan

fn print_banner() -> Unit {
  println("============================================================")
  println("       MoonBit Native Vulkan Triangle Demo")
  println("============================================================")
  println("")
  println("This demo shows a triangle rendered with Vulkan API")
  println("bound through MoonBit's C FFI.")
  println("")
  println("Triangle vertices:")
  println("  - Top: (0.0, -0.5) - Red")
  println("  - Right: (0.5, 0.5) - Green")
  println("  - Left: (-0.5, 0.5) - Blue")
  println("")
  println("Press Ctrl+C or close window to exit.")
  println("============================================================")
  println("")
}

fn main() -> Unit {
  print_banner()

  // Test MoonBit Vulkan instance creation
  println("=== Test 1: Creating Vulkan instance with MoonBit ===")
  let instance_result = create_vulkan_instance()

  match instance_result {
    InstanceCreated(instance) => {
      println("Success! Instance handle: " + instance.to_string())
      println("")

      // Test physical device selection
      println("=== Test 2: Selecting physical device and creating logical device ===")
      let device_result = initialize_device(instance)

      match device_result {
        DeviceSelected(physical_device, logical_device) => {
          println("Success!")
          println("Physical device: " + physical_device.to_string())
          println("Logical device: " + logical_device.to_string())
          println("")

          // Clean up
          destroy_logical_device(logical_device)
        }
        DeviceError(msg) => {
          println("Error: " + msg)
        }
      }

      // Clean up
      destroy_vulkan_instance(instance)
    }
    InstanceError(msg) => {
      println("Error: " + msg)
    }
  }

  println("")
  println("=== MoonBit Vulkan device initialization test completed ===")
  println("")

  println("Now running original demo with C FFI...")
  println("")

  // Initialize Vulkan with 800x600 window
  let initialized = vk_init("MoonBit Vulkan Triangle", 800, 600)

  if initialized {
    println("Vulkan initialized successfully!")
    println("Starting render loop...")
    println("")

    // Enter main rendering loop
    vk_main_loop()

    // Cleanup
    vk_cleanup()
    println("Application terminated normally.")
  } else {
    println("Failed to initialize Vulkan!")
    println("Make sure you have:")
    println("  - A Vulkan-compatible GPU")
    println("  - Vulkan drivers installed")
    println("  - GLFW library available")
  }
}
