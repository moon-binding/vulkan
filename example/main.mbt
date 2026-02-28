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
