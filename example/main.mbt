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

      // Test physical device selection (skipping logical device creation due to vkCreateDevice issue)
      println("=== Test 2: Enumerating physical devices ===")
      let physical_device = select_physical_device(instance)

      if physical_device > 0 {
        println("Physical device enumerated successfully!")
        println("Skipping logical device creation (known vkCreateDevice issue)")
      }

      // Clean up
      destroy_vulkan_instance(instance)
    }
    InstanceError(msg) => {
      println("Error: " + msg)
    }
  }

  println("")
  println("=== MoonBit Vulkan instance test completed ===")
  println("")

  println("Now running full demo with progressive MoonBit implementation...")
  println("")

  // Step 1: Test MoonBit window creation
  println("=== Step 1: Creating window with MoonBit ===")
  match init_window("MoonBit Vulkan Triangle", 800, 600) {
    WindowCreated(window) => {
      println("Window created successfully with MoonBit! Handle: " + window.to_string())

      // For now, continue with C bridge for Vulkan rendering
      // We'll progressively replace more components

      // Enter main rendering loop using C bridge
      // vk_main_loop()

      // Cleanup
      cleanup_window(window)
    }
    WindowError(msg) => {
      println("Window creation failed: " + msg)
      println("Falling back to C bridge...")
      let initialized = vk_init("MoonBit Vulkan Triangle", 800, 600)

      if initialized {
        println("Vulkan initialized successfully with C bridge!")
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
  }
}
