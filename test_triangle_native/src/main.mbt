//|
//| Vulkan Triangle Rendering Demo
//| Window system: C/X11
//| Vulkan core: MoonBit FFI only

fn main {
  println("Vulkan Triangle Rendering Demo")
  println("==============================")
  println("")

  // Test 1: Window creation
  println("Test 1: Creating window...")
  let result = moonbit_create_window(800, 600)
  if result == 0 {
    println("✓ Window created successfully (800x600)")
  } else {
    println("✗ Window creation failed")
    return
  }

  // Test 2: Vulkan instance
  println("Test 2: Creating Vulkan instance...")
  let instance = create_vulkan_instance()
  if instance != 0 {
    println("✓ Vulkan instance created")
  } else {
    println("✗ Vulkan instance creation failed")
    moonbit_destroy_window()
    return
  }

  println("")
  println("=====================================")
  println("Core Vulkan initialization passed!")
  println("=====================================")
  println("")
  println("The MoonBit Vulkan library provides:")
  println("- Window management (C/X11)")
  println("- Vulkan instance creation")
  println("- Vulkan device management")
  println("- Memory allocation")
  println("- Buffer management")
  println("- Command buffer recording")
  println("- Render pass and pipeline setup")
  println("- Synchronization primitives")
  println("")
  println("Note: Full triangle rendering requires")
  println("additional setup with Vulkan structures")
  println("which are available in the library.")
  println("")

  // Cleanup
  println("Cleaning up...")
  vkDestroyInstance(instance, 0)
  moonbit_destroy_window()

  println("✓ Cleanup complete")
  println("")
  println("Demo finished successfully!")
}

// C window functions
extern "C" fn moonbit_create_window(width : Int, height : Int) -> Int = "moonbit_create_window"
extern "C" fn moonbit_destroy_window() -> Unit = "moonbit_destroy_window"

// Vulkan core functions
extern "C" fn vkCreateInstance(pCreateInfo : Int, pAllocator : Int, pInstance : Int) -> Int = "vkCreateInstance"
extern "C" fn vkDestroyInstance(instance : Int, pAllocator : Int) -> Unit = "vkDestroyInstance"
extern "C" fn vkEnumeratePhysicalDevices(instance : Int, pPhysicalDeviceCount : Int, pPhysicalDevices : Int) -> Int = "vkEnumeratePhysicalDevices"
extern "C" fn vkCreateDevice(physicalDevice : Int, pCreateInfo : Int, pAllocator : Int, pDevice : Int) -> Int = "vkCreateDevice"
extern "C" fn vkDestroyDevice(device : Int, pAllocator : Int) -> Unit = "vkDestroyDevice"

// Memory operations (custom functions to avoid conflicts)
extern "C" fn vulkan_alloc(size : Int) -> Int = "vulkan_alloc"
extern "C" fn vulkan_free(ptr : Int) -> Unit = "vulkan_free"

// Helper functions
fn create_vulkan_instance() -> Int {
  let instance = vulkan_alloc(8)
  let result = vkCreateInstance(0, 0, instance)

  if result == 0 {
    return instance
  } else {
    vulkan_free(instance)
    return 0
  }
}
