// Vulkan C FFI Bridge for MoonBit
// Direct bindings to Vulkan C API for MoonBit

#include <vulkan/vulkan.h>
#include <moonbit.h>
#include <string.h>
#include <stdlib.h>

// All Vulkan handles are passed as void* pointers (MoonBit #external type)
// All Vulkan structures are passed as void* pointers
// VkResult is returned as int32_t

// Memory access helpers for structure fields
void vulkan_put_int32(int32_t ptr, int32_t offset, int32_t value) {
    if (ptr) {
        *(int32_t*)((uint8_t*)ptr + offset) = value;
    }
}

void vulkan_put_int64(int32_t ptr, int32_t offset, int64_t value) {
    if (ptr) {
        *(int64_t*)((uint8_t*)ptr + offset) = value;
    }
}

int32_t vulkan_get_int32(int32_t ptr, int32_t offset) {
    if (ptr) {
        return *(int32_t*)((uint8_t*)ptr + offset);
    }
    return 0;
}

int64_t vulkan_get_int64(int32_t ptr, int32_t offset) {
    if (ptr) {
        return *(int64_t*)((uint8_t*)ptr + offset);
    }
    return 0;
}

// String creation helper
int32_t vulkan_create_string(const char* s) {
    if (!s) return 0;
    size_t len = strlen(s);
    char* str = malloc(len + 1);
    if (str) {
        strcpy(str, s);
        return (int32_t)(intptr_t)str;
    }
    return 0;
}

void vulkan_free_string(int32_t ptr) {
    if (ptr) {
        free((void*)(intptr_t)ptr);
    }
}

// Load C string back to MoonBit (simplified - returns pointer)
int32_t vulkan_load_c_string(int32_t ptr) {
    return ptr;
}

// Set extension name in array
void vulkan_set_extension_name(int32_t array, int32_t index, int32_t name) {
    if (array) {
        int32_t* ptr = (int32_t*)((uint8_t*)array + (index * 8));
        *ptr = name;
    }
}

// Set float array value
void vulkan_set_float_array_value(int32_t array, int32_t index, float value) {
    if (array) {
        float* ptr = (float*)((uint8_t*)array + (index * 4));
        *ptr = value;
    }
}
