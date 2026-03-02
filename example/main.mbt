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

              // Test physical device selection
              println("=== Step 4: Selecting physical device ===")
              let physical_device = select_physical_device(instance)

              if physical_device > 0 {
                println("Physical device selected! Handle: " + physical_device.to_string())

                // Find queue families
                println("=== Step 5: Finding queue families ===")
                let (graphics_family, present_family) = find_queue_families(physical_device, surface)

                if graphics_family >= 0 && present_family >= 0 {
                  println("Queue families found!")

                  // Create logical device
                  println("=== Step 6: Creating logical device ===")
                  let device = vk_create_logical_device_bridge(physical_device, graphics_family, present_family)

                  if device > 0 {
                    println("Logical device created! Handle: " + device.to_string())

                    // Create swapchain
                    println("=== Step 7: Creating swapchain ===")
                    match create_swapchain(physical_device, device, surface) {
                      SwapchainCreated(swapchain, image_count, width, height, format) => {
                        println("Swapchain created! Handle: " + swapchain.to_string())

                        // Create image views
                        println("=== Step 8: Creating image views ===")
                        match create_image_views(device, swapchain, format, image_count) {
                          ImageViewsCreated(image_views, _) => {
                            println("Image views created! Pointer: " + image_views.to_string())

                            // Create render pass
                            println("=== Step 9: Creating render pass ===")
                            match create_render_pass(device, format) {
                              RenderPassCreated(render_pass) => {
                                println("Render pass created! Handle: " + render_pass.to_string())

                                // Create graphics pipeline
                                println("=== Step 10: Creating graphics pipeline ===")
                                match create_graphics_pipeline(device, render_pass, width, height) {
                                  GraphicsPipelineCreated(pipeline, pipeline_layout) => {
                                    println("Graphics pipeline created! Handle: " + pipeline.to_string())

                                    // Create framebuffers
                                    println("=== Step 11: Creating framebuffers ===")
                                    match create_framebuffers(device, render_pass, image_views, image_count, width, height) {
                                      FramebuffersCreated(framebuffers, _) => {
                                        println("Framebuffers created!")

                                        // Create command pool and buffers
                                        println("=== Step 12: Creating command pool and buffers ===")
                                        match create_command_pool(device, graphics_family, image_count) {
                                          CommandPoolCreated(command_pool, command_buffers) => {
                                            println("Command pool created!")

                                            // Create sync objects
                                            println("=== Step 13: Creating sync objects ===")
                                            match create_sync_objects(device) {
                                              SyncObjectsCreated(sync_objects) => {
                                                println("Sync objects created!")

                                                println("")
                                                println("Progress summary:")
                                                println("  ✓ GLFW window creation - MoonBit")
                                                println("  ✓ Vulkan instance creation - MoonBit")
                                                println("  ✓ Surface creation - MoonBit")
                                                println("  ✓ Physical device selection - MoonBit")
                                                println("  ✓ Queue family enumeration - MoonBit")
                                                println("  ✓ Logical device creation - MoonBit")
                                                println("  ✓ Swapchain creation - MoonBit")
                                                println("  ✓ Image views creation - MoonBit")
                                                println("  ✓ Render pass creation - MoonBit")
                                                println("  ✓ Graphics pipeline creation - MoonBit")
                                                println("  ✓ Framebuffers creation - MoonBit")
                                                println("  ✓ Command pool/buffers creation - MoonBit")
                                                println("  ✓ Sync objects creation - MoonBit")
                                                println("")
                                                println("Phase 1-13 complete!")

                                                // Cleanup sync objects
                                                destroy_sync_objects(device, sync_objects)
                                              }
                                              SyncObjectsError(msg) => {
                                                println("Failed to create sync objects: " + msg)
                                              }
                                            }

                                            // Cleanup command pool
                                            destroy_command_pool(device, command_pool, command_buffers)
                                          }
                                          CommandPoolError(msg) => {
                                            println("Failed to create command pool: " + msg)
                                          }
                                        }

                                        // Cleanup framebuffers
                                        destroy_framebuffers(device, framebuffers, image_count)
                                      }
                                      FramebuffersError(msg) => {
                                        println("Failed to create framebuffers: " + msg)
                                      }
                                    }

                                    // Cleanup graphics pipeline
                                    destroy_graphics_pipeline(device, pipeline, pipeline_layout)
                                  }
                                  GraphicsPipelineError(msg) => {
                                    println("Failed to create graphics pipeline: " + msg)
                                  }
                                }

                                // Cleanup render pass
                                destroy_render_pass(device, render_pass)
                              }
                              RenderPassError(msg) => {
                                println("Failed to create render pass: " + msg)
                              }
                            }

                            // Cleanup image views
                            destroy_image_views(device, image_views, image_count)
                          }
                          ImageViewsError(msg) => {
                            println("Failed to create image views: " + msg)
                          }
                        }

                        // Cleanup swapchain
                        destroy_swapchain(device, swapchain)
                      }
                      SwapchainError(msg) => {
                        println("Failed to create swapchain: " + msg)
                      }
                    }
                  } else {
                    println("Failed to create logical device")
                  }
                } else {
                  println("Failed to find queue families")
                }
              } else {
                println("Failed to select physical device")
              }
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
