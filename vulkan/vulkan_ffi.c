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

void vulkan_put_int64(int32_t idx, int32_t offset, int32_t value) {
    void* ptr = index_to_ptr(idx);
    if (ptr) {
        *(int32_t*)((uint8_t*)ptr + offset) = value;
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
    VkResult result = vkCreateInstance((const VkInstanceCreateInfo*)create_info, NULL, (VkInstance*)instance_ptr);
    return (int32_t)result;
}

// vkDestroyInstance wrapper
void vulkan_vkDestroyInstance(int32_t instance_idx, int32_t allocator) {
    VkInstance instance = (VkInstance)index_to_ptr(instance_idx);
    vkDestroyInstance(instance, NULL);
}

// vkEnumeratePhysicalDevices wrapper
int32_t vulkan_vkEnumeratePhysicalDevices(int32_t instance_idx, int32_t count_idx, int32_t devices_idx) {
    VkInstance instance = (VkInstance)index_to_ptr(instance_idx);
    uint32_t* count_ptr = index_to_ptr(count_idx);
    VkPhysicalDevice* devices_ptr = index_to_ptr(devices_idx);
    return (int32_t)vkEnumeratePhysicalDevices(instance, count_ptr, devices_ptr);
}

// vkGetPhysicalDeviceQueueFamilyProperties wrapper
void vulkan_vkGetPhysicalDeviceQueueFamilyProperties(int32_t device_idx, int32_t count_idx, int32_t props_idx) {
    VkPhysicalDevice device = (VkPhysicalDevice)index_to_ptr(device_idx);
    uint32_t* count_ptr = index_to_ptr(count_idx);
    VkQueueFamilyProperties* props_ptr = index_to_ptr(props_idx);
    vkGetPhysicalDeviceQueueFamilyProperties(device, count_ptr, props_ptr);
}

// vkGetPhysicalDeviceSurfaceSupportKHR wrapper
int32_t vulkan_vkGetPhysicalDeviceSurfaceSupportKHR(int32_t device_idx, int32_t index, int32_t surface, int32_t support_idx) {
    VkPhysicalDevice device = (VkPhysicalDevice)index_to_ptr(device_idx);
    VkSurfaceKHR surf = (VkSurfaceKHR)(uintptr_t)surface;
    VkBool32* support_ptr = index_to_ptr(support_idx);
    return (int32_t)vkGetPhysicalDeviceSurfaceSupportKHR(device, index, surf, support_ptr);
}

// vkDestroySurfaceKHR wrapper
void vulkan_vkDestroySurfaceKHR(int32_t instance_idx, int32_t surface, int32_t allocator) {
    VkInstance instance = (VkInstance)index_to_ptr(instance_idx);
    VkSurfaceKHR surf = (VkSurfaceKHR)(uintptr_t)surface;
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
