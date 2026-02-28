// Vulkan C FFI Bridge for MoonBit
// Direct bindings to Vulkan C API for MoonBit

#include <moonbit.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <vulkan/vulkan.h>

// All Vulkan handles are passed as void* pointers (MoonBit #external type)
// All Vulkan structures are passed as void* pointers
// VkResult is returned as int32_t

// Pointer table to store 64-bit pointers with 32-bit indices
#define MAX_PTRS 10000
static void* ptr_table[MAX_PTRS];
static int32_t ptr_count = 0;

// Helper: Add pointer to table and return index
static int32_t ptr_to_index(void* ptr) {
    if (!ptr) return -1;
    if (ptr_count >= MAX_PTRS) {
        fprintf(stderr, "ERROR: Pointer table full!\n");
        return -1;
    }
    ptr_table[ptr_count] = ptr;
    return ptr_count++;
}

// Helper: Get pointer from index
static void* index_to_ptr(int32_t idx) {
    if (idx < 0 || idx >= MAX_PTRS) return NULL;
    return ptr_table[idx];
}

// Allocate memory for structures
int32_t vulkan_alloc_struct(int32_t size) {
    void* ptr = malloc((size_t)size);
    return ptr_to_index(ptr);
}

// Free structure memory
void vulkan_free_struct(int32_t idx) {
    void* ptr = index_to_ptr(idx);
    if (ptr) {
        free(ptr);
        ptr_table[idx] = NULL;
    }
}

// Memory access helpers for structure fields
void vulkan_put_int32(int32_t idx, int32_t offset, int32_t value) {
    void* ptr = index_to_ptr(idx);
    if (ptr) {
        *(int32_t*)((uint8_t*)ptr + offset) = value;
    }
}

void vulkan_put_int64(int32_t idx, int32_t offset, int64_t value) {
    void* ptr = index_to_ptr(idx);
    if (ptr) {
        *(int64_t*)((uint8_t*)ptr + offset) = value;
    }
}

// Put int64 value from low/high parts (for MoonBit Int64)
void vulkan_put_int64_lh(int32_t idx, int32_t offset, int32_t low, int32_t high) {
    void* ptr = index_to_ptr(idx);
    if (ptr) {
        uint64_t value = ((uint64_t)(uint32_t)high << 32) | (uint64_t)(uint32_t)low;
        *(int64_t*)((uint8_t*)ptr + offset) = (int64_t)value;
    }
}

int32_t vulkan_get_int32(int32_t idx, int32_t offset) {
    void* ptr = index_to_ptr(idx);
    if (ptr) {
        return *(int32_t*)((uint8_t*)ptr + offset);
    }
    return 0;
}

int64_t vulkan_get_int64(int32_t idx, int32_t offset) {
    void* ptr = index_to_ptr(idx);
    if (ptr) {
        return *(int64_t*)((uint8_t*)ptr + offset);
    }
    return 0;
}

// String creation helper
int32_t vulkan_create_string(const char* s) {
    if (!s) return -1;
    size_t len = strlen(s);
    char* str = malloc(len + 1);
    if (str) {
        strcpy(str, s);
        return ptr_to_index(str);
    }
    return -1;
}

void vulkan_free_string(int32_t idx) {
    void* ptr = index_to_ptr(idx);
    if (ptr) {
        free(ptr);
        ptr_table[idx] = NULL;
    }
}

// Load C string back to MoonBit (simplified - returns pointer)
int32_t vulkan_load_c_string(int32_t ptr) {
    return ptr;
}

// Set extension name in array
void vulkan_set_extension_name(int32_t array, int32_t index, int32_t name) {
    void* ptr = index_to_ptr(array);
    void* name_ptr = index_to_ptr(name);
    if (ptr) {
        int32_t* dst = (int32_t*)((uint8_t*)ptr + (index * 8));
        *dst = (int32_t)(intptr_t)name_ptr;
    }
}

// Set float array value
void vulkan_set_float_array_value(int32_t array, int32_t index, float value) {
    void* ptr = index_to_ptr(array);
    if (ptr) {
        float* dst = (float*)((uint8_t*)ptr + (index * 4));
        *dst = value;
    }
}

// Set float value in struct
void vulkan_set_float(int32_t idx, int32_t offset, float value) {
    void* ptr = index_to_ptr(idx);
    if (ptr) {
        float* fptr = (float*)((uint8_t*)ptr + offset);
        *fptr = value;
    }
}

