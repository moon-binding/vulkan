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

  println("Now running full demo with progressive MoonBit implementation...")
  println("")

  // Step 1: Test MoonBit window creation
  println("=== Step 1: Creating window with MoonBit ===")
  match init_window("MoonBit Vulkan Triangle", 800, 600) {
    WindowCreated(window) => {
      println("Window created successfully with MoonBit! Handle: " + window.to_string())

      // Test MoonBit Vulkan instance creation
      println("=== Step 2: Creating Vulkan instance with MoonBit ===")
      let instance_result = create_vulkan_instance()

      match instance_result {
        InstanceCreated(instance) => {
          println("Instance created! Handle: " + instance.to_string())

          // Test MoonBit surface creation
          println("=== Step 3: Creating Vulkan surface with MoonBit ===")
          match create_surface(instance, window) {
            SurfaceCreated(surface) => {
              println("Surface created! Handle: " + surface.to_string())

              // For now, we'll stop here and cleanup
              // Next phases will implement device creation and rendering
              println("Phase 1-3 complete: Window, Instance, and Surface creation in MoonBit!")
              println("")
              println("Progress summary:")
              println("  ✓ GLFW window creation - MoonBit")
              println("  ✓ Vulkan instance creation - MoonBit")
              println("  ✓ Surface creation - MoonBit")
            }
            SurfaceError(msg) => {
              println("Surface creation failed: " + msg)
            }
          }

          // Cleanup
          destroy_vulkan_instance(instance)
        }
        InstanceError(msg) => {
          println("Instance creation failed: " + msg)
        }
      }

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
