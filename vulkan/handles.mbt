///|
/// MoonBit Vulkan SDK Bindings - Handle Types
/// Vulkan handle types are opaque types for Vulkan objects

// Note: Using Int64 for all handle types to represent opaque pointers on 64-bit systems
// In native compilation, these are mapped to void* in C

// Instance handles
pub type VkInstance = Int64
pub type VkPhysicalDevice = Int64

// Device handles
pub type VkDevice = Int64
pub type VkQueue = Int64

// Command buffer handles
pub type VkCommandPool = Int64
pub type VkCommandBuffer = Int64

// Memory handles
pub type VkDeviceMemory = Int64

// Buffer handles
pub type VkBuffer = Int64

// Image handles
pub type VkImage = Int64

// Image view handles
pub type VkImageView = Int64

// Shader handles
pub type VkShaderModule = Int64

// Pipeline handles
pub type VkPipeline = Int64
pub type VkPipelineLayout = Int64
pub type VkPipelineCache = Int64

// Render pass handles
pub type VkRenderPass = Int64

// Framebuffer handles
pub type VkFramebuffer = Int64

// Descriptor handles
pub type VkDescriptorPool = Int64
pub type VkDescriptorSet = Int64
pub type VkDescriptorSetLayout = Int64

// Query pool handles
pub type VkQueryPool = Int64

// Buffer view handles
pub type VkBufferView = Int64

// Sampler handles
pub type VkSampler = Int64

// Fence handles
pub type VkFence = Int64

// Semaphore handles
pub type VkSemaphore = Int64

// Event handles
pub type VkEvent = Int64

// Surface handles
pub type VkSurfaceKHR = Int64

// Swapchain handles
pub type VkSwapchainKHR = Int64

// Debug handles
pub type VkDebugReportCallbackEXT = Int64
pub type VkDebugUtilsMessengerEXT = Int64

// Null handle helper - returns 0L as a null handle
pub fn null_handle() -> Int64 {
  0L
}
