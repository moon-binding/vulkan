// Simple C bridge for Vulkan FFI testing

#include <vulkan/vulkan.h>
#include <stdint.h>
#include <stdlib.h>

// Create Vulkan instance using minimal parameters
// Returns VK_SUCCESS (0) on success, error code on failure
uint32_t vk_bridge_create_instance(
    const char* app_name,
    const char* engine_name,
    uint64_t* out_instance
) {
    VkApplicationInfo app_info = {0};
    app_info.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    app_info.pApplicationName = app_name;
    app_info.pEngineName = engine_name;
    app_info.apiVersion = VK_API_VERSION_1_0;

    VkInstanceCreateInfo create_info = {0};
    create_info.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    create_info.pApplicationInfo = &app_info;

    VkInstance instance;
    VkResult result = vkCreateInstance(&create_info, NULL, &instance);

    if (result == VK_SUCCESS && out_instance != NULL) {
        *out_instance = (uint64_t)(uintptr_t)instance;
    }

    return (uint32_t)result;
}

// Enumerate physical devices
// Returns number of devices, or negative error code
int32_t vk_bridge_enumerate_physical_devices(
    uint64_t instance,
    uint32_t* out_device_count,
    uint64_t* out_devices
) {
    VkInstance vk_instance = (VkInstance)(uintptr_t)instance;

    uint32_t device_count = 0;
    VkResult result = vkEnumeratePhysicalDevices(vk_instance, &device_count, NULL);

    if (result != VK_SUCCESS) {
        return -(int32_t)result;
    }

    if (out_device_count != NULL) {
        *out_device_count = device_count;
    }

    if (out_devices != NULL && device_count > 0) {
        VkPhysicalDevice* devices = (VkPhysicalDevice*)malloc(device_count * sizeof(VkPhysicalDevice));
        result = vkEnumeratePhysicalDevices(vk_instance, &device_count, devices);

        if (result == VK_SUCCESS) {
            for (uint32_t i = 0; i < device_count; i++) {
                out_devices[i] = (uint64_t)(uintptr_t)devices[i];
            }
        }

        free(devices);

        if (result != VK_SUCCESS) {
            return -(int32_t)result;
        }
    }

    return (int32_t)device_count;
}

// Destroy instance
void vk_bridge_destroy_instance(uint64_t instance) {
    VkInstance vk_instance = (VkInstance)(uintptr_t)instance;
    vkDestroyInstance(vk_instance, NULL);
}
