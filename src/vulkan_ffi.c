// Vulkan C FFI Bridge for MoonBit
// Direct bindings to Vulkan C API for MoonBit

#include <vulkan/vulkan.h>
#include <moonbit.h>

// All Vulkan handles are passed as void* pointers (MoonBit #external type)
// All Vulkan structures are passed as void* pointers
// VkResult is returned as int32_t
