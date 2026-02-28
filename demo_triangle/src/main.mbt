///|
/// MoonBit Vulkan Triangle Demo
/// Simple triangle rendering using MoonBit Vulkan bindings

// External functions for window and surface management
extern "C" fn window_init(width : Int, height : Int, title : String) -> Int = "window_init"
extern "C" fn get_required_extensions_count() -> Int = "get_required_extensions_count"
extern "C" fn copy_required_extensions(names_ptr : Int) -> Unit = "copy_required_extensions"
extern "C" fn surface_create(instance : Int64, surface_ptr_idx : Int) -> Int = "surface_create"
extern "C" fn window_poll_events() -> Unit = "window_poll_events"
extern "C" fn window_should_close() -> Int = "window_should_close"
extern "C" fn window_cleanup() -> Unit = "window_cleanup"

// Function pointers to shader code (defined in C)
extern "C" fn get_vert_shader_ptr() -> Int = "get_vert_shader_ptr"
extern "C" fn get_frag_shader_ptr() -> Int = "get_frag_shader_ptr"
extern "C" fn get_vert_shader_size() -> Int = "get_vert_shader_size"
extern "C" fn get_frag_shader_size() -> Int = "get_frag_shader_size"

// Main entry point
fn main() -> Unit {
  println("MoonBit Vulkan Triangle Demo")
  println("============================")
  println("")

  // Initialize window
  let title = "Vulkan Triangle"
  let window_ok = window_init(800, 600, title)

  if window_ok == 0 {
    println("Failed to initialize window!")
    return
  }

  println("Window initialized successfully")

  // Get required extensions from GLFW
  let ext_count = get_required_extensions_count()
  println("Required extension count:")
  println(ext_count.to_string())

  let extensions_ptr = @vulkan.vulkan_alloc_struct(ext_count * 8)  // Array of 8-byte pointers
  copy_required_extensions(extensions_ptr)

  // Step 1: Create Vulkan Instance
  let app_info = @vulkan.alloc_application_info()
  @vulkan.set_application_version(app_info, 4206822)
  @vulkan.set_engine_version(app_info, 4206822)

  let instance_info = @vulkan.alloc_instance_create_info()
  @vulkan.set_instance_app_info(instance_info, app_info)
  @vulkan.set_instance_extensions(instance_info, ext_count, extensions_ptr)

  let instance_ptr = @vulkan.vulkan_alloc_struct(8)
  let result = @vulkan.vkCreateInstance(instance_info, 0, instance_ptr)

  println("vkCreateInstance result:")
  println(result.to_string())

  if result != 0 {
    println("Failed to create Vulkan instance!")
    window_cleanup()
    return
  }

  let instance = @vulkan.get_int64(instance_ptr, 0)
  println("Instance value:")
  println(instance.to_string())

  if instance == 0 {
    println("ERROR: Instance is null after creation!")
    window_cleanup()
    return
  }

  println("Vulkan instance created successfully")

  // Step 2: Create Surface (using C code)
  let surface_ptr = @vulkan.vulkan_alloc_struct(8)
  // Pass the instance value directly to surface_create
  let surface_ok = surface_create(instance, surface_ptr)

  if surface_ok == 0 {
    println("Failed to create surface!")
    @vulkan.vkDestroyInstance(instance, 0)
    window_cleanup()  // Cleanup even if surface creation failed
    return
  }

  let surface = @vulkan.get_int64(surface_ptr, 0)
  println("Surface created successfully, value: " + surface.to_string())

  // Step 3: Enumerate physical devices
  let device_count_ptr = @vulkan.vulkan_alloc_struct(8)
  let enumerate_result = @vulkan.vkEnumeratePhysicalDevices(instance, device_count_ptr, 0)

  if enumerate_result != 0 {
    println("Failed to enumerate physical devices!")
    @vulkan.vkDestroyInstance(instance, 0)
    window_cleanup()  // This will destroy the surface
    return
  }

  let device_count = @vulkan.get_int32(device_count_ptr, 0)
  println("Found device count:")
  println(device_count.to_string())

  // Step 4: Select first physical device and create logical device
  let physical_devices_ptr = @vulkan.vulkan_alloc_struct(device_count * 8)
  @vulkan.vkEnumeratePhysicalDevices(instance, device_count_ptr, physical_devices_ptr) |> ignore

  // Try second device (index 1) instead of first - first device (RTX 4080) has driver issues
  let physical_device = @vulkan.get_int64(physical_devices_ptr, if device_count > 1 { 8 } else { 0 })
  println("Selected physical device:")
  println(physical_device.to_string())

  // Get queue family properties using array version
  let queue_family_count_ptr = @vulkan.vulkan_alloc_struct(8)
  // First call to get count
  @vulkan.vkGetPhysicalDeviceQueueFamilyPropertiesArray(physical_devices_ptr, 1, queue_family_count_ptr, 0)

  let queue_family_count = @vulkan.get_int32(queue_family_count_ptr, 0)
  println("Queue family count:")
  println(queue_family_count.to_string())

  let queue_family_properties_ptr = @vulkan.vulkan_alloc_struct(queue_family_count * 40) // approximate size

  @vulkan.vkGetPhysicalDeviceQueueFamilyPropertiesArray(physical_devices_ptr, 1, queue_family_count_ptr, queue_family_properties_ptr)

  // Find a queue family that supports graphics
  let mut graphics_queue_family = -1
  let mut present_queue_family = -1

  let mut i = 0
  while i < queue_family_count {
    let offset = i * 40
    let queue_flags = @vulkan.get_int32(queue_family_properties_ptr, offset)

    if (queue_flags & 1) != 0 && graphics_queue_family < 0 {
      graphics_queue_family = i
    }

    // Check presentation support
    let present_support_ptr = @vulkan.vulkan_alloc_struct(4)
    @vulkan.vkGetPhysicalDeviceSurfaceSupportKHRArray(physical_devices_ptr, 1, i, surface, present_support_ptr) |> ignore
    let present_support = @vulkan.get_int32(present_support_ptr, 0)

    if present_support != 0 && present_queue_family < 0 {
      present_queue_family = i
    }

    if graphics_queue_family >= 0 && present_queue_family >= 0 {
      break
    }

    i = i + 1
  }

  if graphics_queue_family < 0 {
    println("No graphics queue family found!")
    @vulkan.vkDestroyInstance(instance, 0)
    window_cleanup()  // This will destroy the surface
    return
  }

  println("Graphics queue family:")
  println(graphics_queue_family.to_string())
  println("Present queue family:")
  println(present_queue_family.to_string())

  // Step 5: Create Logical Device
  println("")
  println("Attempting to create logical device...")

  let device_ptr = @vulkan.vulkan_alloc_struct(8)
  println("Allocated device buffer")

  let device_result = @vulkan.vkCreateDeviceDirect(physical_device, graphics_queue_family, device_ptr)

  println("vkCreateDevice returned: " + device_result.to_string())

  if device_result != 0 {
    println("Failed to create logical device! Result: " + device_result.to_string())
    @vulkan.vkDestroyInstance(instance, 0)
    window_cleanup()  // This will destroy the surface
    return
  }

  println("Logical device created successfully")

  // Get device handle
  let device = @vulkan.get_int64(device_ptr, 0)
  println("Device handle: " + device.to_string())
  println("Device in hex: 0x" + device.to_string())

  // Get graphics queue
  let queue_ptr = @vulkan.vulkan_alloc_struct(8)
  println("Allocated queue buffer")

  println("About to call vkGetDeviceQueue with device=" + device.to_string())
  @vulkan.vkGetDeviceQueueArray(device, graphics_queue_family, 0, queue_ptr)
  println("vkGetDeviceQueue returned")

  let graphics_queue = @vulkan.get_int64(queue_ptr, 0)

  println("Graphics queue handle: " + graphics_queue.to_string())

  // Step 6: Create Swapchain (simplified for now)
  // TODO: Query surface capabilities and create proper swapchain
  println("")
  println("Basic Vulkan initialization completed successfully!")
  println("Note: Full triangle rendering requires more implementation.")
  println("")

  // Cleanup
  @vulkan.vkDestroyDevice(device, 0)
  @vulkan.vkDestroySurfaceKHR(instance, surface, 0)
  @vulkan.vkDestroyInstance(instance, 0)
  window_cleanup()
  println("Cleanup complete")
}
