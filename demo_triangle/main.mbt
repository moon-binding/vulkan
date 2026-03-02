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

  let extensions_ptr = @moonbit/vulkan.vulkan_alloc_struct(ext_count * 8)  // Array of 8-byte pointers
  copy_required_extensions(extensions_ptr)

  // Step 1: Create Vulkan Instance
  let app_info = @moonbit/vulkan.alloc_application_info()
  @moonbit/vulkan.set_application_version(app_info, 4206822)
  @moonbit/vulkan.set_engine_version(app_info, 4206822)

  let instance_info = @moonbit/vulkan.alloc_instance_create_info()
  @moonbit/vulkan.set_instance_app_info(instance_info, app_info)
  @moonbit/vulkan.set_instance_extensions(instance_info, ext_count, extensions_ptr)

  let instance_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  let result = @moonbit/vulkan.vkCreateInstance(instance_info, 0, instance_ptr)

  println("vkCreateInstance result:")
  println(result.to_string())

  if result != 0 {
    println("Failed to create Vulkan instance!")
    window_cleanup()
    return
  }

  let instance = @moonbit/vulkan.get_int64(instance_ptr, 0)
  println("Instance value:")
  println(instance.to_string())

  if instance == 0 {
    println("ERROR: Instance is null after creation!")
    window_cleanup()
    return
  }

  println("Vulkan instance created successfully")

  // Step 2: Create Surface (using C code)
  let surface_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  // Pass the instance value directly to surface_create
  let surface_ok = surface_create(instance, surface_ptr)

  if surface_ok == 0 {
    println("Failed to create surface!")
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    window_cleanup()  // Cleanup even if surface creation failed
    return
  }

  let surface = @moonbit/vulkan.get_int64(surface_ptr, 0)
  println("Surface created successfully, value: " + surface.to_string())

  // Step 3: Enumerate physical devices
  let device_count_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  let enumerate_result = @moonbit/vulkan.vkEnumeratePhysicalDevices(instance, device_count_ptr, 0)

  if enumerate_result != 0 {
    println("Failed to enumerate physical devices!")
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    window_cleanup()  // This will destroy the surface
    return
  }

  let device_count = @moonbit/vulkan.get_int32(device_count_ptr, 0)
  println("Found device count:")
  println(device_count.to_string())

  // Step 4: Enumerate and select physical device
  let physical_devices_ptr = @moonbit/vulkan.vulkan_alloc_struct(device_count * 8)
  @moonbit/vulkan.vkEnumeratePhysicalDevices(instance, device_count_ptr, physical_devices_ptr) |> ignore

  // Query properties for each device and select the best one
  // Priority: Discrete GPU > Integrated GPU > Virtual GPU > CPU
  let mut selected_device_index = 0
  let mut selected_device_score = -1
  let mut i = 0

  while i < device_count {
    let device_offset = i * 8
    let physical_device = @moonbit/vulkan.get_int64(physical_devices_ptr, device_offset)
    
    println("")
    println("Device " + i.to_string() + ":")
    
    // Get device properties
    let device_props = @moonbit/vulkan.alloc_physical_device_properties()
    @moonbit/vulkan.vkGetPhysicalDeviceProperties(physical_device, device_props)
    
    let device_type = @moonbit/vulkan.get_physical_device_type(device_props)
    
    // Print device name using C function (for debugging)
    // Temporarily disable to avoid crash
    // @moonbit/vulkan.vulkan_print_device_name(device_props)
    println("  Device Name: <printing disabled>")
    
    let mut device_type_str = "Unknown"
    if device_type == 1 {
      device_type_str = "Discrete GPU"
    } else if device_type == 0 {
      device_type_str = "Integrated GPU"
    } else if device_type == 2 {
      device_type_str = "Virtual GPU"
    } else if device_type == 3 {
      device_type_str = "CPU (lavapipe)"
    } else if device_type == 4 {
      device_type_str = "CPU (llvmpipe)"
    }
    
    println("  Type: " + device_type_str)
    
    // Calculate device score
    let mut device_score = 0
    
    if @moonbit/vulkan.is_discrete_gpu(device_type) {
      device_score = 1000  // Highest priority
    } else if @moonbit/vulkan.is_integrated_gpu(device_type) {
      device_score = 800   // Second priority
    } else if device_type == 2 {
      device_score = 400   // Virtual GPU (should be GPU but reported as virtual)
    } else if device_type == 4 {
      device_score = 50    // llvmpipe (software renderer)
    } else if @moonbit/vulkan.is_cpu_device(device_type) {
      device_score = 100   // CPU (lavapipe)
    } else {
      device_score = 0
    }
    
    println("  Device score: " + device_score.to_string())
    
    // Check if this device has better score
    if device_score > selected_device_score {
      selected_device_score = device_score
      selected_device_index = i
      println("  -> Selected as best device")
    }
    
    i = i + 1
  }

  let physical_device = @moonbit/vulkan.get_int64(physical_devices_ptr, selected_device_index * 8)
  println("")
  println("Selected physical device index: " + selected_device_index.to_string())
  println("Selected device score: " + selected_device_score.to_string())

  // Get queue family properties for the selected device
  let queue_family_count_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  // First call to get count
  @moonbit/vulkan.vkGetPhysicalDeviceQueueFamilyProperties(physical_device, queue_family_count_ptr, 0)

  let queue_family_count = @moonbit/vulkan.get_int32(queue_family_count_ptr, 0)
  println("Queue family count:")
  println(queue_family_count.to_string())
  println("Physical device: " + physical_device.to_string())

  // VkQueueFamilyProperties is 32 bytes (4 * 8), not 40
  let queue_family_properties_ptr = @moonbit/vulkan.vulkan_alloc_struct(queue_family_count * 32)

  @moonbit/vulkan.vkGetPhysicalDeviceQueueFamilyProperties(physical_device, queue_family_count_ptr, queue_family_properties_ptr)

  // Find a queue family that supports graphics
  let mut graphics_queue_family = -1
  let mut present_queue_family = -1

  let mut i = 0
  while i < queue_family_count {
    let offset = i * 32
    let queue_flags = @moonbit/vulkan.get_int32(queue_family_properties_ptr, offset)

    if (queue_flags & 1) != 0 && graphics_queue_family < 0 {
      graphics_queue_family = i
    }

    // Check presentation support
    let present_support_ptr = @moonbit/vulkan.vulkan_alloc_struct(4)
    @moonbit/vulkan.vkGetPhysicalDeviceSurfaceSupportKHR(physical_device, i, surface, present_support_ptr) |> ignore
    let present_support = @moonbit/vulkan.get_int32(present_support_ptr, 0)

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
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
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

  // Create device using direct Vulkan API binding
  // First, allocate queue priorities (float = 1.0)
  let queue_priorities = @moonbit/vulkan.vulkan_alloc_struct(4)
  @moonbit/vulkan.vulkan_set_float(queue_priorities, 0, 1.0)

  // Allocate and set device queue create info
  let queue_info = @moonbit/vulkan.alloc_device_queue_create_info()
  @moonbit/vulkan.set_queue_family_index(queue_info, graphics_queue_family)
  @moonbit/vulkan.set_queue_priorities(queue_info, queue_priorities)

  // Allocate and set device create info
  let device_info = @moonbit/vulkan.alloc_device_create_info()
  @moonbit/vulkan.set_device_queues(device_info, 1, queue_info)

  // Enable VK_KHR_swapchain extension
  // For simplicity, we'll use a pointer index system
  // The extension name string will be handled by the C wrapper
  let ext_name_ptr = @moonbit/vulkan.vulkan_create_string("VK_KHR_swapchain")
  @moonbit/vulkan.set_device_extensions(device_info, 1, ext_name_ptr)

  let device_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  let device_result = @moonbit/vulkan.vkCreateDevice(physical_device, device_info, 0, device_ptr)

  println("vkCreateDevice returned: " + device_result.to_string())

  if device_result != 0 {
    println("Failed to create logical device! Result: " + device_result.to_string())
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    window_cleanup()  // This will destroy the surface
    return
  }

  println("Logical device created successfully")

  // Get device handle
  let device = @moonbit/vulkan.get_int64(device_ptr, 0)
  println("Device handle: " + device.to_string())
  println("Device in hex: 0x" + device.to_string())

  // Get graphics queue
  let queue_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  println("Allocated queue buffer")

  println("About to call vkGetDeviceQueue with device=" + device.to_string())
  @moonbit/vulkan.vkGetDeviceQueueArray(device, graphics_queue_family, 0, queue_ptr)
  println("vkGetDeviceQueue returned")

  let graphics_queue = @moonbit/vulkan.get_int64(queue_ptr, 0)

  println("Graphics queue handle: " + graphics_queue.to_string())

  // Step 6: Query Surface Capabilities
  println("")
  println("Querying surface capabilities...")

  let surface_caps = @moonbit/vulkan.alloc_surface_capabilities()
  let caps_result = @moonbit/vulkan.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physical_device, surface, surface_caps)

  if caps_result != 0 {
    println("Failed to get surface capabilities!")
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let min_image_count = @moonbit/vulkan.get_surface_capabilities_minImageCount(surface_caps)
  let max_image_count = @moonbit/vulkan.get_surface_capabilities_maxImageCount(surface_caps)
  let current_width = @moonbit/vulkan.get_surface_capabilities_currentExtent_width(surface_caps)
  let current_height = @moonbit/vulkan.get_surface_capabilities_currentExtent_height(surface_caps)

  println("Min image count: " + min_image_count.to_string())
  println("Max image count: " + max_image_count.to_string())
  println("Current extent: " + current_width.to_string() + "x" + current_height.to_string())

  // Query surface formats
  println("")
  println("Querying surface formats...")

  let format_count_ptr = @moonbit/vulkan.vulkan_alloc_struct(4)
  let formats_result1 = @moonbit/vulkan.vkGetPhysicalDeviceSurfaceFormatsKHR(physical_device, surface, format_count_ptr, 0)

  if formats_result1 != 0 {
    println("Failed to get surface format count!")
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let format_count = @moonbit/vulkan.get_int32(format_count_ptr, 0)
  println("Surface format count: " + format_count.to_string())

  let formats_ptr = @moonbit/vulkan.vulkan_alloc_struct(format_count * 32)
  @moonbit/vulkan.vkGetPhysicalDeviceSurfaceFormatsKHR(physical_device, surface, format_count_ptr, formats_ptr) |> ignore

  let first_format = @moonbit/vulkan.alloc_surface_format()
  // For now, we'll use hardcoded B8G8R8A8_SRGB (format=43)
  let surface_format = 43  // VK_FORMAT_B8G8R8A8_SRGB
  let surface_color_space = 0  // VK_COLOR_SPACE_SRGB_NONLINEAR_KHR
  println("Using format: " + surface_format.to_string())

  // Query present modes
  println("")
  println("Querying present modes...")

  let mode_count_ptr = @moonbit/vulkan.vulkan_alloc_struct(4)
  let modes_result1 = @moonbit/vulkan.vkGetPhysicalDeviceSurfacePresentModesKHR(physical_device, surface, mode_count_ptr, 0)

  if modes_result1 != 0 {
    println("Failed to get present mode count!")
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let mode_count = @moonbit/vulkan.get_int32(mode_count_ptr, 0)
  println("Present mode count: " + mode_count.to_string())

  let modes_ptr = @moonbit/vulkan.vulkan_alloc_struct(mode_count * 4)
  @moonbit/vulkan.vkGetPhysicalDeviceSurfacePresentModesKHR(physical_device, surface, mode_count_ptr, modes_ptr) |> ignore

  // For now, use FIFO mode
  let present_mode = 1  // VK_PRESENT_MODE_FIFO_KHR
  println("Using present mode: " + present_mode.to_string())

  // Step 7: Create Swapchain
  println("")
  println("Creating swapchain...")

  let swapchain_info = @moonbit/vulkan.alloc_swapchain_create_info()
  @moonbit/vulkan.set_swapchain_surface(swapchain_info, surface)
  @moonbit/vulkan.set_swapchain_extent(swapchain_info, if current_width > 0 { current_width } else { 800 }, if current_height > 0 { current_height } else { 600 })
  let swapchain_count = if min_image_count + 1 <= max_image_count { min_image_count + 1 } else { min_image_count }
  @moonbit/vulkan.set_swapchain_min_image_count(swapchain_info, swapchain_count)

  // Need to enable VK_KHR_swapchain extension when creating device
  // For now, this will likely fail without proper device extension
  let swapchain_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  let swapchain_result = @moonbit/vulkan.vkCreateSwapchainKHR(device, swapchain_info, 0, swapchain_ptr)

  if swapchain_result != 0 {
    println("Failed to create swapchain! Result: " + swapchain_result.to_string())
    println("Note: This may fail if VK_KHR_swapchain is not enabled in device creation")
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let swapchain = @moonbit/vulkan.get_int64(swapchain_ptr, 0)
  println("Swapchain created successfully: " + swapchain.to_string())

  // Step 8: Get Swapchain Images
  println("")
  println("Getting swapchain images...")

  let swapchain_image_count_ptr = @moonbit/vulkan.vulkan_alloc_struct(4)
  let get_images_result1 = @moonbit/vulkan.vkGetSwapchainImagesKHR(device, swapchain, swapchain_image_count_ptr, 0)

  if get_images_result1 != 0 {
    println("Failed to get swapchain image count!")
    @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let swapchain_image_count = @moonbit/vulkan.get_int32(swapchain_image_count_ptr, 0)
  println("Swapchain image count: " + swapchain_image_count.to_string())

  let swapchain_images_ptr = @moonbit/vulkan.vulkan_alloc_struct(swapchain_image_count * 8)
  @moonbit/vulkan.vkGetSwapchainImagesKHR(device, swapchain, swapchain_image_count_ptr, swapchain_images_ptr) |> ignore

  // Step 9: Create Image Views
  println("")
  println("Creating image views...")

  let image_views_ptr = @moonbit/vulkan.vulkan_alloc_struct(swapchain_image_count * 8)

  let mut image_views_created = 0
  let mut i = 0
  while i < swapchain_image_count {
    let image_offset = i * 8
    let image = @moonbit/vulkan.get_int64(swapchain_images_ptr, image_offset)
    println("Image " + i.to_string() + ": " + image.to_string())

    // Create image view info
    let image_view_info = @moonbit/vulkan.alloc_image_view_info()
    @moonbit/vulkan.set_image_view_properties(image_view_info, image, surface_format, 15) // aspect_mask = VK_IMAGE_ASPECT_COLOR_BIT (15)

    let image_view_ptr_offset = i * 8
    let image_view_create_result = @moonbit/vulkan.vkCreateImageView(device, image_view_info, 0, image_views_ptr + image_view_ptr_offset)

    if image_view_create_result != 0 {
      println("Failed to create image view " + i.to_string() + "! Result: " + image_view_create_result.to_string())
      // TODO: cleanup already created image views
      @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
      @moonbit/vulkan.vkDestroyDevice(device, 0)
      window_cleanup()
      @moonbit/vulkan.vkDestroyInstance(instance, 0)
      return
    }

    image_views_created = image_views_created + 1
    i = i + 1
  }

  println("Image views created: " + image_views_created.to_string())

  // Step 10: Create Render Pass
  println("")
  println("Creating render pass...")

  // Simple render pass with single color attachment
  let render_pass_info = @moonbit/vulkan.alloc_simple_render_pass_info()
  // Set attachment description (color attachment)
  let attachment_ref = @moonbit/vulkan.vulkan_alloc_struct(16)  // sizeof(VkAttachmentReference)
  @moonbit/vulkan.put_int32(attachment_ref, 0, 0)  // attachment = 0
  @moonbit/vulkan.put_int32(attachment_ref, 4, 0)  // layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL

  let subpass_desc = @moonbit/vulkan.vulkan_alloc_struct(80)  // sizeof(VkSubpassDescription)
  @moonbit/vulkan.put_int32(subpass_desc, 0, 0)  // flags
  @moonbit/vulkan.put_int32(subpass_desc, 4, 1)  // inputAttachmentCount
  @moonbit/vulkan.put_int64(subpass_desc, 8, 0)  // pInputAttachments
  @moonbit/vulkan.put_int32(subpass_desc, 16, 1)  // colorAttachmentCount
  @moonbit/vulkan.put_int64(subpass_desc, 24, attachment_ref)  // pColorAttachments
  @moonbit/vulkan.put_int32(subpass_desc, 32, 0)  // resolveAttachmentCount
  @moonbit/vulkan.put_int64(subpass_desc, 40, 0)  // pResolveAttachments
  @moonbit/vulkan.put_int64(subpass_desc, 48, 0)  // pDepthStencilAttachment
  @moonbit/vulkan.put_int32(subpass_desc, 56, 0)  // preserveAttachmentCount
  @moonbit/vulkan.put_int64(subpass_desc, 64, 0)  // pPreserveAttachments

  @moonbit/vulkan.set_render_pass_subpasses(render_pass_info, 1, subpass_desc)
  // Note: For simplicity, we're not setting up subpass dependencies
  @moonbit/vulkan.set_render_pass_attachments(render_pass_info, 0, 0)

  let render_pass_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  let render_pass_result = @moonbit/vulkan.vkCreateRenderPass(device, render_pass_info, 0, render_pass_ptr)

  if render_pass_result != 0 {
    println("Failed to create render pass! Result: " + render_pass_result.to_string())
    // Cleanup
    let mut j = 0
    while j < image_views_created {
      let image_view_ptr_offset = j * 8
      let image_view = @moonbit/vulkan.get_int64(image_views_ptr, image_view_ptr_offset)
      if image_view != 0 {
        @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
      }
      j = j + 1
    }
    @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let render_pass = @moonbit/vulkan.get_int64(render_pass_ptr, 0)
  println("Render pass created: " + render_pass.to_string())

  // Step 11: Create Framebuffers
  println("")
  println("Creating framebuffers...")

  let framebuffers_ptr = @moonbit/vulkan.vulkan_alloc_struct(swapchain_image_count * 8)
  let mut framebuffers_created = 0

  let mut i = 0
  while i < swapchain_image_count {
    let image_view_ptr_offset = i * 8
    let image_view = @moonbit/vulkan.get_int64(image_views_ptr, image_view_ptr_offset)

    let framebuffer_info = @moonbit/vulkan.alloc_framebuffer_info()
    @moonbit/vulkan.set_framebuffer_render_pass(framebuffer_info, render_pass.to_int())
    @moonbit/vulkan.set_framebuffer_attachments(framebuffer_info, 1, image_views_ptr + image_view_ptr_offset)
    @moonbit/vulkan.set_framebuffer_size(framebuffer_info, current_width, current_height)

    let framebuffer_ptr_offset = i * 8
    let framebuffer_result = @moonbit/vulkan.vkCreateFramebuffer(device, framebuffer_info, 0, framebuffers_ptr + framebuffer_ptr_offset)

    if framebuffer_result != 0 {
      println("Failed to create framebuffer " + i.to_string() + "! Result: " + framebuffer_result.to_string())
      // Cleanup
      let mut j = 0
      while j < framebuffers_created {
        let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, j * 8)
        if fb != 0 {
          @moonbit/vulkan.vkDestroyFramebuffer(device, fb, 0)
        }
        j = j + 1
      }
      @moonbit/vulkan.vkDestroyRenderPass(device, render_pass, 0)
      let mut k = 0
      while k < image_views_created {
        let image_view = @moonbit/vulkan.get_int64(image_views_ptr, k * 8)
        if image_view != 0 {
          @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
        }
        k = k + 1
      }
      @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
      @moonbit/vulkan.vkDestroyDevice(device, 0)
      window_cleanup()
      @moonbit/vulkan.vkDestroyInstance(instance, 0)
      return
    }

    framebuffers_created = framebuffers_created + 1
    i = i + 1
  }

  println("Framebuffers created: " + framebuffers_created.to_string())

  // Step 12: Create Command Pool and Command Buffers
  println("")
  println("Creating command pool...")

  let command_pool_info = @moonbit/vulkan.vulkan_alloc_struct(48)  // sizeof(VkCommandPoolCreateInfo)
  @moonbit/vulkan.put_int32(command_pool_info, 0, 2)  // sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO
  @moonbit/vulkan.put_int64(command_pool_info, 8, 0)  // pNext
  @moonbit/vulkan.put_int32(command_pool_info, 16, 0)  // flags = 0
  @moonbit/vulkan.put_int32(command_pool_info, 24, graphics_queue_family)  // queueFamilyIndex

  let command_pool_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  let command_pool_result = @moonbit/vulkan.vkCreateCommandPool(device, command_pool_info, 0, command_pool_ptr)

  if command_pool_result != 0 {
    println("Failed to create command pool! Result: " + command_pool_result.to_string())
    // Cleanup
    let mut j = 0
    while j < framebuffers_created {
      let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, j * 8)
      if fb != 0 {
        @moonbit/vulkan.vkDestroyFramebuffer(device, fb, 0)
      }
      j = j + 1
    }
    @moonbit/vulkan.vkDestroyRenderPass(device, render_pass, 0)
    let mut k = 0
    while k < image_views_created {
      let image_view = @moonbit/vulkan.get_int64(image_views_ptr, k * 8)
      if image_view != 0 {
        @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
      }
      k = k + 1
    }
    @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let command_pool = @moonbit/vulkan.get_int64(command_pool_ptr, 0)
  println("Command pool created: " + command_pool.to_string())

  // Allocate command buffers
  let command_buffers_info = @moonbit/vulkan.vulkan_alloc_struct(32)  // sizeof(VkCommandBufferAllocateInfo)
  @moonbit/vulkan.put_int32(command_buffers_info, 0, 41)  // sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO
  @moonbit/vulkan.put_int64(command_buffers_info, 8, 0)  // pNext
  @moonbit/vulkan.put_int64(command_buffers_info, 16, command_pool.to_int())  // commandPool
  @moonbit/vulkan.put_int32(command_buffers_info, 24, 1)  // level = VK_COMMAND_BUFFER_LEVEL_PRIMARY
  @moonbit/vulkan.put_int32(command_buffers_info, 28, swapchain_image_count)  // commandBufferCount

  let command_buffers_ptr = @moonbit/vulkan.vulkan_alloc_struct(swapchain_image_count * 8)
  let allocate_result = @moonbit/vulkan.vkAllocateCommandBuffers(device, command_buffers_info, command_buffers_ptr)

  if allocate_result != 0 {
    println("Failed to allocate command buffers! Result: " + allocate_result.to_string())
    // Cleanup
    @moonbit/vulkan.vkDestroyCommandPool(device, command_pool, 0)
    let mut j = 0
    while j < framebuffers_created {
      let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, j * 8)
      if fb != 0 {
        @moonbit/vulkan.vkDestroyFramebuffer(device, fb, 0)
      }
      j = j + 1
    }
    @moonbit/vulkan.vkDestroyRenderPass(device, render_pass, 0)
    let mut k = 0
    while k < image_views_created {
      let image_view = @moonbit/vulkan.get_int64(image_views_ptr, k * 8)
      if image_view != 0 {
        @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
      }
      k = k + 1
    }
    @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  println("Command buffers allocated: " + swapchain_image_count.to_string())

  // Step 13: Create Shaders
  println("")
  println("Creating shaders...")

  // Get shader code pointers and sizes from C
  let vert_shader_ptr = get_vert_shader_ptr()
  let frag_shader_ptr = get_frag_shader_ptr()
  let vert_shader_size = get_vert_shader_size()
  let frag_shader_size = get_frag_shader_size()

  println("Vertex shader: ptr=" + vert_shader_ptr.to_string() + ", size=" + vert_shader_size.to_string())
  println("Fragment shader: ptr=" + frag_shader_ptr.to_string() + ", size=" + frag_shader_size.to_string())

  // Create vertex shader module
  let vert_shader_info = @moonbit/vulkan.alloc_shader_module_info()
  @moonbit/vulkan.set_shader_module_code(vert_shader_info, vert_shader_size, vert_shader_ptr)

  let vert_module_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  let vert_module_result = @moonbit/vulkan.vkCreateShaderModule(device, vert_shader_info, 0, vert_module_ptr)

  if vert_module_result != 0 {
    println("Failed to create vertex shader module! Result: " + vert_module_result.to_string())
    // Cleanup
    @moonbit/vulkan.vkDestroyCommandPool(device, command_pool, 0)
    let mut j = 0
    while j < framebuffers_created {
      let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, j * 8)
      if fb != 0 {
        @moonbit/vulkan.vkDestroyFramebuffer(device, fb, 0)
      }
      j = j + 1
    }
    @moonbit/vulkan.vkDestroyRenderPass(device, render_pass, 0)
    let mut k = 0
    while k < image_views_created {
      let image_view = @moonbit/vulkan.get_int64(image_views_ptr, k * 8)
      if image_view != 0 {
        @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
      }
      k = k + 1
    }
    @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let vert_module = @moonbit/vulkan.get_int64(vert_module_ptr, 0)
  println("Vertex shader module created: " + vert_module.to_string())

  // Create fragment shader module
  let frag_shader_info = @moonbit/vulkan.alloc_shader_module_info()
  @moonbit/vulkan.set_shader_module_code(frag_shader_info, frag_shader_size, frag_shader_ptr)

  let frag_module_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  let frag_module_result = @moonbit/vulkan.vkCreateShaderModule(device, frag_shader_info, 0, frag_module_ptr)

  if frag_module_result != 0 {
    println("Failed to create fragment shader module! Result: " + frag_module_result.to_string())
    // Cleanup
    @moonbit/vulkan.vkDestroyShaderModule(device, vert_module, 0)
    @moonbit/vulkan.vkDestroyCommandPool(device, command_pool, 0)
    let mut j = 0
    while j < framebuffers_created {
      let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, j * 8)
      if fb != 0 {
        @moonbit/vulkan.vkDestroyFramebuffer(device, fb, 0)
      }
      j = j + 1
    }
    @moonbit/vulkan.vkDestroyRenderPass(device, render_pass, 0)
    let mut k = 0
    while k < image_views_created {
      let image_view = @moonbit/vulkan.get_int64(image_views_ptr, k * 8)
      if image_view != 0 {
        @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
      }
      k = k + 1
    }
    @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let frag_module = @moonbit/vulkan.get_int64(frag_module_ptr, 0)
  println("Fragment shader module created: " + frag_module.to_string())

  // Step 14: Create Graphics Pipeline
  println("")
  println("Creating graphics pipeline...")

  // Create shader stage create infos
  let vert_stage_info = @moonbit/vulkan.alloc_shader_stage_info()
  let vert_shader_name = @moonbit/vulkan.vulkan_create_string("main")
  @moonbit/vulkan.set_shader_stage(vert_stage_info, 1, vert_module, vert_shader_name)  // VK_SHADER_STAGE_VERTEX_BIT = 1

  let frag_stage_info = @moonbit/vulkan.alloc_shader_stage_info()
  let frag_shader_name = @moonbit/vulkan.vulkan_create_string("main")
  @moonbit/vulkan.set_shader_stage(frag_stage_info, 2, frag_module, frag_shader_name)  // VK_SHADER_STAGE_FRAGMENT_BIT = 2

  let shader_stages_ptr = @moonbit/vulkan.vulkan_alloc_struct(96)  // 2 * 48 bytes
  // Copy shader stage infos
  @moonbit/vulkan.put_int64(shader_stages_ptr, 0, vert_stage_info)
  @moonbit/vulkan.put_int64(shader_stages_ptr, 48, frag_stage_info)

  // Create pipeline layout (no descriptors or push constants for now)
  let pipeline_layout_info = @moonbit/vulkan.alloc_pipeline_layout_info()
  let pipeline_layout_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  let pipeline_layout_result = @moonbit/vulkan.vkCreatePipelineLayout(device, pipeline_layout_info, 0, pipeline_layout_ptr)

  if pipeline_layout_result != 0 {
    println("Failed to create pipeline layout! Result: " + pipeline_layout_result.to_string())
    // Cleanup shaders
    @moonbit/vulkan.vkDestroyShaderModule(device, vert_module, 0)
    @moonbit/vulkan.vkDestroyShaderModule(device, frag_module, 0)
    @moonbit/vulkan.vkDestroyCommandPool(device, command_pool, 0)
    let mut j = 0
    while j < framebuffers_created {
      let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, j * 8)
      if fb != 0 {
        @moonbit/vulkan.vkDestroyFramebuffer(device, fb, 0)
      }
      j = j + 1
    }
    @moonbit/vulkan.vkDestroyRenderPass(device, render_pass, 0)
    let mut k = 0
    while k < image_views_created {
      let image_view = @moonbit/vulkan.get_int64(image_views_ptr, k * 8)
      if image_view != 0 {
        @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
      }
      k = k + 1
    }
    @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let pipeline_layout = @moonbit/vulkan.get_int64(pipeline_layout_ptr, 0)
  println("Pipeline layout created: " + pipeline_layout.to_string())

  // Create viewport state
  let viewport_state = @moonbit/vulkan.alloc_viewport_state_info()

  // Create input assembly state
  let input_assembly = @moonbit/vulkan.alloc_input_assembly_state_info()

  // Create rasterization state
  let rasterization = @moonbit/vulkan.alloc_rasterization_state_info()

  // Create multisample state
  let multisample = @moonbit/vulkan.alloc_multisample_state_info()

  // Create color blend state
  let color_blend = @moonbit/vulkan.alloc_color_blend_state_info()

  // Create graphics pipeline
  let pipeline_info = @moonbit/vulkan.alloc_graphics_pipeline_info()
  @moonbit/vulkan.set_pipeline_stages(pipeline_info, 2, shader_stages_ptr)
  @moonbit/vulkan.set_pipeline_viewport_state(pipeline_info, viewport_state)
  @moonbit/vulkan.set_pipeline_input_assembly_state(pipeline_info, input_assembly)
  @moonbit/vulkan.set_pipeline_rasterization_state(pipeline_info, rasterization)
  @moonbit/vulkan.set_pipeline_multisample_state(pipeline_info, multisample)
  @moonbit/vulkan.set_pipeline_color_blend_state(pipeline_info, color_blend)
  @moonbit/vulkan.set_pipeline_layout(pipeline_info, pipeline_layout.to_int())
  @moonbit/vulkan.set_pipeline_render_pass(pipeline_info, render_pass.to_int(), 0)  // subpass = 0

  let pipeline_ptr = @moonbit/vulkan.vulkan_alloc_struct(8)
  let pipeline_result = @moonbit/vulkan.vkCreateGraphicsPipelines(device, 0, 1, pipeline_info, 0, pipeline_ptr)

  if pipeline_result < 0 {
    println("Failed to create graphics pipeline! Result: " + pipeline_result.to_string())
    // Cleanup
    @moonbit/vulkan.vkDestroyPipelineLayout(device, pipeline_layout, 0)
    @moonbit/vulkan.vkDestroyShaderModule(device, vert_module, 0)
    @moonbit/vulkan.vkDestroyShaderModule(device, frag_module, 0)
    @moonbit/vulkan.vkDestroyCommandPool(device, command_pool, 0)
    let mut j = 0
    while j < framebuffers_created {
      let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, j * 8)
      if fb != 0 {
        @moonbit/vulkan.vkDestroyFramebuffer(device, fb, 0)
      }
      j = j + 1
    }
    @moonbit/vulkan.vkDestroyRenderPass(device, render_pass, 0)
    let mut k = 0
    while k < image_views_created {
      let image_view = @moonbit/vulkan.get_int64(image_views_ptr, k * 8)
      if image_view != 0 {
        @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
      }
      k = k + 1
    }
    @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let pipeline = @moonbit/vulkan.get_int64(pipeline_ptr, 0)
  println("Graphics pipeline created: " + pipeline.to_string())

  // Step 15: Create Synchronization Objects (semaphores and fences)
  println("")
  println("Creating synchronization objects...")

  let semaphores_ptr = @moonbit/vulkan.vulkan_alloc_struct(16)  // 2 semaphores (image available + render finished)
  let fences_ptr = @moonbit/vulkan.vulkan_alloc_struct(swapchain_image_count * 8)

  // Create semaphores
  let image_available_semaphore_ptr = semaphores_ptr
  let image_available_result = @moonbit/vulkan.vkCreateSemaphore(device, 0, 0, image_available_semaphore_ptr)

  let render_finished_semaphore_ptr = semaphores_ptr + 8
  let render_finished_result = @moonbit/vulkan.vkCreateSemaphore(device, 0, 0, render_finished_semaphore_ptr)

  if image_available_result != 0 || render_finished_result != 0 {
    println("Failed to create semaphores! Results: " + image_available_result.to_string() + ", " + render_finished_result.to_string())
    // Cleanup
    @moonbit/vulkan.vkDestroyPipeline(device, pipeline, 0)
    @moonbit/vulkan.vkDestroyPipelineLayout(device, pipeline_layout, 0)
    @moonbit/vulkan.vkDestroyShaderModule(device, vert_module, 0)
    @moonbit/vulkan.vkDestroyShaderModule(device, frag_module, 0)
    @moonbit/vulkan.vkDestroyCommandPool(device, command_pool, 0)
    let mut j = 0
    while j < framebuffers_created {
      let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, j * 8)
      if fb != 0 {
        @moonbit/vulkan.vkDestroyFramebuffer(device, fb, 0)
      }
      j = j + 1
    }
    @moonbit/vulkan.vkDestroyRenderPass(device, render_pass, 0)
    let mut k = 0
    while k < image_views_created {
      let image_view = @moonbit/vulkan.get_int64(image_views_ptr, k * 8)
      if image_view != 0 {
        @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
      }
      k = k + 1
    }
    @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
    @moonbit/vulkan.vkDestroyDevice(device, 0)
    window_cleanup()
    @moonbit/vulkan.vkDestroyInstance(instance, 0)
    return
  }

  let image_available_semaphore = @moonbit/vulkan.get_int64(image_available_semaphore_ptr, 0)
  let render_finished_semaphore = @moonbit/vulkan.get_int64(render_finished_semaphore_ptr, 0)
  println("Semaphores created")

  // Create fences
  let mut fences_created = 0
  let mut i = 0
  while i < swapchain_image_count {
    let fence_info = @moonbit/vulkan.vulkan_alloc_struct(24)  // sizeof(VkFenceCreateInfo)
    @moonbit/vulkan.put_int32(fence_info, 0, 9)  // sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO
    @moonbit/vulkan.put_int64(fence_info, 8, 0)  // pNext
    @moonbit/vulkan.put_int32(fence_info, 16, 1)  // flags = VK_FENCE_CREATE_SIGNALED_BIT

    let fence_ptr_offset = i * 8
    let fence_result = @moonbit/vulkan.vkCreateFence(device, fence_info, 0, fences_ptr + fence_ptr_offset)

    if fence_result != 0 {
      println("Failed to create fence " + i.to_string() + "! Result: " + fence_result.to_string())
      // Cleanup semaphores
      @moonbit/vulkan.vkDestroySemaphore(device, image_available_semaphore, 0)
      @moonbit/vulkan.vkDestroySemaphore(device, render_finished_semaphore, 0)
      // Cleanup
      @moonbit/vulkan.vkDestroyPipeline(device, pipeline, 0)
      @moonbit/vulkan.vkDestroyPipelineLayout(device, pipeline_layout, 0)
      @moonbit/vulkan.vkDestroyShaderModule(device, vert_module, 0)
      @moonbit/vulkan.vkDestroyShaderModule(device, frag_module, 0)
      @moonbit/vulkan.vkDestroyCommandPool(device, command_pool, 0)
      let mut j = 0
      while j < framebuffers_created {
        let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, j * 8)
        if fb != 0 {
          @moonbit/vulkan.vkDestroyFramebuffer(device, fb, 0)
        }
        j = j + 1
      }
      @moonbit/vulkan.vkDestroyRenderPass(device, render_pass, 0)
      let mut k = 0
      while k < image_views_created {
        let image_view = @moonbit/vulkan.get_int64(image_views_ptr, k * 8)
        if image_view != 0 {
          @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
        }
        k = k + 1
      }
      @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
      @moonbit/vulkan.vkDestroyDevice(device, 0)
      window_cleanup()
      @moonbit/vulkan.vkDestroyInstance(instance, 0)
      return
    }

    fences_created = fences_created + 1
    i = i + 1
  }

  println("Fences created: " + fences_created.to_string())

  // Step 16: Main Rendering Loop
  println("")
  println("Starting main loop...")
  println("Press Ctrl+C or close window to exit")
  println("")

  let mut current_frame = 0

  while window_should_close() == 0 {
    // Wait for fence
    let fence = @moonbit/vulkan.get_int64(fences_ptr, current_frame * 8)
    let wait_result = @moonbit/vulkan.vkWaitForFences(device, 1, fences_ptr + current_frame * 8, 1, 1000000000)  // 1 second timeout

    if wait_result != 0 {
      println("vkWaitForFences failed: " + wait_result.to_string())
    }

    // Reset fence
    @moonbit/vulkan.vkResetFences(device, 1, fences_ptr + current_frame * 8) |> ignore

    // Acquire next image from swapchain
    let image_index_ptr = @moonbit/vulkan.vulkan_alloc_struct(4)
    let acquire_result = @moonbit/vulkan.vkAcquireNextImageKHR(device, swapchain, 1000000000, image_available_semaphore, 0, image_index_ptr)

    if acquire_result == -1000000001 {
      // VK_NOT_READY - just continue
      println("Swapchain not ready, retrying...")
      continue
    }

    if acquire_result < 0 && acquire_result != -1000000004 {
      // VK_SUBOPTIMAL_KHR is acceptable
      println("vkAcquireNextImageKHR failed: " + acquire_result.to_string())
      break
    }

    let image_index = @moonbit/vulkan.get_int32(image_index_ptr, 0)

    // Record command buffer
    let command_buffer = @moonbit/vulkan.get_int64(command_buffers_ptr, image_index * 8)

    // Begin command buffer
    let begin_info = @moonbit/vulkan.alloc_command_buffer_begin_info()
    let begin_result = @moonbit/vulkan.vkBeginCommandBuffer(command_buffer, begin_info)

    if begin_result != 0 {
      println("vkBeginCommandBuffer failed: " + begin_result.to_string())
      break
    }

    // Begin render pass
    let render_pass_begin = @moonbit/vulkan.alloc_render_pass_begin_info()
    let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, image_index * 8)
    @moonbit/vulkan.set_render_pass(render_pass_begin, render_pass)
    @moonbit/vulkan.set_framebuffer(render_pass_begin, fb)
    @moonbit/vulkan.set_render_area(render_pass_begin, 0, 0, current_width, current_height)
    @moonbit/vulkan.vkCmdBeginRenderPass(command_buffer, render_pass_begin, 0)  // VK_SUBPASS_CONTENTS_INLINE = 0

    // Bind pipeline
    @moonbit/vulkan.vkCmdBindPipeline(command_buffer, 0, pipeline)  // VK_PIPELINE_BIND_POINT_GRAPHICS = 0

    // Draw triangle (3 vertices)
    @moonbit/vulkan.vkCmdDraw(command_buffer, 3, 1, 0, 0)

    // End render pass
    @moonbit/vulkan.vkCmdEndRenderPass(command_buffer)

    // End command buffer
    let end_result = @moonbit/vulkan.vkEndCommandBuffer(command_buffer)

    if end_result != 0 {
      println("vkEndCommandBuffer failed: " + end_result.to_string())
      break
    }

    // Submit command buffer
    let submit_info = @moonbit/vulkan.vulkan_alloc_struct(64)  // sizeof(VkSubmitInfo)
    @moonbit/vulkan.put_int32(submit_info, 0, 5)  // sType = VK_STRUCTURE_TYPE_SUBMIT_INFO
    @moonbit/vulkan.put_int64(submit_info, 8, 0)  // pNext
    @moonbit/vulkan.put_int32(submit_info, 16, 1)  // waitSemaphoreCount
    @moonbit/vulkan.put_int64(submit_info, 24, image_available_semaphore_ptr)  // pWaitSemaphores
    @moonbit/vulkan.put_int64(submit_info, 32, 1)  // pWaitDstStageMask (VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT = 0x80)
    @moonbit/vulkan.put_int32(submit_info, 40, 1)  // commandBufferCount
    @moonbit/vulkan.put_int64(submit_info, 48, command_buffers_ptr + image_index * 8)  // pCommandBuffers
    @moonbit/vulkan.put_int32(submit_info, 56, 1)  // signalSemaphoreCount
    @moonbit/vulkan.put_int64(submit_info, 64, render_finished_semaphore_ptr)  // pSignalSemaphores

    let submit_result = @moonbit/vulkan.vkQueueSubmit(graphics_queue, 1, submit_info, 0)

    if submit_result != 0 {
      println("vkQueueSubmit failed: " + submit_result.to_string())
      break
    }

    // Present image
    let present_info = @moonbit/vulkan.vulkan_alloc_struct(32)  // sizeof(VkPresentInfoKHR)
    @moonbit/vulkan.put_int32(present_info, 0, 1000001001)  // sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR
    @moonbit/vulkan.put_int64(present_info, 8, 0)  // pNext
    @moonbit/vulkan.put_int32(present_info, 16, 1)  // waitSemaphoreCount
    @moonbit/vulkan.put_int64(present_info, 24, render_finished_semaphore_ptr)  // pWaitSemaphores
    @moonbit/vulkan.put_int32(present_info, 32, 1)  // swapchainCount
    @moonbit/vulkan.put_int64(present_info, 40, swapchain_ptr)  // pSwapchains
    @moonbit/vulkan.put_int32(present_info, 48, 1)  // pImageIndices (use image_index directly)
    @moonbit/vulkan.put_int32(present_info, 52, 0)  // results

    let present_result = @moonbit/vulkan.vkQueuePresentKHR(graphics_queue, present_info)

    if present_result == -1000000001 {
      // VK_NOT_READY - acceptable
      println("Present not ready")
    } else if present_result < 0 {
      println("vkQueuePresentKHR failed: " + present_result.to_string())
      break
    }

    current_frame = (current_frame + 1) % swapchain_image_count

    // Poll window events
    window_poll_events()
  }

  println("Main loop ended")

  // Cleanup
  println("")
  println("Starting cleanup...")

  // Wait for device to finish
  @moonbit/vulkan.vkDeviceWaitIdle(device) |> ignore

  // Destroy fences
  let mut i = 0
  while i < fences_created {
    let fence = @moonbit/vulkan.get_int64(fences_ptr, i * 8)
    if fence != 0 {
      @moonbit/vulkan.vkDestroyFence(device, fence, 0)
    }
    i = i + 1
  }
  println("Fences destroyed")

  // Destroy semaphores
  @moonbit/vulkan.vkDestroySemaphore(device, image_available_semaphore, 0)
  @moonbit/vulkan.vkDestroySemaphore(device, render_finished_semaphore, 0)
  println("Semaphores destroyed")

  // Destroy pipeline
  @moonbit/vulkan.vkDestroyPipeline(device, pipeline, 0)
  println("Pipeline destroyed")

  // Destroy pipeline layout
  @moonbit/vulkan.vkDestroyPipelineLayout(device, pipeline_layout, 0)
  println("Pipeline layout destroyed")

  // Destroy shader modules
  @moonbit/vulkan.vkDestroyShaderModule(device, vert_module, 0)
  @moonbit/vulkan.vkDestroyShaderModule(device, frag_module, 0)
  println("Shader modules destroyed")

  // Destroy command pool (this will free command buffers)
  @moonbit/vulkan.vkDestroyCommandPool(device, command_pool, 0)
  println("Command pool destroyed")

  // Destroy framebuffers
  let mut j = 0
  while j < framebuffers_created {
    let fb = @moonbit/vulkan.get_int64(framebuffers_ptr, j * 8)
    if fb != 0 {
      @moonbit/vulkan.vkDestroyFramebuffer(device, fb, 0)
    }
    j = j + 1
  }
  println("Framebuffers destroyed")

  // Destroy render pass
  @moonbit/vulkan.vkDestroyRenderPass(device, render_pass, 0)
  println("Render pass destroyed")

  // Destroy image views
  let mut k = 0
  while k < image_views_created {
    let image_view = @moonbit/vulkan.get_int64(image_views_ptr, k * 8)
    if image_view != 0 {
      @moonbit/vulkan.vkDestroyImageView(device, image_view, 0)
    }
    k = k + 1
  }
  println("Image views destroyed")

  @moonbit/vulkan.vkDestroySwapchainKHR(device, swapchain, 0)
  println("Swapchain destroyed")
  @moonbit/vulkan.vkDestroyDevice(device, 0)
  println("Device destroyed")

  // Cleanup window and surface BEFORE destroying instance
  window_cleanup()  // This will destroy the surface
  println("Window and surface cleaned up")

  // Now safe to destroy the instance
  @moonbit/vulkan.vkDestroyInstance(instance, 0)
  println("Instance destroyed")

  println("Cleanup complete")
}
