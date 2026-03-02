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
static void* ptr_table[MAX_PTRS] = {0};  // Explicitly initialize to NULL
static int32_t ptr_count = 0;

// Helper: Add pointer to table and return index
static int32_t ptr_to_index(void* ptr) {
    if (!ptr) return -1;
    if (ptr_count >= MAX_PTRS) {
        fprintf(stderr, "ERROR: Pointer table full! ptr_count=%d, MAX_PTRS=%d\n", ptr_count, MAX_PTRS);
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
    void* ptr = calloc(1, (size_t)size);  // Use calloc to zero-initialize
    int32_t idx = ptr_to_index(ptr);
    printf("DEBUG: alloc_struct size=%d, ptr=%p, idx=%d\n", size, ptr, idx);
    fflush(stdout);
    return idx;
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
    printf("DEBUG: vulkan_create_string called with s = %p\n", (void*)s);
    if (!s) {
        printf("  s is NULL\n");
        return -1;
    }
    printf("  s as string = %s\n", s);
    size_t len = strlen(s);
    printf("  strlen(s) = %zu\n", len);
    char* str = malloc(len + 1);
    if (str) {
        strcpy(str, s);
        printf("  Copied string: %s\n", str);
        int32_t idx = ptr_to_index(str);
        printf("  Returning index = %d\n", idx);
        return idx;
    }
    printf("  malloc failed!\n");
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
    printf("DEBUG: vulkan_set_ptr called: idx=%d, offset=%d, ptr_idx=%d\n", idx, offset, ptr_idx);
    void* ptr = index_to_ptr(idx);
    void* target = index_to_ptr(ptr_idx);
    printf("  ptr = %p, target = %p\n", ptr, target);

    // Print target memory for debugging
    if (ptr_idx >= 0 && target) {
        // Print first few bytes of target to see if it's initialized correctly
        uint8_t* bytes = (uint8_t*)target;
        printf("  First 8 bytes of target: %02x %02x %02x %02x %02x %02x %02x %02x\n",
               bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7]);
        uint32_t* u32ptr = (uint32_t*)target;
        printf("  As uint32: %u, %u\n", u32ptr[0], u32ptr[1]);
    }

    if (ptr) {
        *(int64_t*)((uint8_t*)ptr + offset) = (int64_t)(intptr_t)target;
        printf("  Stored target = %ld (0x%lx) at offset %d\n", (int64_t)(intptr_t)target, (int64_t)(intptr_t)target, offset);
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
    printf("DEBUG: vkEnumeratePhysicalDevices called with instance=%p, count_idx=%d, devices_idx=%d\n",
           (void*)(uintptr_t)instance, count_idx, devices_idx);
    fflush(stdout);

    VkInstance instance_ptr = (VkInstance)(uintptr_t)instance;
    uint32_t* count_ptr = index_to_ptr(count_idx);

    // If devices_idx is 0, treat it as NULL for first call to get count only
    VkPhysicalDevice* devices_ptr = (devices_idx == 0) ? NULL : index_to_ptr(devices_idx);

    printf("  instance_ptr: %p, count_ptr: %p, devices_ptr: %p\n",
           (void*)instance_ptr, (void*)count_ptr, (void*)devices_ptr);
    fflush(stdout);

    VkResult result = vkEnumeratePhysicalDevices(instance_ptr, count_ptr, devices_ptr);

    printf("  result: %d\n", result);
    if (count_ptr) {
        printf("  *count_ptr: %u\n", *count_ptr);
    }
    fflush(stdout);

    return (int32_t)result;
}

// vkGetPhysicalDeviceProperties wrapper
void vulkan_vkGetPhysicalDeviceProperties(int64_t physical_device, int32_t properties_idx) {
    VkPhysicalDevice device = (VkPhysicalDevice)(uintptr_t)physical_device;
    VkPhysicalDeviceProperties* props = (VkPhysicalDeviceProperties*)index_to_ptr(properties_idx);
    vkGetPhysicalDeviceProperties(device, props);
}

// vkGetPhysicalDeviceQueueFamilyProperties wrapper - accepts index of buffer containing device handle
void vulkan_vkGetPhysicalDeviceQueueFamilyProperties(int64_t device, int32_t count_idx, int32_t props_idx) {
    VkPhysicalDevice device_ptr = (VkPhysicalDevice)(uintptr_t)device;
    uint32_t* count_ptr = index_to_ptr(count_idx);
    // If props_idx is 0, treat it as NULL for first call to get count only
    VkQueueFamilyProperties* props_ptr = (props_idx == 0) ? NULL : index_to_ptr(props_idx);
    
    vkGetPhysicalDeviceQueueFamilyProperties(device_ptr, count_ptr, props_ptr);
}

// vkGetPhysicalDeviceQueueFamilyProperties wrapper - accepts array index and device index
void vulkan_vkGetPhysicalDeviceQueueFamilyPropertiesArray(int32_t devices_idx, int32_t device_index, int32_t count_idx, int32_t props_idx) {
    printf("DEBUG: vkGetPhysicalDeviceQueueFamilyPropertiesArray called with devices_idx=%d, device_index=%d, count_idx=%d, props_idx=%d\n",
           devices_idx, device_index, count_idx, props_idx);

    void* devices_buffer = index_to_ptr(devices_idx);
    VkPhysicalDevice device = NULL;
    if (devices_buffer) {
        VkPhysicalDevice* devices = (VkPhysicalDevice*)devices_buffer;
        device = devices[device_index];
        printf("  devices_buffer: %p, device[%d]: %p\n",
               devices_buffer, device_index, (void*)device);
    } else {
        printf("  devices_buffer is NULL!\n");
    }

    uint32_t* count_ptr = index_to_ptr(count_idx);
    // If props_idx is 0, treat it as NULL for first call to get count only
    VkQueueFamilyProperties* props_ptr = (props_idx == 0) ? NULL : index_to_ptr(props_idx);

    printf("  count_ptr: %p, props_ptr: %p\n",
           (void*)count_ptr, (void*)props_ptr);

    vkGetPhysicalDeviceQueueFamilyProperties(device, count_ptr, props_ptr);

    if (count_ptr) {
        printf("  After call, *count_ptr: %u\n", *count_ptr);
    }
    fflush(stdout);
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
    // support_idx should never be 0 here (we always need to return support value)
    VkBool32* support_ptr = index_to_ptr(support_idx);

    VkResult result = vkGetPhysicalDeviceSurfaceSupportKHR(device_ptr, index, surf_ptr, support_ptr);

    return (int32_t)result;
}

// vkDestroySurfaceKHR wrapper - accepts int64 handles directly
void vulkan_vkDestroySurfaceKHR(int64_t instance, int64_t surface, int32_t allocator) {
    VkInstance instance_ptr = (VkInstance)(uintptr_t)instance;
    VkSurfaceKHR surface_ptr = (VkSurfaceKHR)(uintptr_t)surface;

    printf("DEBUG: vkDestroySurfaceKHR called with instance=%p, surface=%p\n",
           (void*)instance_ptr, (void*)surface_ptr);
    fflush(stdout);

    vkDestroySurfaceKHR(instance_ptr, surface_ptr, NULL);
}

// vkCreateSurfaceKHR wrapper - accepts int64 instance and returns surface in buffer
int32_t vulkan_vkCreateSurfaceKHR(int64_t instance, int32_t create_info, int32_t allocator, int32_t surface_idx) {
    printf("DEBUG: vkCreateSurfaceKHR called with instance=%p, surface_idx=%d\n",
           (void*)(uintptr_t)instance, surface_idx);

    VkInstance instance_ptr = (VkInstance)(uintptr_t)instance;
    void* surface_buffer = index_to_ptr(surface_idx);

    if (!surface_buffer) {
        printf("  ERROR: Invalid surface buffer index\n");
        return (int32_t)VK_ERROR_INITIALIZATION_FAILED;
    }

    // Create the actual XCB surface
    // Note: This is a simplified implementation that needs to be completed
    // with proper XCB surface creation logic
    VkSurfaceKHR surface = (VkSurfaceKHR)(uintptr_t)0;

    printf("  About to create surface...\n");
    fflush(stdout);

    // TODO: Implement actual surface creation
    // For now, return success without creating a surface
    *(VkSurfaceKHR*)surface_buffer = surface;

    printf("  Surface created: %p\n", (void*)surface);
    fflush(stdout);

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
    memset(&queue_ci, 0, sizeof(VkDeviceQueueCreateInfo));
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
    memset(&device_ci, 0, sizeof(VkDeviceCreateInfo));
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

    // Try to flush and add small delay before calling vkCreateDevice
    printf("  About to call vkCreateDevice...\n");
    fflush(stdout);

    VkResult result = vkCreateDevice(physical_device, (const VkDeviceCreateInfo*)&device_ci, NULL, (VkDevice*)device_buffer);

    printf("  vkCreateDevice result: %d\n", result);
    fflush(stdout);

    return (int32_t)result;
}

// Direct version that accepts physical device as int64
int32_t vulkan_vkCreateDeviceDirect(int64_t physical_device, int32_t queue_family, int32_t device_idx) {
    printf("DEBUG: vkCreateDeviceDirect called - queue_family: %d\n", queue_family);

    VkPhysicalDevice pd = (VkPhysicalDevice)(uintptr_t)physical_device;
    void* device_buffer = index_to_ptr(device_idx);

    printf("  device_idx: %d, device_buffer: %p\n", device_idx, device_buffer);
    fflush(stdout);

    // Query physical device properties for debugging
    VkPhysicalDeviceProperties props;
    vkGetPhysicalDeviceProperties(pd, &props);
    printf("  Physical Device Name: %s\n", props.deviceName);
    printf("  API Version: %u.%u.%u\n",
           VK_VERSION_MAJOR(props.apiVersion),
           VK_VERSION_MINOR(props.apiVersion),
           VK_VERSION_PATCH(props.apiVersion));
    printf("  Driver Version: %u.%u.%u\n",
           VK_VERSION_MAJOR(props.driverVersion),
           VK_VERSION_MINOR(props.driverVersion),
           VK_VERSION_PATCH(props.driverVersion));
    printf("  Vendor ID: 0x%x, Device ID: 0x%x\n", props.vendorID, props.deviceID);
    printf("  Device Type: %d\n", props.deviceType);
    fflush(stdout);

    // Create queue create info on stack
    float queue_priority = 1.0f;
    VkDeviceQueueCreateInfo queue_ci;
    memset(&queue_ci, 0, sizeof(VkDeviceQueueCreateInfo));
    queue_ci.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
    queue_ci.pNext = NULL;
    queue_ci.flags = 0;
    queue_ci.queueFamilyIndex = (uint32_t)queue_family;
    queue_ci.queueCount = 1;
    queue_ci.pQueuePriorities = &queue_priority;

    // Enable swapchain extension
    const char* device_extensions[] = { VK_KHR_SWAPCHAIN_EXTENSION_NAME };
    const uint32_t extension_count = 1;

    printf("  Enabling device extension: %s\n", VK_KHR_SWAPCHAIN_EXTENSION_NAME);
    fflush(stdout);

    // Create device create info on stack
    VkDeviceCreateInfo device_ci;
    memset(&device_ci, 0, sizeof(VkDeviceCreateInfo));
    device_ci.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
    device_ci.pNext = NULL;
    device_ci.flags = 0;
    device_ci.queueCreateInfoCount = 1;
    device_ci.pQueueCreateInfos = &queue_ci;
    device_ci.enabledLayerCount = 0;
    device_ci.ppEnabledLayerNames = NULL;
    device_ci.enabledExtensionCount = extension_count;
    device_ci.ppEnabledExtensionNames = device_extensions;
    device_ci.pEnabledFeatures = VK_NULL_HANDLE;

    printf("  Calling vkCreateDevice with physical_device: %p\n", (void*)pd);
    printf("  device_buffer before call: %p, *device_buffer: %p\n", device_buffer, *(void**)device_buffer);
    printf("  About to call vkCreateDevice...\n");
    fflush(stdout);

    VkResult result = vkCreateDevice(pd, (const VkDeviceCreateInfo*)&device_ci, NULL, (VkDevice*)device_buffer);

    printf("  vkCreateDevice result: %d\n", result);
    printf("  device_buffer after call: *device_buffer: %p\n", *(void**)device_buffer);
    fflush(stdout);

    return (int32_t)result;
}

// Simplified version of vkCreateDeviceDirect - no extensions, just basic device
int32_t vulkan_vkCreateDeviceDirectSimple(int64_t physical_device, int32_t queue_family, int32_t device_idx) {
    printf("DEBUG: vkCreateDeviceDirectSimple called - queue_family: %d\n", queue_family);
    fflush(stdout);

    VkPhysicalDevice pd = (VkPhysicalDevice)(uintptr_t)physical_device;
    void* device_buffer = index_to_ptr(device_idx);

    // Allocate queue create info on heap
    float* queue_priority = (float*)malloc(sizeof(float));
    *queue_priority = 1.0f;
    
    VkDeviceQueueCreateInfo* queue_ci = (VkDeviceQueueCreateInfo*)malloc(sizeof(VkDeviceQueueCreateInfo));
    memset(queue_ci, 0, sizeof(VkDeviceQueueCreateInfo));
    queue_ci->sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
    queue_ci->pNext = NULL;
    queue_ci->flags = 0;
    queue_ci->queueFamilyIndex = (uint32_t)queue_family;
    queue_ci->queueCount = 1;
    queue_ci->pQueuePriorities = queue_priority;

    // Create device create info on heap - NO EXTENSIONS
    VkDeviceCreateInfo* device_ci = (VkDeviceCreateInfo*)malloc(sizeof(VkDeviceCreateInfo));
    memset(device_ci, 0, sizeof(VkDeviceCreateInfo));
    device_ci->sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
    device_ci->pNext = NULL;
    device_ci->flags = 0;
    device_ci->queueCreateInfoCount = 1;
    device_ci->pQueueCreateInfos = queue_ci;
    device_ci->enabledLayerCount = 0;
    device_ci->ppEnabledLayerNames = NULL;
    device_ci->enabledExtensionCount = 0;  // NO EXTENSIONS
    device_ci->ppEnabledExtensionNames = NULL;
    device_ci->pEnabledFeatures = VK_NULL_HANDLE;

    printf("  Calling vkCreateDevice (no extensions)...\n");
    printf("  physical_device: %p\n", (void*)pd);
    printf("  device_ci.sType: %u\n", device_ci->sType);
    printf("  device_ci.pQueueCreateInfos: %p\n", (void*)device_ci->pQueueCreateInfos);
    printf("  device_buffer: %p\n", device_buffer);
    fflush(stdout);

    VkResult result = vkCreateDevice(pd, (const VkDeviceCreateInfo*)device_ci, NULL, (VkDevice*)device_buffer);

    printf("  vkCreateDevice result: %d\n", result);
    if (result == VK_SUCCESS) {
        printf("  Device created successfully: %p\n", *(void**)device_buffer);
    }
    fflush(stdout);

    // Clean up
    free(queue_ci);
    free(queue_priority);
    free(device_ci);

    return (int32_t)result;
}

// vkGetDeviceQueue wrapper - accepts device as int64 handle directly
void vulkan_vkGetDeviceQueueArray(int64_t device, int32_t queue_family, int32_t queue_index, int32_t queue_out_idx) {
    VkDevice device_ptr = (VkDevice)(uintptr_t)device;
    void* queue_buffer = index_to_ptr(queue_out_idx);

    printf("DEBUG: vkGetDeviceQueueArray called with device=%p, queue_family=%d, queue_index=%d\n",
           (void*)device_ptr, queue_family, queue_index);
    fflush(stdout);

    vkGetDeviceQueue(device_ptr, queue_family, queue_index, (VkQueue*)queue_buffer);

    printf("  Queue retrieved\n");
    fflush(stdout);
}

// vkDestroyDevice wrapper - accepts device as int64 handle directly
void vulkan_vkDestroyDevice(int64_t device, int32_t allocator) {
    VkDevice device_ptr = (VkDevice)(uintptr_t)device;
    vkDestroyDevice(device_ptr, NULL);
}

// vkGetPhysicalDeviceSurfaceCapabilitiesKHR wrapper
int32_t vulkan_vkGetPhysicalDeviceSurfaceCapabilitiesKHR(int64_t physical_device, int64_t surface, int32_t capabilities_idx) {
    VkPhysicalDevice pd = (VkPhysicalDevice)(uintptr_t)physical_device;
    VkSurfaceKHR surf = (VkSurfaceKHR)(uintptr_t)surface;
    VkSurfaceCapabilitiesKHR* caps = (VkSurfaceCapabilitiesKHR*)index_to_ptr(capabilities_idx);

    printf("DEBUG: vkGetPhysicalDeviceSurfaceCapabilitiesKHR called\n");
    fflush(stdout);

    VkResult result = vkGetPhysicalDeviceSurfaceCapabilitiesKHR(pd, surf, caps);

    printf("  minImageCount: %u, maxImageCount: %u\n", caps->minImageCount, caps->maxImageCount);
    printf("  currentExtent: %ux%u\n", caps->currentExtent.width, caps->currentExtent.height);
    fflush(stdout);

    return (int32_t)result;
}

// vkGetPhysicalDeviceSurfaceFormatsKHR wrapper
int32_t vulkan_vkGetPhysicalDeviceSurfaceFormatsKHR(int64_t physical_device, int64_t surface, int32_t format_count_idx, int32_t formats_idx) {
    VkPhysicalDevice pd = (VkPhysicalDevice)(uintptr_t)physical_device;
    VkSurfaceKHR surf = (VkSurfaceKHR)(uintptr_t)surface;

    uint32_t* count_ptr = (uint32_t*)index_to_ptr(format_count_idx);
    VkSurfaceFormatKHR* formats = (VkSurfaceFormatKHR*)index_to_ptr(formats_idx);

    printf("DEBUG: vkGetPhysicalDeviceSurfaceFormatsKHR called\n");
    fflush(stdout);

    VkResult result = vkGetPhysicalDeviceSurfaceFormatsKHR(pd, surf, count_ptr, formats);

    printf("  Format count: %u\n", *count_ptr);
    if (formats && *count_ptr > 0) {
        printf("  First format: %u, colorSpace: %u\n", formats[0].format, formats[0].colorSpace);
    }
    fflush(stdout);

    return (int32_t)result;
}

// vkGetPhysicalDeviceSurfacePresentModesKHR wrapper
int32_t vulkan_vkGetPhysicalDeviceSurfacePresentModesKHR(int64_t physical_device, int64_t surface, int32_t mode_count_idx, int32_t modes_idx) {
    VkPhysicalDevice pd = (VkPhysicalDevice)(uintptr_t)physical_device;
    VkSurfaceKHR surf = (VkSurfaceKHR)(uintptr_t)surface;

    uint32_t* count_ptr = (uint32_t*)index_to_ptr(mode_count_idx);
    VkPresentModeKHR* modes = (VkPresentModeKHR*)index_to_ptr(modes_idx);

    printf("DEBUG: vkGetPhysicalDeviceSurfacePresentModesKHR called\n");
    fflush(stdout);

    VkResult result = vkGetPhysicalDeviceSurfacePresentModesKHR(pd, surf, count_ptr, modes);

    printf("  Present mode count: %u\n", *count_ptr);
    if (modes && *count_ptr > 0) {
        printf("  First mode: %u\n", modes[0]);
    }
    fflush(stdout);

    return (int32_t)result;
}

// vkGetSwapchainImagesKHR wrapper
int32_t vulkan_vkGetSwapchainImagesKHR(int64_t device, int64_t swapchain, int32_t image_count_idx, int32_t images_idx) {
    VkDevice dev = (VkDevice)(uintptr_t)device;
    VkSwapchainKHR swap = (VkSwapchainKHR)(uintptr_t)swapchain;

    uint32_t* count_ptr = (uint32_t*)index_to_ptr(image_count_idx);
    VkImage* images = (VkImage*)index_to_ptr(images_idx);

    printf("DEBUG: vkGetSwapchainImagesKHR called\n");
    fflush(stdout);

    VkResult result = vkGetSwapchainImagesKHR(dev, swap, count_ptr, images);

    printf("  Swapchain image count: %u\n", *count_ptr);
    if (images && *count_ptr > 0) {
        printf("  First image: %p\n", (void*)images[0]);
    }
    fflush(stdout);

    return (int32_t)result;
}

// vkCreateImageView wrapper
int32_t vulkan_vkCreateImageView(int64_t device, int32_t create_info_idx, int32_t allocator, int32_t image_view_idx) {
    VkDevice dev = (VkDevice)(uintptr_t)device;
    VkImageViewCreateInfo* ci = (VkImageViewCreateInfo*)index_to_ptr(create_info_idx);
    VkImageView* image_view = (VkImageView*)index_to_ptr(image_view_idx);

    printf("DEBUG: vkCreateImageView called\n");
    printf("  image: %p\n", (void*)ci->image);
    printf("  viewType: %u\n", ci->viewType);
    printf("  format: %u\n", ci->format);
    fflush(stdout);

    VkResult result = vkCreateImageView(dev, ci, NULL, image_view);

    printf("  Image view created: %p, result: %d\n", (void*)*image_view, result);
    fflush(stdout);

    return (int32_t)result;
}

// vkDestroyImageView wrapper
void vulkan_vkDestroyImageView(int64_t device, int64_t image_view, int32_t allocator) {
    VkDevice dev = (VkDevice)(uintptr_t)device;
    VkImageView view = (VkImageView)(uintptr_t)image_view;

    printf("DEBUG: vkDestroyImageView called\n");
    fflush(stdout);

    vkDestroyImageView(dev, view, NULL);
}

// vkCreateSwapchainKHR wrapper
int32_t vulkan_vkCreateSwapchainKHR(int64_t device, int32_t create_info_idx, int32_t allocator, int32_t swapchain_idx) {
    VkDevice dev = (VkDevice)(uintptr_t)device;
    VkSwapchainCreateInfoKHR* ci = (VkSwapchainCreateInfoKHR*)index_to_ptr(create_info_idx);
    VkSwapchainKHR* swapchain = (VkSwapchainKHR*)index_to_ptr(swapchain_idx);

    printf("DEBUG: vkCreateSwapchainKHR called\n");
    printf("  surface: %p\n", (void*)ci->surface);
    printf("  minImageCount: %u\n", ci->minImageCount);
    printf("  imageFormat: %u\n", ci->imageFormat);
    printf("  imageExtent: %ux%u\n", ci->imageExtent.width, ci->imageExtent.height);
    fflush(stdout);

    VkResult result = vkCreateSwapchainKHR(dev, ci, NULL, swapchain);

    printf("  Swapchain created: %p, result: %d\n", (void*)*swapchain, result);
    fflush(stdout);

    return (int32_t)result;
}

// vkDestroySwapchainKHR wrapper
void vulkan_vkDestroySwapchainKHR(int64_t device, int64_t swapchain, int32_t allocator) {
    VkDevice dev = (VkDevice)(uintptr_t)device;
    VkSwapchainKHR swap = (VkSwapchainKHR)(uintptr_t)swapchain;

    printf("DEBUG: vkDestroySwapchainKHR called\n");
    fflush(stdout);

    vkDestroySwapchainKHR(dev, swap, NULL);
}

// vkCreateDevice wrapper
int32_t vulkan_vkCreateDevice(int64_t physical_device, int32_t create_info_idx, int32_t allocator, int32_t device_idx) {
    printf("DEBUG: vkCreateDevice called\n");
    printf("  physical_device=%p, create_info_idx=%d, device_idx=%d\n", (void*)(uintptr_t)physical_device, create_info_idx, device_idx);
    fflush(stdout);
    
    VkPhysicalDevice phys_dev = (VkPhysicalDevice)(uintptr_t)physical_device;
    VkDeviceCreateInfo* create_info = (VkDeviceCreateInfo*)index_to_ptr(create_info_idx);
    
    if (!create_info) {
        fprintf(stderr, "ERROR: Invalid create_info pointer\n");
        return VK_ERROR_INITIALIZATION_FAILED;
    }
    
    printf("  create_info->sType=%d\n", create_info->sType);
    printf("  create_info->queueCreateInfoCount=%u\n", create_info->queueCreateInfoCount);
    printf("  create_info->pQueueCreateInfos (as int64)=%ld\n", (int64_t)create_info->pQueueCreateInfos);
    printf("  create_info->enabledExtensionCount=%u\n", create_info->enabledExtensionCount);
    printf("  create_info->ppEnabledExtensionNames (as int64)=%ld\n", (int64_t)create_info->ppEnabledExtensionNames);
    fflush(stdout);
    
    // Convert index-based pointers to actual pointers
    // The pointer values are actually indices stored as int64, convert them to actual pointers
    int32_t queues_idx = (int32_t)(intptr_t)create_info->pQueueCreateInfos;
    if (queues_idx >= 0) {
        void* queues_ptr = index_to_ptr(queues_idx);
        printf("  Converted queues_idx=%d to queues_ptr=%p\n", queues_idx, queues_ptr);

        // Print the memory at queues_ptr
        uint64_t* queues_arr = (uint64_t*)queues_ptr;
        printf("  queues_arr[0] = %ld (0x%lx)\n", queues_arr[0], queues_arr[0]);

        // Dereference queues_arr[0] to get the VkDeviceQueueCreateInfo pointer
        VkDeviceQueueCreateInfo* qci = (VkDeviceQueueCreateInfo*)(intptr_t)queues_arr[0];
        printf("  qci = %p\n", qci);
        printf("  qci->sType = %u\n", qci->sType);
        printf("  qci->queueFamilyIndex = %u\n", qci->queueFamilyIndex);
        printf("  qci->queueCount = %u\n", qci->queueCount);

        create_info->pQueueCreateInfos = qci;
    }
    
    int32_t extensions_idx = (int32_t)(intptr_t)create_info->ppEnabledExtensionNames;
    printf("  extensions_idx = %d\n", extensions_idx);
    if (extensions_idx >= 0 && create_info->enabledExtensionCount > 0) {
        printf("  Processing extensions...\n");
        fflush(stdout);
        void* extensions_ptr = index_to_ptr(extensions_idx);
        printf("  Converted extensions_idx=%d to extensions_ptr=%p\n", extensions_idx, extensions_ptr);

        // Need to convert string indices in the array to actual string pointers
        // The array contains indices (stored as int64), but Vulkan expects char* pointers
        // So we need to convert the indices to actual pointers
        int64_t* ext_indices = (int64_t*)extensions_ptr;
        printf("  Before conversion: ext_indices[0] = %ld (0x%lx)\n", ext_indices[0], ext_indices[0]);

        // The value stored in ext_indices[i] is the result of vulkan_set_ptr,
        // which is (int64_t)(intptr_t)target, where target = index_to_ptr(str_idx).
        // So ext_indices[i] is actually the actual pointer, not the index!
        // We don't need to convert it again!

        for (uint32_t i = 0; i < create_info->enabledExtensionCount; i++) {
            char* str_ptr = (char*)ext_indices[i];
            printf("    Extension %d: ptr=%p, str=%s\n", i, str_ptr, str_ptr ? str_ptr : "(null)");
        }

        // The ext_indices array already contains the correct pointers!
        create_info->ppEnabledExtensionNames = (const char* const*)ext_indices;
    } else {
        printf("  extensions_idx=%d, enabledExtensionCount=%u\n", extensions_idx, create_info->enabledExtensionCount);
        // If no extensions, set ppEnabledExtensionNames to NULL
        if (create_info->enabledExtensionCount == 0) {
            create_info->ppEnabledExtensionNames = NULL;
            printf("  Set ppEnabledExtensionNames to NULL\n");
        }
    }
    
    printf("  After conversion:\n");
    printf("    queueCreateInfoCount=%u, pQueueCreateInfos=%p\n", create_info->queueCreateInfoCount, (void*)create_info->pQueueCreateInfos);
    printf("    enabledExtensionCount=%u, ppEnabledExtensionNames=%p\n", create_info->enabledExtensionCount, (void*)create_info->ppEnabledExtensionNames);

    // Print extension names for debugging
    if (create_info->enabledExtensionCount > 0 && create_info->ppEnabledExtensionNames != NULL) {
        printf("    Extension names:\n");
        for (uint32_t i = 0; i < create_info->enabledExtensionCount; i++) {
            const char* ext_name = create_info->ppEnabledExtensionNames[i];
            printf("      [%u] %s\n", i, ext_name ? ext_name : "(null)");
        }
    }
    fflush(stdout);

    printf("  About to call vkCreateDevice...\n");
    printf("  create_info = %p\n", (void*)create_info);
    printf("  create_info->sType = %u\n", create_info->sType);
    printf("  create_info->pNext = %p\n", create_info->pNext);
    printf("  create_info->flags = %u\n", create_info->flags);
    printf("  create_info->queueCreateInfoCount = %u\n", create_info->queueCreateInfoCount);
    printf("  create_info->pQueueCreateInfos = %p\n", create_info->pQueueCreateInfos);
    printf("  create_info->enabledLayerCount = %u\n", create_info->enabledLayerCount);
    printf("  create_info->ppEnabledLayerNames = %p\n", create_info->ppEnabledLayerNames);
    printf("  create_info->enabledExtensionCount = %u\n", create_info->enabledExtensionCount);
    printf("  create_info->ppEnabledExtensionNames = %p\n", create_info->ppEnabledExtensionNames);
    printf("  create_info->pEnabledFeatures = %p\n", create_info->pEnabledFeatures);
    fflush(stdout);

    VkDevice device;
    printf("  About to call vkCreateDevice...\n");
    fflush(stdout);

    // Check if vkCreateDevice is valid
    printf("  vkCreateDevice function pointer = %p\n", (void*)vkCreateDevice);
    fflush(stdout);

    // Call vkCreateDevice with try-catch style error handling
    printf("  Calling vkCreateDevice...\n");
    fflush(stdout);

    VkResult result = vkCreateDevice(phys_dev, create_info, NULL, &device);

    printf("  vkCreateDevice returned: %d\n", result);
    printf("  device = %p\n", (void*)device);
    fflush(stdout);

    printf("  vkCreateDevice returned: %d\n", result);
    fflush(stdout);
    
    printf("  vkCreateDevice returned: %d\n", result);
    printf("  device created: %p\n", (void*)device);
    fflush(stdout);

    if (result == VK_SUCCESS && device) {
        // Store the device handle at the given index
        int32_t* device_ptr = (int32_t*)index_to_ptr(device_idx);
        if (device_ptr) {
            *device_ptr = ptr_to_index((void*)device);
            printf("  device handle stored at index %d\n", device_idx);
            fflush(stdout);
        }
    }

    return result;
}

// vkAcquireNextImageKHR wrapper
int32_t vulkan_vkAcquireNextImageKHR(int64_t device, int64_t swapchain, int64_t timeout, int64_t semaphore, int64_t fence, int32_t image_index_idx) {
    VkDevice dev = (VkDevice)(uintptr_t)device;
    VkSwapchainKHR swap = (VkSwapchainKHR)(uintptr_t)swapchain;
    VkSemaphore sem = (VkSemaphore)(uintptr_t)semaphore;
    VkFence fen = (VkFence)(uintptr_t)fence;
    uint32_t* image_index_ptr = (uint32_t*)index_to_ptr(image_index_idx);

    VkResult result = vkAcquireNextImageKHR(dev, swap, (uint64_t)timeout, sem, fen, image_index_ptr);

    return result;
}

// vkQueuePresentKHR wrapper
int32_t vulkan_vkQueuePresentKHR(int64_t queue, int32_t present_info_idx) {
    VkQueue q = (VkQueue)(uintptr_t)queue;
    VkPresentInfoKHR* present_info = (VkPresentInfoKHR*)index_to_ptr(present_info_idx);

    VkResult result = vkQueuePresentKHR(q, present_info);

    return result;
}

// vkDeviceWaitIdle wrapper
int32_t vulkan_vkDeviceWaitIdle(int64_t device) {
    VkDevice dev = (VkDevice)(uintptr_t)device;
    VkResult result = vkDeviceWaitIdle(dev);
    return result;
}

// Get physical device name from properties
// Returns index of a string that contains the device name
int32_t vulkan_get_device_name(int32_t properties_idx) {
    VkPhysicalDeviceProperties* props = (VkPhysicalDeviceProperties*)index_to_ptr(properties_idx);
    
    if (!props) {
        return -1;
    }
    
    // Copy device name to a new string
    int32_t name_idx = ptr_to_index(malloc(256));
    char* name_ptr = (char*)index_to_ptr(name_idx);
    strncpy(name_ptr, props->deviceName, 255);
    name_ptr[255] = '\0';
    
    return name_idx;
}

// Read a single character from a string at the given offset
int32_t vulkan_read_char(int32_t str_idx, int32_t offset) {
    char* str = (char*)index_to_ptr(str_idx);
    
    if (!str || offset < 0 || offset >= 256) {
        return 0;
    }
    
    return (int32_t)str[offset];
}

// Print device name for debugging
void vulkan_print_device_name(int32_t properties_idx) {
    VkPhysicalDeviceProperties* props = (VkPhysicalDeviceProperties*)index_to_ptr(properties_idx);
    
    if (!props) {
        printf("ERROR: Invalid properties pointer\n");
        fflush(stdout);
        return;
    }
    
    printf("  Device Name: %s\n", props->deviceName);
    printf("  Device Type: %d\n", props->deviceType);
    fflush(stdout);
}

// Read C string and return to MoonBit
// Returns the length of the string
int32_t vulkan_read_c_string(int32_t str_idx, int32_t buffer_idx, int32_t buffer_size) {
    char* src = (char*)index_to_ptr(str_idx);
    char* dst = (char*)index_to_ptr(buffer_idx);
    
    if (!src || !dst || buffer_size <= 0) {
        return 0;
    }
    
    int32_t len = 0;
    while (len < buffer_size - 1 && src[len] != '\0') {
        dst[len] = src[len];
        len++;
    }
    dst[len] = '\0';
    
    return len;
}

