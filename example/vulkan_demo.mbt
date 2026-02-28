// MoonBit Vulkan FFI Bindings
// C FFI declarations for Vulkan bridge functions

// Initialize Vulkan with window
#borrow(appName)
extern "C" fn vk_init(appName : String, width : Int, height : Int) -> Bool =
  "moonbit_vk_init"

// Window functions
extern "C" fn vk_window_should_close() -> Bool =
  "moonbit_vk_window_should_close"

extern "C" fn vk_poll_events() -> Unit =
  "moonbit_vk_poll_events"

extern "C" fn vk_wait_events() -> Unit =
  "moonbit_vk_wait_events"

// Rendering
extern "C" fn vk_draw_frame() -> Unit =
  "moonbit_vk_draw_frame"

// Cleanup
extern "C" fn vk_cleanup() -> Unit =
  "moonbit_vk_cleanup"

// Main loop
extern "C" fn vk_main_loop() -> Unit =
  "moonbit_vk_main_loop"
