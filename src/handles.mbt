///|
/// MoonBit Vulkan SDK Bindings - Handle Types
/// Vulkan handle types are opaque types for Vulkan objects

// Note: Using Int for all handle types to represent opaque pointers
// In native compilation, these are mapped to void* in C

// Instance handles
pub type VkInstance = Int
pub type VkPhysicalDevice = Int

// Device handles
pub type VkDevice = Int
pub type VkQueue = Int

// Command buffer handles
pub type VkCommandPool = Int
pub type VkCommandBuffer = Int

// Memory handles
pub type VkDeviceMemory = Int

// Buffer handles
pub type VkBuffer = Int

// Image handles
pub type VkImage = Int

// Image view handles
pub type VkImageView = Int

// Shader handles
pub type VkShaderModule = Int

// Pipeline handles
pub type VkPipeline = Int
pub type VkPipelineLayout = Int
pub type VkPipelineCache = Int

// Render pass handles
pub type VkRenderPass = Int

// Framebuffer handles
pub type VkFramebuffer = Int

// Descriptor handles
pub type VkDescriptorPool = Int
pub type VkDescriptorSet = Int
pub type VkDescriptorSetLayout = Int

// Query pool handles
pub type VkQueryPool = Int

// Buffer view handles
pub type VkBufferView = Int

// Sampler handles
pub type VkSampler = Int

// Fence handles
pub type VkFence = Int

// Semaphore handles
pub type VkSemaphore = Int

// Event handles
pub type VkEvent = Int

// Surface handles
pub type VkSurfaceKHR = Int

// Swapchain handles
pub type VkSwapchainKHR = Int

// Debug handles
pub type VkDebugReportCallbackEXT = Int
pub type VkDebugUtilsMessengerEXT = Int

// Null handle helper - returns 0 as a null handle
pub fn null_handle() -> Int {
  0
}
