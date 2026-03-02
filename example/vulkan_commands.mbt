///|
/// Vulkan Command Pool/Buffer and Sync Objects Module - Phase 12 & 13
/// Command pool, command buffers, and synchronization objects

// Bridge function for MoonBit command pool creation
extern "C" fn vk_create_command_pool_bridge(device : Int64, queueFamily : Int) -> Int64 = "moonbit_vk_create_command_pool_bridge"

// Bridge function for MoonBit command buffers creation
extern "C" fn vk_create_command_buffers_bridge(device : Int64, commandPool : Int64, imageCount : Int) -> Int64 = "moonbit_vk_create_command_buffers_bridge"

// Bridge function for MoonBit sync objects creation
extern "C" fn vk_create_sync_objects_bridge(device : Int64) -> Int64 = "moonbit_vk_create_sync_objects_bridge"

// Bridge function to destroy command pool
extern "C" fn vk_destroy_command_pool_bridge(device : Int64, commandPool : Int64, commandBuffers : Int64) -> Int = "moonbit_vk_destroy_command_pool_bridge"

// Bridge function to destroy sync objects
extern "C" fn vk_destroy_sync_objects_bridge(device : Int64, syncObjects : Int64) -> Int = "moonbit_vk_destroy_sync_objects_bridge"

// Result type for command pool creation
pub enum CommandPoolResult {
  CommandPoolCreated(Int64, Int64)  // (commandPool, commandBuffers pointer)
  CommandPoolError(String)
}

// Result type for sync objects creation
pub enum SyncObjectsResult {
  SyncObjectsCreated(Int64)  // Sync objects pointer
  SyncObjectsError(String)
}

// Create command pool using C bridge
pub fn create_command_pool(device : Int64, queue_family : Int, image_count : Int) -> CommandPoolResult {
  println("Creating command pool...")

  let command_pool = vk_create_command_pool_bridge(device, queue_family)

  if command_pool == 0 {
    return CommandPoolError("Failed to create command pool")
  }

  println("Creating command buffers...")
  let command_buffers = vk_create_command_buffers_bridge(device, command_pool, image_count)

  if command_buffers == 0 {
    return CommandPoolError("Failed to create command buffers")
  }

  println("Command pool and buffers created!")
  CommandPoolCreated(command_pool, command_buffers)
}

// Destroy command pool
pub fn destroy_command_pool(device : Int64, command_pool : Int64, command_buffers : Int64) -> Unit {
  if command_pool != 0 {
    let _ = vk_destroy_command_pool_bridge(device, command_pool, command_buffers)
    println("Command pool destroyed")
  }
}

// Create sync objects using C bridge
pub fn create_sync_objects(device : Int64) -> SyncObjectsResult {
  println("Creating sync objects...")

  let result = vk_create_sync_objects_bridge(device)

  if result == 0 {
    return SyncObjectsError("Failed to create sync objects")
  }

  println("Sync objects created!")
  SyncObjectsCreated(result)
}

// Destroy sync objects
pub fn destroy_sync_objects(device : Int64, sync_objects : Int64) -> Unit {
  if sync_objects != 0 {
    let _ = vk_destroy_sync_objects_bridge(device, sync_objects)
    println("Sync objects destroyed")
  }
}