// Set pointer field in struct (by index)
void vulkan_set_ptr(int32_t idx, int32_t offset, int32_t ptr_idx) {
    void* ptr = index_to_ptr(idx);
    void* target = index_to_ptr(ptr_idx);
    if (ptr) {
        *(int64_t*)((uint8_t*)ptr + offset) = (int64_t)(intptr_t)target;
    }
}

// Vulkan API wrappers - these functions bridge MoonBit indices to Vulkan pointers

// vkCreateInstance wrapper
int32_t vulkan_vkCreateInstance(int32_t create_info_idx, int32_t allocator, int32_t instance_idx) {
    void* create_info = index_to_ptr(create_info_idx);
    void* instance_ptr = index_to_ptr(instance_idx);

    printf("DEBUG: vkCreateInstance called\n");

    if (create_info) {
        const VkInstanceCreateInfo* ci = (const VkInstanceCreateInfo*)create_info;
        printf("  enabledExtensionCount: %u\n", ci->enabledExtensionCount);
        if (ci->ppEnabledExtensionNames && ci->enabledExtensionCount > 0) {
            for (uint32_t i = 0; i < ci->enabledExtensionCount; i++) {
                printf("    Extension %u: %s\n", i, ci->ppEnabledExtensionNames[i]);
            }
        }
    }

    fflush(stdout);

    VkResult result = vkCreateInstance((const VkInstanceCreateInfo*)create_info, NULL, (VkInstance*)instance_ptr);

    printf("  Result: %d\n", result);
    fflush(stdout);

    return (int32_t)result;
}

// vkDestroyInstance wrapper - accepts int64 handle directly
void vulkan_vkDestroyInstance(int64_t instance, int32_t allocator) {
    VkInstance instance_ptr = (VkInstance)(uintptr_t)instance;
    vkDestroyInstance(instance_ptr, NULL);
}

// vkEnumeratePhysicalDevices wrapper - accepts int64 handle directly
int32_t vulkan_vkEnumeratePhysicalDevices(int64_t instance, int32_t count_idx, int32_t devices_idx) {
    VkInstance instance_ptr = (VkInstance)(uintptr_t)instance;
    uint32_t* count_ptr = index_to_ptr(count_idx);
    VkPhysicalDevice* devices_ptr = index_to_ptr(devices_idx);

    VkResult result = vkEnumeratePhysicalDevices(instance_ptr, count_ptr, devices_ptr);

    return (int32_t)result;
}

// vkGetPhysicalDeviceQueueFamilyProperties wrapper - accepts index of buffer containing device handle
void vulkan_vkGetPhysicalDeviceQueueFamilyProperties(int64_t device, int32_t count_idx, int32_t props_idx) {
    VkPhysicalDevice device_ptr = (VkPhysicalDevice)(uintptr_t)device;
    uint32_t* count_ptr = index_to_ptr(count_idx);
    VkQueueFamilyProperties* props_ptr = index_to_ptr(props_idx);
    vkGetPhysicalDeviceQueueFamilyProperties(device_ptr, count_ptr, props_ptr);
}

// vkGetPhysicalDeviceQueueFamilyProperties wrapper - accepts array index and device index
void vulkan_vkGetPhysicalDeviceQueueFamilyPropertiesArray(int32_t devices_idx, int32_t device_index, int32_t count_idx, int32_t props_idx) {
    void* devices_buffer = index_to_ptr(devices_idx);
    VkPhysicalDevice device = NULL;
    if (devices_buffer) {
        VkPhysicalDevice* devices = (VkPhysicalDevice*)devices_buffer;
        device = devices[device_index];
    }
    uint32_t* count_ptr = index_to_ptr(count_idx);
    VkQueueFamilyProperties* props_ptr = index_to_ptr(props_idx);
    vkGetPhysicalDeviceQueueFamilyProperties(device, count_ptr, props_ptr);
}

// vkGetPhysicalDeviceSurfaceSupportKHR wrapper
int32_t vulkan_vkGetPhysicalDeviceSurfaceSupportKHR(int64_t device, int32_t index, int64_t surface, int32_t support_idx) {
    VkPhysicalDevice device_ptr = (VkPhysicalDevice)(uintptr_t)device;
    VkSurfaceKHR surf_ptr = (VkSurfaceKHR)(uintptr_t)surface;

    VkBool32* support_ptr = index_to_ptr(support_idx);
    return (int32_t)vkGetPhysicalDeviceSurfaceSupportKHR(device_ptr, index, surf_ptr, support_ptr);
}

