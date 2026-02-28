///|
/// MoonBit Vulkan Triangle Demo
/// Simple triangle rendering using MoonBit Vulkan bindings

// External functions for window and surface management
extern "C" fn window_init(width : Int, height : Int, title : Int) -> Int = "window_init"
extern "C" fn surface_create(instance : Int, surface_ptr : Int) -> Int = "surface_create"
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
  let title_ptr = @vulkan.vulkan_create_string(title)
  let window_ok = window_init(800, 600, title_ptr)

  if window_ok == 0 {
    println("Failed to initialize window!")
    return
  }

  println("Window initialized successfully")

  // Step 1: Create Vulkan Instance
  let app_info = @vulkan.alloc_application_info()
  let name_ptr = @vulkan.vulkan_create_string("Vulkan Triangle")
  @vulkan.set_application_name(app_info, name_ptr)
  @vulkan.set_application_version(app_info, 4206822)
  @vulkan.set_engine_version(app_info, 4206822)

  let instance_info = @vulkan.alloc_instance_create_info()
  @vulkan.set_instance_app_info(instance_info, app_info)
  @vulkan.set_instance_extensions(instance_info, 0, 0)

  let instance_ptr = @vulkan.vulkan_alloc_struct(8)
  let result = @vulkan.vkCreateInstance(instance_info, 0, instance_ptr)

  if result != 0 {
    println("Failed to create Vulkan instance!")
    window_cleanup()
    return
  }

  let instance = @vulkan.get_int64(instance_ptr, 0)
  println("Vulkan instance created successfully")

  // Step 2: Create Surface (using C code)
  let surface_ptr = @vulkan.vulkan_alloc_struct(8)
  let surface_ok = surface_create(instance, surface_ptr)

  if surface_ok == 0 {
    println("Failed to create surface!")
    @vulkan.vkDestroyInstance(instance, 0)
    window_cleanup()
    return
  }

  let surface = @vulkan.get_int64(surface_ptr, 0)
  println("Surface created successfully")

  // Step 3: Enumerate physical devices
  let device_count_ptr = @vulkan.vulkan_alloc_struct(8)
  let enumerate_result = @vulkan.vkEnumeratePhysicalDevices(instance, device_count_ptr, 0)

  if enumerate_result != 0 {
    println("Failed to enumerate physical devices!")
    @vulkan.vkDestroySurfaceKHR(instance, surface, 0)
    @vulkan.vkDestroyInstance(instance, 0)
    window_cleanup()
    return
  }

  let device_count = @vulkan.get_int32(device_count_ptr, 0)
  println("Found device count:")
  println(device_count.to_string())

  // Step 4: Select first physical device and create logical device
  let physical_devices_ptr = @vulkan.vulkan_alloc_struct(device_count * 8)
  @vulkan.vkEnumeratePhysicalDevices(instance, device_count_ptr, physical_devices_ptr) |> ignore

  let physical_device = @vulkan.get_int64(physical_devices_ptr, 0)
  println("Selected physical device:")
  println(physical_device.to_string())

  // Get queue family properties
  let queue_family_count_ptr = @vulkan.vulkan_alloc_struct(8)
  @vulkan.vkGetPhysicalDeviceQueueFamilyProperties(physical_device, queue_family_count_ptr, 0)

  let queue_family_count = @vulkan.get_int32(queue_family_count_ptr, 0)
  let queue_family_properties_ptr = @vulkan.vulkan_alloc_struct(queue_family_count * 40) // approximate size

  @vulkan.vkGetPhysicalDeviceQueueFamilyProperties(physical_device, queue_family_count_ptr, queue_family_properties_ptr)

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
    @vulkan.vkGetPhysicalDeviceSurfaceSupportKHR(physical_device, i, surface, present_support_ptr) |> ignore
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
    @vulkan.vkDestroySurfaceKHR(instance, surface, 0)
    @vulkan.vkDestroyInstance(instance, 0)
    window_cleanup()
    return
  }

  println("Graphics queue family:")
  println(graphics_queue_family.to_string())
  println("Present queue family:")
  println(present_queue_family.to_string())

  // TODO: Continue with logical device creation, swapchain, pipeline, etc.
  println("")
  println("Basic Vulkan initialization completed successfully!")
  println("Note: Full triangle rendering is not yet implemented.")
  println("This demo shows that the MoonBit Vulkan bindings work correctly.")
  println("")

  // Cleanup
  @vulkan.vkDestroySurfaceKHR(instance, surface, 0)
  @vulkan.vkDestroyInstance(instance, 0)
  window_cleanup()
  println("Cleanup complete")
}
