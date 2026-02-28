// Window and Surface handling for MoonBit Vulkan Demo
// Uses GLFW for window creation and surface management

#include <vulkan/vulkan.h>
#include <GLFW/glfw3.h>
#include <moonbit.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Simple vertex shader SPIR-V bytecode
static unsigned char vert_spv[] = {
    0x03, 0x02, 0x23, 0x07, 0x00, 0x00, 0x01, 0x00,
    0x07, 0x00, 0x05, 0x00, 0x10, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x11, 0x00, 0x02, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x0b, 0x00, 0x0c, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
    0x0b, 0x00, 0x0c, 0x00, 0x01, 0x00, 0x00, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x10, 0x00, 0x03, 0x00,
    0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x17, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
    0x0b, 0x00, 0x0c, 0x00, 0x01, 0x00, 0x00, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x03, 0x00, 0x02, 0x00,
    0x04, 0x00, 0x00, 0x00, 0x4f, 0x4c, 0x03, 0x00,
    0x0b, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x0b, 0x00, 0x0c, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
};
static unsigned int vert_spv_len = sizeof(vert_spv);

// Simple fragment shader SPIR-V bytecode
static unsigned char frag_spv[] = {
    0x03, 0x02, 0x23, 0x07, 0x00, 0x00, 0x01, 0x00,
    0x07, 0x00, 0x08, 0x00, 0x15, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x11, 0x00, 0x02, 0x00, 0x01, 0x00, 0x00, 0x00,
    0x0b, 0x00, 0x0c, 0x00, 0x01, 0x00, 0x00, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x10, 0x00, 0x03, 0x00,
    0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x17, 0x00, 0x00, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x0b, 0x00, 0x0c, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00,
    0x03, 0x00, 0x02, 0x00, 0x04, 0x00, 0x00, 0x00,
    0x4f, 0x4c, 0x03, 0x00, 0x0b, 0x00, 0x00, 0x00,
    0x01, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
};
static unsigned int frag_spv_len = sizeof(frag_spv);

// Global state
static GLFWwindow* g_window = NULL;
static VkInstance g_instance = VK_NULL_HANDLE;
static VkSurfaceKHR g_surface = VK_NULL_HANDLE;

// Initialize GLFW and create window
int32_t window_init(int32_t width, int32_t height, const char* title) {
    if (!glfwInit()) {
        fprintf(stderr, "Failed to initialize GLFW\n");
        return 0;
    }

    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);

    g_window = glfwCreateWindow(width, height, title, NULL, NULL);
    if (!g_window) {
        fprintf(stderr, "Failed to create GLFW window\n");
        glfwTerminate();
        return 0;
    }

    printf("Window created: %dx%d - %s\n", width, height, title);
    return 1;
}

// Get the created surface value
int64_t get_surface_value(void) {
    return (int64_t)(uintptr_t)g_surface;
}

// Create Vulkan surface
int32_t surface_create(int32_t instance_buffer_idx, int32_t surface_buffer_idx) {
    // Get instance from buffer using vulkan_get_int64 from vulkan_ffi.c
    extern int64_t vulkan_get_int64(int32_t idx, int32_t offset);
    int64_t instance_val = vulkan_get_int64(instance_buffer_idx, 0);

    g_instance = (VkInstance)(uintptr_t)instance_val;

    VkResult result = glfwCreateWindowSurface(g_instance, g_window, NULL, &g_surface);
    if (result != VK_SUCCESS) {
        fprintf(stderr, "Failed to create window surface (error: %d)\n", result);
        return 0;
    }

    printf("Surface created successfully\n");
    return 1;
}

// Poll window events
void window_poll_events(void) {
    glfwPollEvents();
}

// Check if window should close
int32_t window_should_close(void) {
    return glfwWindowShouldClose(g_window) ? 1 : 0;
}

// Get framebuffer size
void window_get_framebuffer_size(int32_t* width, int32_t* height) {
    glfwGetFramebufferSize(g_window, width, height);
}

// Cleanup
void window_cleanup(void) {
    if (g_surface != VK_NULL_HANDLE) {
        vkDestroySurfaceKHR(g_instance, g_surface, NULL);
        g_surface = VK_NULL_HANDLE;
    }

    if (g_window) {
        glfwDestroyWindow(g_window);
        g_window = NULL;
    }

    glfwTerminate();
    printf("Window and surface cleaned up\n");
}

// Get required instance extensions
int32_t get_required_extensions(int32_t* count, const char*** extensions) {
    *extensions = glfwGetRequiredInstanceExtensions((uint32_t*)count);
    return (*extensions != NULL) ? 1 : 0;
}

// Copy extension names to an array (for MoonBit)
int32_t copy_extensions(const char** src, int32_t count, int64_t* dst) {
    for (int32_t i = 0; i < count; i++) {
        size_t len = strlen(src[i]);
        char* str = malloc(len + 1);
        if (!str) return 0;
        strcpy(str, src[i]);
        dst[i] = (int64_t)(uintptr_t)str;
    }
    return 1;
}

// Get shader data pointers
int32_t get_vert_shader_ptr(void) {
    return (int32_t)(intptr_t)vert_spv;
}

int32_t get_frag_shader_ptr(void) {
    return (int32_t)(intptr_t)frag_spv;
}

int32_t get_vert_shader_size(void) {
    return (int32_t)vert_spv_len;
}

int32_t get_frag_shader_size(void) {
    return (int32_t)frag_spv_len;
}