// vkGetPhysicalDeviceSurfaceSupportKHR wrapper - accepts array index and device index
int32_t vulkan_vkGetPhysicalDeviceSurfaceSupportKHRArray(int32_t devices_idx, int32_t device_index, int32_t index, int64_t surface, int32_t support_idx) {
    void* devices_buffer = index_to_ptr(devices_idx);
    VkPhysicalDevice device_ptr = NULL;
    if (devices_buffer) {
        VkPhysicalDevice* devices = (VkPhysicalDevice*)devices_buffer;
        device_ptr = devices[device_index];
    }

    VkSurfaceKHR surf_ptr = (VkSurfaceKHR)(uintptr_t)surface;
    VkBool32* support_ptr = index_to_ptr(support_idx);

    VkResult result = vkGetPhysicalDeviceSurfaceSupportKHR(device_ptr, index, surf_ptr, support_ptr);

    return (int32_t)result;
}

// vkDestroySurfaceKHR wrapper
void vulkan_vkDestroySurfaceKHR(int32_t instance_idx, int32_t surface_idx, int32_t allocator) {
    void* instance_buffer = index_to_ptr(instance_idx);
    VkInstance instance = instance_buffer ? *(VkInstance*)instance_buffer : NULL;

    void* surface_buffer = index_to_ptr(surface_idx);
    VkSurfaceKHR surf = surface_buffer ? *(VkSurfaceKHR*)surface_buffer : (VkSurfaceKHR)(uintptr_t)surface_idx;

    vkDestroySurfaceKHR(instance, surf, NULL);
}

// vkCreateSurfaceKHR wrapper
int32_t vulkan_vkCreateSurfaceKHR(int32_t instance_idx, int32_t create_info, int32_t allocator, int32_t surface_idx) {
    VkInstance instance = (VkInstance)index_to_ptr(instance_idx);
    VkSurfaceKHR* surface_ptr = index_to_ptr(surface_idx);
    // Note: This function should be called with actual surface creation logic
    // For now, we'll assume the surface is created elsewhere
    return (int32_t)VK_SUCCESS;
}

// vkCreateDevice wrapper - accepts array index and device index
int32_t vulkan_vkCreateDeviceArray(int32_t devices_idx, int32_t device_index, int32_t create_info_idx, int32_t allocator, int32_t device_idx) {
    printf("DEBUG: vkCreateDeviceArray called\n");
    printf("  devices_idx: %d, device_index: %d, create_info_idx: %d, device_idx: %d\n",
           devices_idx, device_index, create_info_idx, device_idx);

    void* devices_buffer = index_to_ptr(devices_idx);
    VkPhysicalDevice physical_device = NULL;
    if (devices_buffer) {
        VkPhysicalDevice* devices = (VkPhysicalDevice*)devices_buffer;
        physical_device = devices[device_index];
    }

    void* create_info = index_to_ptr(create_info_idx);
    void* device_buffer = index_to_ptr(device_idx);

    printf("  physical_device: %p, create_info: %p, device_buffer: %p\n",
           (void*)physical_device, create_info, device_buffer);

    // Hack: Use a static queue priority value
    static float queue_priority = 1.0f;

    // Create a queue create info structure
    static VkDeviceQueueCreateInfo queue_ci;
    queue_ci.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
    queue_ci.pNext = NULL;
    queue_ci.flags = 0;
    queue_ci.queueFamilyIndex = 0;  // Will be set below
    queue_ci.queueCount = 1;
    queue_ci.pQueuePriorities = &queue_priority;

    VkDeviceCreateInfo* device_ci = (VkDeviceCreateInfo*)create_info;

    printf("  queueCreateInfoCount: %u\n", device_ci->queueCreateInfoCount);

    // Set the queue family index from the original structure
    if (device_ci->queueCreateInfoCount > 0) {
        // Get the queue create info index stored at offset 32
        int32_t queue_info_idx = *(int32_t*)((uint8_t*)create_info + 32);
        printf("  queue_info_idx: %d\n", queue_info_idx);

        void* queue_info_ptr = index_to_ptr(queue_info_idx);
        if (queue_info_ptr) {
            int32_t queue_family = *(int32_t*)((uint8_t*)queue_info_ptr + 24);
            printf("  queue_family from info: %d\n", queue_family);
            queue_ci.queueFamilyIndex = (uint32_t)queue_family;
        }

        // Point to our static queue info
        device_ci->pQueueCreateInfos = &queue_ci;
        printf("  set pQueueCreateInfos to %p\n", (void*)&queue_ci);
    }

    // Clear extension count for now (swapchain will be added later)
    device_ci->enabledExtensionCount = 0;

    fflush(stdout);

    VkResult result = vkCreateDevice(physical_device, (const VkDeviceCreateInfo*)create_info, NULL, (VkDevice*)device_buffer);

    printf("  Result: %d\n", result);
    fflush(stdout);

    return (int32_t)result;
}

