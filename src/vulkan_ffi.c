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

void vulkan_put_int64(int32_t ptr, int32_t offset, int32_t value) {
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

int32_t vulkan_get_int64(int32_t ptr, int32_t offset) {
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
