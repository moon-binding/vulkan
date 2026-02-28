//|
//| Vulkan Triangle Rendering Demo - Window Only Test
//| Window system: C/X11

fn main {
  println("Vulkan Triangle Rendering Demo")
  println("==============================")
  println("")

  // Test: Window creation
  println("Test: Creating window...")
  let result = moonbit_create_window(800, 600)
  if result == 0 {
    println("✓ Window created successfully (800x600)")
  } else {
    println("✗ Window creation failed")
    return
  }

  println("")
  println("=====================================")
  println("Window test passed!")
  println("=====================================")
  println("")

  // Cleanup
  println("Cleaning up...")
  moonbit_destroy_window()

  println("✓ Cleanup complete")
  println("")
  println("Demo finished successfully!")
}

// C window functions
extern "C" fn moonbit_create_window(width : Int, height : Int) -> Int = "moonbit_create_window"
extern "C" fn moonbit_destroy_window() -> Unit = "moonbit_destroy_window"