// Simplified version that takes queue family index directly
int32_t vulkan_vkCreateDeviceArraySimple(int32_t devices_idx, int32_t device_index, int32_t queue_family, int32_t create_info_idx, int32_t allocator, int32_t device_idx) {
    printf("DEBUG: vkCreateDeviceArraySimple called - queue_family: %d\n", queue_family);

    void* devices_buffer = index_to_ptr(devices_idx);
    VkPhysicalDevice physical_device = NULL;
    if (devices_buffer) {
        VkPhysicalDevice* devices = (VkPhysicalDevice*)devices_buffer;
        physical_device = devices[device_index];
    }

    void* create_info = index_to_ptr(create_info_idx);
    void* device_buffer = index_to_ptr(device_idx);

    // Create queue create info on stack
    float queue_priority = 1.0f;
    VkDeviceQueueCreateInfo queue_ci;
    queue_ci.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
    queue_ci.pNext = NULL;
    queue_ci.flags = 0;
    queue_ci.queueFamilyIndex = (uint32_t)queue_family;
    queue_ci.queueCount = 1;
    queue_ci.pQueuePriorities = &queue_priority;

    // Create physical device features on stack (initialize all fields to 0)
    VkPhysicalDeviceFeatures features;
    memset(&features, 0, sizeof(VkPhysicalDeviceFeatures));

    // No extensions for now - keep it simple
    const char* device_extensions[] = { NULL };

    // Create device create info on stack instead of modifying buffer
    VkDeviceCreateInfo device_ci;
    device_ci.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
    device_ci.pNext = NULL;
    device_ci.flags = 0;
    device_ci.queueCreateInfoCount = 1;
    device_ci.pQueueCreateInfos = &queue_ci;
    device_ci.enabledLayerCount = 0;
    device_ci.ppEnabledLayerNames = NULL;
    device_ci.enabledExtensionCount = 0;
    device_ci.ppEnabledExtensionNames = NULL;
    device_ci.pEnabledFeatures = VK_NULL_HANDLE;  // Use NULL instead of &features

    printf("  Calling vkCreateDevice with physical_device: %p\n", (void*)physical_device);
    printf("  device_ci.pQueueCreateInfos: %p\n", (void*)device_ci.pQueueCreateInfos);
    printf("  device_ci.pEnabledFeatures: %p\n", (void*)device_ci.pEnabledFeatures);
    fflush(stdout);

    VkResult result = vkCreateDevice(physical_device, (const VkDeviceCreateInfo*)&device_ci, NULL, (VkDevice*)device_buffer);

    printf("  vkCreateDevice result: %d\n", result);
    fflush(stdout);

    return (int32_t)result;
}

// vkGetDeviceQueue wrapper - accepts device buffer index
void vulkan_vkGetDeviceQueueArray(int32_t device_idx, int32_t queue_family, int32_t queue_index, int32_t queue_out_idx) {
    void* device_buffer = index_to_ptr(device_idx);
    VkDevice device = device_buffer ? *(VkDevice*)device_buffer : NULL;

    void* queue_buffer = index_to_ptr(queue_out_idx);

    vkGetDeviceQueue(device, queue_family, queue_index, (VkQueue*)queue_buffer);
}

// vkDestroyDevice wrapper - accepts device buffer index
void vulkan_vkDestroyDevice(int32_t device_idx, int32_t allocator) {
    void* device_buffer = index_to_ptr(device_idx);
    VkDevice device = device_buffer ? *(VkDevice*)device_buffer : NULL;
    vkDestroyDevice(device, NULL);
}
