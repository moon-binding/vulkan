// MoonBit Vulkan Bridge - C FFI bindings for Vulkan
// This file provides simplified Vulkan bindings for MoonBit

// Disable video codec extensions to avoid missing headers
#define VK_NO_VIDEO_CODECS 1

#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>
#include <moonbit.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "shaders_spv.h"

// ============== MoonBit String Conversion ==============

// Convert MoonBit UTF-16 string to C UTF-8 string
static char* moonbit_string_to_cstr(moonbit_string_t str) {
    if (!str) return NULL;
    int32_t len = Moonbit_array_length(str);
    // UTF-8 may need up to 3 bytes per UTF-16 code unit
    char* cstr = (char*)malloc(len * 3 + 1);
    if (!cstr) return NULL;
    
    char* p = cstr;
    for (int32_t i = 0; i < len; i++) {
        uint16_t ch = str[i];
        if (ch < 0x80) {
            *p++ = (char)ch;
        } else if (ch < 0x800) {
            *p++ = (char)(0xC0 | (ch >> 6));
            *p++ = (char)(0x80 | (ch & 0x3F));
        } else {
            *p++ = (char)(0xE0 | (ch >> 12));
            *p++ = (char)(0x80 | ((ch >> 6) & 0x3F));
            *p++ = (char)(0x80 | (ch & 0x3F));
        }
    }
    *p = '\0';
    return cstr;
}

// ============== Vulkan Handles (opaque pointers for MoonBit) ==============

typedef void* VkHandle;

// ============== Application State ==============

typedef struct {
    GLFWwindow* window;
    VkInstance instance;
    VkPhysicalDevice physicalDevice;
    VkDevice device;
    VkQueue graphicsQueue;
    VkQueue presentQueue;
    VkSurfaceKHR surface;
    VkSwapchainKHR swapchain;
    VkImage* swapchainImages;
    VkImageView* swapchainImageViews;
    VkFormat swapchainImageFormat;
    VkExtent2D swapchainExtent;
    uint32_t imageCount;
    VkRenderPass renderPass;
    VkPipelineLayout pipelineLayout;
    VkPipeline graphicsPipeline;
    VkFramebuffer* swapchainFramebuffers;
    VkCommandPool commandPool;
    VkCommandBuffer* commandBuffers;
    VkSemaphore* imageAvailableSemaphores;
    VkSemaphore* renderFinishedSemaphores;
    VkFence* inFlightFences;
    uint32_t currentFrame;
    uint32_t graphicsQueueFamily;
    int framebufferResized;
} VulkanContext;

static VulkanContext* g_ctx = NULL;

// ============== Error Checking ==============

static int check_vk_result(VkResult result, const char* msg) {
    if (result != VK_SUCCESS) {
        fprintf(stderr, "Vulkan Error: %s (code: %d)\n", msg, result);
        return 0;
    }
    return 1;
}

// ============== Window Functions ==============

int moonbit_vk_init_window(int width, int height, const char* title) {
    if (!glfwInit()) {
        fprintf(stderr, "Failed to initialize GLFW\n");
        return 0;
    }

    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    glfwWindowHint(GLFW_RESIZABLE, GLFW_TRUE);

    g_ctx = (VulkanContext*)calloc(1, sizeof(VulkanContext));
    g_ctx->window = glfwCreateWindow(width, height, title, NULL, NULL);

    if (!g_ctx->window) {
        fprintf(stderr, "Failed to create GLFW window\n");
        glfwTerminate();
        return 0;
    }

    g_ctx->framebufferResized = 0;
    printf("Window created: %dx%d - %s\n", width, height, title);
    return 1;
}

// Bridge function for MoonBit window creation
int64_t moonbit_vk_init_window_bridge(const char* title, int width, int height) {
    if (!glfwInit()) {
        fprintf(stderr, "Failed to initialize GLFW (bridge)\n");
        return 0;
    }

    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);

    // Use default title if null
    const char* windowTitle = (title && strlen(title) > 0) ? title : "MoonBit Vulkan";

    GLFWwindow* window = glfwCreateWindow(width, height, windowTitle, NULL, NULL);

    if (!window) {
        fprintf(stderr, "Failed to create GLFW window (bridge)\n");
        glfwTerminate();
        return 0;
    }

    printf("Window created (bridge): %dx%d - %s\n", width, height, windowTitle);
    return (int64_t)window;
}

int moonbit_vk_window_should_close() {
    return glfwWindowShouldClose(g_ctx->window);
}

void moonbit_vk_poll_events() {
    glfwPollEvents();
}

void moonbit_vk_wait_events() {
    glfwWaitEvents();
}

// ============== Vulkan Instance ==============

int moonbit_vk_create_instance(const char* appName) {
    VkApplicationInfo appInfo = {0};
    appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    appInfo.pApplicationName = appName;
    appInfo.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
    appInfo.pEngineName = "MoonBit Vulkan";
    appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
    appInfo.apiVersion = VK_API_VERSION_1_0;

    uint32_t glfwExtensionCount = 0;
    const char** glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount);

    VkInstanceCreateInfo createInfo = {0};
    createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    createInfo.pApplicationInfo = &appInfo;
    createInfo.enabledExtensionCount = glfwExtensionCount;
    createInfo.ppEnabledExtensionNames = glfwExtensions;
    createInfo.enabledLayerCount = 0;

    VkResult result = vkCreateInstance(&createInfo, NULL, &g_ctx->instance);
    if (!check_vk_result(result, "Failed to create Vulkan instance")) {
        return 0;
    }

    printf("Vulkan instance created\n");
    return 1;
}

// Bridge function for MoonBit instance creation
int64_t moonbit_vk_create_instance_bridge(const char* appName) {
    VkApplicationInfo appInfo = {0};
    appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    appInfo.pApplicationName = appName ? appName : "MoonBit Vulkan App";
    appInfo.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
    appInfo.pEngineName = "MoonBit Vulkan";
    appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
    appInfo.apiVersion = VK_API_VERSION_1_0;

    uint32_t glfwExtensionCount = 0;
    const char** glfwExtensions = glfwGetRequiredInstanceExtensions(&glfwExtensionCount);

    printf("GLFW required extensions: %u\n", glfwExtensionCount);
    for (uint32_t i = 0; i < glfwExtensionCount; i++) {
        printf("  %s\n", glfwExtensions[i]);
    }

    VkInstanceCreateInfo createInfo = {0};
    createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    createInfo.pApplicationInfo = &appInfo;
    createInfo.enabledExtensionCount = glfwExtensionCount;
    createInfo.ppEnabledExtensionNames = glfwExtensions;
    createInfo.enabledLayerCount = 0;

    VkInstance instance;
    VkResult result = vkCreateInstance(&createInfo, NULL, &instance);
    if (!check_vk_result(result, "Failed to create Vulkan instance (bridge)")) {
        return 0;
    }

    printf("Vulkan instance created (bridge)\n");
    return (int64_t)instance;
}

// Bridge function for MoonBit surface creation
int64_t moonbit_vk_create_surface_bridge(int64_t instance, int64_t window) {
    VkSurfaceKHR surface = VK_NULL_HANDLE;
    VkResult result = glfwCreateWindowSurface((VkInstance)instance, (GLFWwindow*)window, NULL, &surface);
    if (!check_vk_result(result, "Failed to create window surface (bridge)")) {
        return 0;
    }
    return (int64_t)surface;
}

// ============== Surface ==============

int moonbit_vk_create_surface() {
    VkResult result = glfwCreateWindowSurface(g_ctx->instance, g_ctx->window, NULL, &g_ctx->surface);
    if (!check_vk_result(result, "Failed to create window surface")) {
        return 0;
    }
    printf("Surface created\n");
    return 1;
}

// ============== Physical Device ==============

static uint32_t find_queue_families(VkPhysicalDevice device, uint32_t* presentFamily) {
    uint32_t queueFamilyCount = 0;
    vkGetPhysicalDeviceQueueFamilyProperties(device, &queueFamilyCount, NULL);
    
    VkQueueFamilyProperties* queueFamilies = malloc(queueFamilyCount * sizeof(VkQueueFamilyProperties));
    vkGetPhysicalDeviceQueueFamilyProperties(device, &queueFamilyCount, queueFamilies);
    
    uint32_t graphicsFamily = UINT32_MAX;
    *presentFamily = UINT32_MAX;
    
    for (uint32_t i = 0; i < queueFamilyCount; i++) {
        if (queueFamilies[i].queueFlags & VK_QUEUE_GRAPHICS_BIT) {
            graphicsFamily = i;
        }
        
        VkBool32 presentSupport = VK_FALSE;
        vkGetPhysicalDeviceSurfaceSupportKHR(device, i, g_ctx->surface, &presentSupport);
        if (presentSupport) {
            *presentFamily = i;
        }
        
        if (graphicsFamily != UINT32_MAX && *presentFamily != UINT32_MAX) {
            break;
        }
    }
    
    free(queueFamilies);
    return graphicsFamily;
}

static int is_device_suitable(VkPhysicalDevice device) {
    uint32_t presentFamily;
    uint32_t graphicsFamily = find_queue_families(device, &presentFamily);
    return graphicsFamily != UINT32_MAX;
}

int moonbit_vk_pick_physical_device() {
    uint32_t deviceCount = 0;
    vkEnumeratePhysicalDevices(g_ctx->instance, &deviceCount, NULL);
    
    if (deviceCount == 0) {
        fprintf(stderr, "Failed to find GPUs with Vulkan support\n");
        return 0;
    }
    
    VkPhysicalDevice* devices = malloc(deviceCount * sizeof(VkPhysicalDevice));
    vkEnumeratePhysicalDevices(g_ctx->instance, &deviceCount, devices);
    
    for (uint32_t i = 0; i < deviceCount; i++) {
        if (is_device_suitable(devices[i])) {
            g_ctx->physicalDevice = devices[i];
            break;
        }
    }
    
    free(devices);
    
    if (g_ctx->physicalDevice == VK_NULL_HANDLE) {
        fprintf(stderr, "Failed to find a suitable GPU\n");
        return 0;
    }
    
    VkPhysicalDeviceProperties props;
    vkGetPhysicalDeviceProperties(g_ctx->physicalDevice, &props);
    printf("Physical device selected: %s\n", props.deviceName);
    return 1;
}

// ============== Logical Device ==============

int moonbit_vk_create_logical_device() {
    uint32_t presentFamily;
    uint32_t graphicsFamily = find_queue_families(g_ctx->physicalDevice, &presentFamily);
    g_ctx->graphicsQueueFamily = graphicsFamily;

    float queuePriority = 1.0f;
    VkDeviceQueueCreateInfo queueCreateInfo = {0};
    queueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
    queueCreateInfo.queueFamilyIndex = graphicsFamily;
    queueCreateInfo.queueCount = 1;
    queueCreateInfo.pQueuePriorities = &queuePriority;

    const char* deviceExtensions[] = { VK_KHR_SWAPCHAIN_EXTENSION_NAME };

    VkDeviceCreateInfo createInfo = {0};
    createInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
    createInfo.pQueueCreateInfos = &queueCreateInfo;
    createInfo.queueCreateInfoCount = 1;
    createInfo.enabledExtensionCount = 1;
    createInfo.ppEnabledExtensionNames = deviceExtensions;

    VkResult result = vkCreateDevice(g_ctx->physicalDevice, &createInfo, NULL, &g_ctx->device);
    if (!check_vk_result(result, "Failed to create logical device")) {
        return 0;
    }

    vkGetDeviceQueue(g_ctx->device, graphicsFamily, 0, &g_ctx->graphicsQueue);
    vkGetDeviceQueue(g_ctx->device, presentFamily, 0, &g_ctx->presentQueue);

    printf("Logical device created\n");
    return 1;
}

// Bridge function for MoonBit logical device creation
int64_t moonbit_vk_create_logical_device_bridge(int64_t physicalDevice, uint32_t graphicsFamily, uint32_t presentFamily) {
    printf("Creating logical device (bridge)\n");
    printf("  Physical device: %p\n", (void*)physicalDevice);
    printf("  Graphics family: %u\n", graphicsFamily);
    printf("  Present family: %u\n", presentFamily);

    float queuePriority = 1.0f;
    VkDeviceQueueCreateInfo queueCreateInfo = {0};
    queueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
    queueCreateInfo.queueFamilyIndex = graphicsFamily;
    queueCreateInfo.queueCount = 1;
    queueCreateInfo.pQueuePriorities = &queuePriority;

    const char* deviceExtensions[] = { VK_KHR_SWAPCHAIN_EXTENSION_NAME };
    printf("  Enabling extension: %s\n", VK_KHR_SWAPCHAIN_EXTENSION_NAME);

    VkDeviceCreateInfo createInfo = {0};
    createInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
    createInfo.pQueueCreateInfos = &queueCreateInfo;
    createInfo.queueCreateInfoCount = 1;
    createInfo.enabledExtensionCount = 1;
    createInfo.ppEnabledExtensionNames = deviceExtensions;

    VkDevice device = VK_NULL_HANDLE;
    VkResult result = vkCreateDevice((VkPhysicalDevice)physicalDevice, &createInfo, NULL, &device);
    if (!check_vk_result(result, "Failed to create logical device (bridge)")) {
        return 0;
    }

    printf("Logical device created (bridge)\n");
    return (int64_t)device;
}

// Bridge function to find queue families
int64_t moonbit_vk_find_queue_families_bridge(int64_t physicalDevice, int64_t surface) {
    printf("Finding queue families (bridge)\n");
    printf("  Physical device: %p\n", (void*)physicalDevice);
    printf("  Surface: %p\n", (void*)surface);

    uint32_t queueFamilyCount = 0;
    vkGetPhysicalDeviceQueueFamilyProperties((VkPhysicalDevice)physicalDevice, &queueFamilyCount, NULL);

    printf("  Queue family count: %u\n", queueFamilyCount);

    VkQueueFamilyProperties* queueFamilies = malloc(queueFamilyCount * sizeof(VkQueueFamilyProperties));
    vkGetPhysicalDeviceQueueFamilyProperties((VkPhysicalDevice)physicalDevice, &queueFamilyCount, queueFamilies);

    uint32_t graphicsFamily = UINT32_MAX;
    uint32_t presentFamily = UINT32_MAX;

    for (uint32_t i = 0; i < queueFamilyCount; i++) {
        if (queueFamilies[i].queueFlags & VK_QUEUE_GRAPHICS_BIT) {
            graphicsFamily = i;
        }

        VkBool32 presentSupport = VK_FALSE;
        vkGetPhysicalDeviceSurfaceSupportKHR((VkPhysicalDevice)physicalDevice, i, (VkSurfaceKHR)surface, &presentSupport);
        if (presentSupport) {
            presentFamily = i;
        }

        if (graphicsFamily != UINT32_MAX && presentFamily != UINT32_MAX) {
            break;
        }
    }

    free(queueFamilies);

    if (graphicsFamily == UINT32_MAX) {
        fprintf(stderr, "No graphics queue family found\n");
        return 0;
    }

    if (presentFamily == UINT32_MAX) {
        fprintf(stderr, "No present queue family found\n");
        return 0;
    }

    printf("  Graphics family: %u\n", graphicsFamily);
    printf("  Present family: %u\n", presentFamily);

    // Pack both values into 64-bit: lower 32 bits = graphics, upper 32 bits = present
    return ((int64_t)presentFamily << 32) | graphicsFamily;
}

// Bridge function for MoonBit swapchain creation
int64_t moonbit_vk_create_swapchain_bridge(int64_t physicalDevice, int64_t device, int64_t surface) {
    printf("Creating swapchain (bridge)\n");
    printf("  Physical device: %p\n", (void*)physicalDevice);
    printf("  Device: %p\n", (void*)device);
    printf("  Surface: %p\n", (void*)surface);

    VkSurfaceCapabilitiesKHR caps;
    vkGetPhysicalDeviceSurfaceCapabilitiesKHR((VkPhysicalDevice)physicalDevice, (VkSurfaceKHR)surface, &caps);

    uint32_t formatCount;
    vkGetPhysicalDeviceSurfaceFormatsKHR((VkPhysicalDevice)physicalDevice, (VkSurfaceKHR)surface, &formatCount, NULL);
    VkSurfaceFormatKHR* formats = malloc(formatCount * sizeof(VkSurfaceFormatKHR));
    vkGetPhysicalDeviceSurfaceFormatsKHR((VkPhysicalDevice)physicalDevice, (VkSurfaceKHR)surface, &formatCount, formats);

    uint32_t modeCount;
    vkGetPhysicalDeviceSurfacePresentModesKHR((VkPhysicalDevice)physicalDevice, (VkSurfaceKHR)surface, &modeCount, NULL);
    VkPresentModeKHR* modes = malloc(modeCount * sizeof(VkPresentModeKHR));
    vkGetPhysicalDeviceSurfacePresentModesKHR((VkPhysicalDevice)physicalDevice, (VkSurfaceKHR)surface, &modeCount, modes);

    // Choose swap surface format
    VkSurfaceFormatKHR surfaceFormat = formats[0];
    for (uint32_t i = 0; i < formatCount; i++) {
        if (formats[i].format == VK_FORMAT_B8G8R8A8_SRGB &&
            formats[i].colorSpace == VK_COLOR_SPACE_SRGB_NONLINEAR_KHR) {
            surfaceFormat = formats[i];
            break;
        }
    }

    // Choose present mode
    VkPresentModeKHR presentMode = VK_PRESENT_MODE_FIFO_KHR;
    for (uint32_t i = 0; i < modeCount; i++) {
        if (modes[i] == VK_PRESENT_MODE_MAILBOX_KHR) {
            presentMode = VK_PRESENT_MODE_MAILBOX_KHR;
            break;
        }
    }

    // Choose extent
    VkExtent2D extent = caps.currentExtent;
    if (extent.width == UINT32_MAX) {
        extent.width = (caps.minImageExtent.width > caps.maxImageExtent.width) ?
                       caps.maxImageExtent.width : caps.minImageExtent.width;
        extent.height = (caps.minImageExtent.height > caps.maxImageExtent.height) ?
                        caps.maxImageExtent.height : caps.minImageExtent.height;
    }

    printf("  Selected format: %u\n", surfaceFormat.format);
    printf("  Selected extent: %ux%u\n", extent.width, extent.height);
    printf("  Present mode: %u\n", presentMode);

    uint32_t imageCount = caps.minImageCount + 1;
    if (caps.maxImageCount > 0 && imageCount > caps.maxImageCount) {
        imageCount = caps.maxImageCount;
    }

    printf("  Image count: %u\n", imageCount);

    VkSwapchainCreateInfoKHR createInfo = {0};
    createInfo.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
    createInfo.surface = (VkSurfaceKHR)surface;
    createInfo.minImageCount = imageCount;
    createInfo.imageFormat = surfaceFormat.format;
    createInfo.imageColorSpace = surfaceFormat.colorSpace;
    createInfo.imageExtent = extent;
    createInfo.imageArrayLayers = 1;
    createInfo.imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
    createInfo.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
    createInfo.preTransform = caps.currentTransform;
    createInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
    createInfo.presentMode = presentMode;
    createInfo.clipped = VK_TRUE;
    createInfo.oldSwapchain = VK_NULL_HANDLE;

    VkSwapchainKHR swapchain = VK_NULL_HANDLE;
    VkResult result = vkCreateSwapchainKHR((VkDevice)device, &createInfo, NULL, &swapchain);

    free(formats);
    free(modes);

    if (!check_vk_result(result, "Failed to create swapchain (bridge)")) {
        return 0;
    }

    printf("Swapchain created (bridge)\n");

    // Store swapchain info in a global structure for later retrieval
    // For simplicity, we return the swapchain handle and image count packed
    // Lower 48 bits: swapchain handle, upper 16 bits: image count (limited to 65535)
    if (imageCount > 65535) {
        fprintf(stderr, "Image count too large to pack\n");
        return 0;
    }

    return ((int64_t)imageCount << 48) | (int64_t)swapchain;
}

// Bridge function to get swapchain images
int64_t moonbit_vk_get_swapchain_images_bridge(int64_t device, int64_t swapchain) {
    printf("Getting swapchain images (bridge)\n");

    uint32_t imageCount = 0;
    vkGetSwapchainImagesKHR((VkDevice)device, (VkSwapchainKHR)swapchain, &imageCount, NULL);

    printf("  Image count: %u\n", imageCount);

    VkImage* images = malloc(imageCount * sizeof(VkImage));
    vkGetSwapchainImagesKHR((VkDevice)device, (VkSwapchainKHR)swapchain, &imageCount, images);

    // Return pointer to images array
    printf("Swapchain images retrieved (bridge)\n");
    return (int64_t)images;
}

// Bridge function to destroy swapchain
int moonbit_vk_destroy_swapchain_bridge(int64_t device, int64_t swapchain) {
    printf("Destroying swapchain (bridge)\n");
    vkDestroySwapchainKHR((VkDevice)device, (VkSwapchainKHR)swapchain, NULL);
    printf("Swapchain destroyed (bridge)\n");
    return 1;
}

// Bridge function for MoonBit image views creation
int64_t moonbit_vk_create_image_views_bridge(int64_t device, int64_t swapchain, int format, int imageCount) {
    printf("Creating image views (bridge)\n");
    printf("  Device: %p\n", (void*)device);
    printf("  Swapchain: %p\n", (void*)swapchain);
    printf("  Format: %d\n", format);
    printf("  Image count: %d\n", imageCount);

    // Get swapchain images
    uint32_t swapchainImageCount = 0;
    vkGetSwapchainImagesKHR((VkDevice)device, (VkSwapchainKHR)swapchain, &swapchainImageCount, NULL);

    VkImage* swapchainImages = malloc(swapchainImageCount * sizeof(VkImage));
    vkGetSwapchainImagesKHR((VkDevice)device, (VkSwapchainKHR)swapchain, &swapchainImageCount, swapchainImages);

    // Create image views
    VkImageView* swapchainImageViews = malloc(swapchainImageCount * sizeof(VkImageView));

    for (uint32_t i = 0; i < swapchainImageCount; i++) {
        VkImageViewCreateInfo createInfo = {0};
        createInfo.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
        createInfo.image = swapchainImages[i];
        createInfo.viewType = VK_IMAGE_VIEW_TYPE_2D;
        createInfo.format = (VkFormat)format;
        createInfo.components.r = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.components.g = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.components.b = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.components.a = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
        createInfo.subresourceRange.baseMipLevel = 0;
        createInfo.subresourceRange.levelCount = 1;
        createInfo.subresourceRange.baseArrayLayer = 0;
        createInfo.subresourceRange.layerCount = 1;

        VkResult result = vkCreateImageView((VkDevice)device, &createInfo, NULL, &swapchainImageViews[i]);
        if (!check_vk_result(result, "Failed to create image view (bridge)")) {
            free(swapchainImages);
            free(swapchainImageViews);
            return 0;
        }
    }

    free(swapchainImages);

    printf("Image views created (bridge)\n");
    return (int64_t)swapchainImageViews;
}

// Bridge function to destroy image views
int moonbit_vk_destroy_image_views_bridge(int64_t device, int64_t imageViews, int imageCount) {
    printf("Destroying image views (bridge)\n");

    VkImageView* views = (VkImageView*)imageViews;
    for (int i = 0; i < imageCount; i++) {
        vkDestroyImageView((VkDevice)device, views[i], NULL);
    }

    free(views);
    printf("Image views destroyed (bridge)\n");
    return 1;
}

// Bridge function for MoonBit render pass creation
int64_t moonbit_vk_create_render_pass_bridge(int64_t device, int format) {
    printf("Creating render pass (bridge)\n");
    printf("  Device: %p\n", (void*)device);
    printf("  Format: %d\n", format);

    VkAttachmentDescription colorAttachment = {0};
    colorAttachment.format = (VkFormat)format;
    colorAttachment.samples = VK_SAMPLE_COUNT_1_BIT;
    colorAttachment.loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
    colorAttachment.storeOp = VK_ATTACHMENT_STORE_OP_STORE;
    colorAttachment.stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
    colorAttachment.stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
    colorAttachment.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
    colorAttachment.finalLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;

    VkAttachmentReference colorAttachmentRef = {0};
    colorAttachmentRef.attachment = 0;
    colorAttachmentRef.layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

    VkSubpassDescription subpass = {0};
    subpass.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS;
    subpass.colorAttachmentCount = 1;
    subpass.pColorAttachments = &colorAttachmentRef;

    VkRenderPassCreateInfo createInfo = {0};
    createInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
    createInfo.attachmentCount = 1;
    createInfo.pAttachments = &colorAttachment;
    createInfo.subpassCount = 1;
    createInfo.pSubpasses = &subpass;

    VkRenderPass renderPass = VK_NULL_HANDLE;
    VkResult result = vkCreateRenderPass((VkDevice)device, &createInfo, NULL, &renderPass);
    if (!check_vk_result(result, "Failed to create render pass (bridge)")) {
        return 0;
    }

    printf("Render pass created (bridge)\n");
    return (int64_t)renderPass;
}

// Bridge function to destroy render pass
int moonbit_vk_destroy_render_pass_bridge(int64_t device, int64_t renderPass) {
    printf("Destroying render pass (bridge)\n");
    vkDestroyRenderPass((VkDevice)device, (VkRenderPass)renderPass, NULL);
    printf("Render pass destroyed (bridge)\n");
    return 1;
}

// ============== Swapchain ==============

static VkSurfaceFormatKHR choose_swap_surface_format(VkSurfaceFormatKHR* formats, uint32_t count) {
    for (uint32_t i = 0; i < count; i++) {
        if (formats[i].format == VK_FORMAT_B8G8R8A8_SRGB && 
            formats[i].colorSpace == VK_COLOR_SPACE_SRGB_NONLINEAR_KHR) {
            return formats[i];
        }
    }
    return formats[0];
}

static VkPresentModeKHR choose_swap_present_mode(VkPresentModeKHR* modes, uint32_t count) {
    for (uint32_t i = 0; i < count; i++) {
        if (modes[i] == VK_PRESENT_MODE_MAILBOX_KHR) {
            return modes[i];
        }
    }
    return VK_PRESENT_MODE_FIFO_KHR;
}

static VkExtent2D choose_swap_extent(const VkSurfaceCapabilitiesKHR* caps, GLFWwindow* window) {
    if (caps->currentExtent.width != UINT32_MAX) {
        return caps->currentExtent;
    }
    
    int width, height;
    glfwGetFramebufferSize(window, &width, &height);
    
    VkExtent2D extent = {
        .width = (width > (int)caps->maxImageExtent.width) ? caps->maxImageExtent.width : 
                 (width < (int)caps->minImageExtent.width) ? caps->minImageExtent.width : (uint32_t)width,
        .height = (height > (int)caps->maxImageExtent.height) ? caps->maxImageExtent.height :
                  (height < (int)caps->minImageExtent.height) ? caps->minImageExtent.height : (uint32_t)height
    };
    return extent;
}

int moonbit_vk_create_swapchain() {
    VkSurfaceCapabilitiesKHR caps;
    vkGetPhysicalDeviceSurfaceCapabilitiesKHR(g_ctx->physicalDevice, g_ctx->surface, &caps);
    
    uint32_t formatCount;
    vkGetPhysicalDeviceSurfaceFormatsKHR(g_ctx->physicalDevice, g_ctx->surface, &formatCount, NULL);
    VkSurfaceFormatKHR* formats = malloc(formatCount * sizeof(VkSurfaceFormatKHR));
    vkGetPhysicalDeviceSurfaceFormatsKHR(g_ctx->physicalDevice, g_ctx->surface, &formatCount, formats);
    
    uint32_t modeCount;
    vkGetPhysicalDeviceSurfacePresentModesKHR(g_ctx->physicalDevice, g_ctx->surface, &modeCount, NULL);
    VkPresentModeKHR* modes = malloc(modeCount * sizeof(VkPresentModeKHR));
    vkGetPhysicalDeviceSurfacePresentModesKHR(g_ctx->physicalDevice, g_ctx->surface, &modeCount, modes);
    
    VkSurfaceFormatKHR surfaceFormat = choose_swap_surface_format(formats, formatCount);
    VkPresentModeKHR presentMode = choose_swap_present_mode(modes, modeCount);
    VkExtent2D extent = choose_swap_extent(&caps, g_ctx->window);
    
    uint32_t imageCount = caps.minImageCount + 1;
    if (caps.maxImageCount > 0 && imageCount > caps.maxImageCount) {
        imageCount = caps.maxImageCount;
    }
    
    VkSwapchainCreateInfoKHR createInfo = {0};
    createInfo.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
    createInfo.surface = g_ctx->surface;
    createInfo.minImageCount = imageCount;
    createInfo.imageFormat = surfaceFormat.format;
    createInfo.imageColorSpace = surfaceFormat.colorSpace;
    createInfo.imageExtent = extent;
    createInfo.imageArrayLayers = 1;
    createInfo.imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
    createInfo.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
    createInfo.preTransform = caps.currentTransform;
    createInfo.compositeAlpha = VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
    createInfo.presentMode = presentMode;
    createInfo.clipped = VK_TRUE;
    createInfo.oldSwapchain = VK_NULL_HANDLE;
    
    VkResult result = vkCreateSwapchainKHR(g_ctx->device, &createInfo, NULL, &g_ctx->swapchain);
    free(formats);
    free(modes);
    
    if (!check_vk_result(result, "Failed to create swapchain")) {
        return 0;
    }
    
    vkGetSwapchainImagesKHR(g_ctx->device, g_ctx->swapchain, &imageCount, NULL);
    g_ctx->swapchainImages = malloc(imageCount * sizeof(VkImage));
    vkGetSwapchainImagesKHR(g_ctx->device, g_ctx->swapchain, &imageCount, g_ctx->swapchainImages);
    g_ctx->imageCount = imageCount;
    g_ctx->swapchainImageFormat = surfaceFormat.format;
    g_ctx->swapchainExtent = extent;
    
    printf("Swapchain created: %ux%u, %u images\n", extent.width, extent.height, imageCount);
    return 1;
}

// ============== Image Views ==============

int moonbit_vk_create_image_views() {
    g_ctx->swapchainImageViews = malloc(g_ctx->imageCount * sizeof(VkImageView));
    
    for (uint32_t i = 0; i < g_ctx->imageCount; i++) {
        VkImageViewCreateInfo createInfo = {0};
        createInfo.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
        createInfo.image = g_ctx->swapchainImages[i];
        createInfo.viewType = VK_IMAGE_VIEW_TYPE_2D;
        createInfo.format = g_ctx->swapchainImageFormat;
        createInfo.components.r = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.components.g = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.components.b = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.components.a = VK_COMPONENT_SWIZZLE_IDENTITY;
        createInfo.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
        createInfo.subresourceRange.baseMipLevel = 0;
        createInfo.subresourceRange.levelCount = 1;
        createInfo.subresourceRange.baseArrayLayer = 0;
        createInfo.subresourceRange.layerCount = 1;
        
        VkResult result = vkCreateImageView(g_ctx->device, &createInfo, NULL, &g_ctx->swapchainImageViews[i]);
        if (!check_vk_result(result, "Failed to create image view")) {
            return 0;
        }
    }
    
    printf("Image views created\n");
    return 1;
}

// ============== Render Pass ==============

int moonbit_vk_create_render_pass() {
    VkAttachmentDescription colorAttachment = {0};
    colorAttachment.format = g_ctx->swapchainImageFormat;
    colorAttachment.samples = VK_SAMPLE_COUNT_1_BIT;
    colorAttachment.loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
    colorAttachment.storeOp = VK_ATTACHMENT_STORE_OP_STORE;
    colorAttachment.stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
    colorAttachment.stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
    colorAttachment.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
    colorAttachment.finalLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
    
    VkAttachmentReference colorAttachmentRef = {0};
    colorAttachmentRef.attachment = 0;
    colorAttachmentRef.layout = VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;
    
    VkSubpassDescription subpass = {0};
    subpass.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS;
    subpass.colorAttachmentCount = 1;
    subpass.pColorAttachments = &colorAttachmentRef;
    
    VkRenderPassCreateInfo createInfo = {0};
    createInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
    createInfo.attachmentCount = 1;
    createInfo.pAttachments = &colorAttachment;
    createInfo.subpassCount = 1;
    createInfo.pSubpasses = &subpass;
    
    VkResult result = vkCreateRenderPass(g_ctx->device, &createInfo, NULL, &g_ctx->renderPass);
    if (!check_vk_result(result, "Failed to create render pass")) {
        return 0;
    }
    
    printf("Render pass created\n");
    return 1;
}

// ============== Graphics Pipeline ==============

static VkShaderModule create_shader_module(const uint32_t* code, size_t size) {
    VkShaderModuleCreateInfo createInfo = {0};
    createInfo.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
    createInfo.codeSize = size;
    createInfo.pCode = code;
    
    VkShaderModule shaderModule;
    vkCreateShaderModule(g_ctx->device, &createInfo, NULL, &shaderModule);
    return shaderModule;
}

int moonbit_vk_create_graphics_pipeline() {
    VkShaderModule vertModule = create_shader_module(vert_shader_spv, vert_shader_size);
    VkShaderModule fragModule = create_shader_module(frag_shader_spv, frag_shader_size);
    
    VkPipelineShaderStageCreateInfo vertStageInfo = {0};
    vertStageInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
    vertStageInfo.stage = VK_SHADER_STAGE_VERTEX_BIT;
    vertStageInfo.module = vertModule;
    vertStageInfo.pName = "main";
    
    VkPipelineShaderStageCreateInfo fragStageInfo = {0};
    fragStageInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
    fragStageInfo.stage = VK_SHADER_STAGE_FRAGMENT_BIT;
    fragStageInfo.module = fragModule;
    fragStageInfo.pName = "main";
    
    VkPipelineShaderStageCreateInfo shaderStages[] = { vertStageInfo, fragStageInfo };
    
    VkPipelineVertexInputStateCreateInfo vertexInputInfo = {0};
    vertexInputInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
    
    VkPipelineInputAssemblyStateCreateInfo inputAssembly = {0};
    inputAssembly.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
    inputAssembly.topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
    inputAssembly.primitiveRestartEnable = VK_FALSE;
    
    VkViewport viewport = {0};
    viewport.x = 0.0f;
    viewport.y = 0.0f;
    viewport.width = (float)g_ctx->swapchainExtent.width;
    viewport.height = (float)g_ctx->swapchainExtent.height;
    viewport.minDepth = 0.0f;
    viewport.maxDepth = 1.0f;
    
    VkRect2D scissor = {0};
    scissor.offset = (VkOffset2D){0, 0};
    scissor.extent = g_ctx->swapchainExtent;
    
    VkPipelineViewportStateCreateInfo viewportState = {0};
    viewportState.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
    viewportState.viewportCount = 1;
    viewportState.pViewports = &viewport;
    viewportState.scissorCount = 1;
    viewportState.pScissors = &scissor;
    
    VkPipelineRasterizationStateCreateInfo rasterizer = {0};
    rasterizer.sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
    rasterizer.depthClampEnable = VK_FALSE;
    rasterizer.rasterizerDiscardEnable = VK_FALSE;
    rasterizer.polygonMode = VK_POLYGON_MODE_FILL;
    rasterizer.lineWidth = 1.0f;
    rasterizer.cullMode = VK_CULL_MODE_BACK_BIT;
    rasterizer.frontFace = VK_FRONT_FACE_CLOCKWISE;
    
    VkPipelineMultisampleStateCreateInfo multisampling = {0};
    multisampling.sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
    multisampling.sampleShadingEnable = VK_FALSE;
    multisampling.rasterizationSamples = VK_SAMPLE_COUNT_1_BIT;
    
    VkPipelineColorBlendAttachmentState colorBlendAttachment = {0};
    colorBlendAttachment.colorWriteMask = VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT |
                                           VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT;
    colorBlendAttachment.blendEnable = VK_FALSE;
    
    VkPipelineColorBlendStateCreateInfo colorBlending = {0};
    colorBlending.sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
    colorBlending.logicOpEnable = VK_FALSE;
    colorBlending.attachmentCount = 1;
    colorBlending.pAttachments = &colorBlendAttachment;
    
    VkPipelineLayoutCreateInfo pipelineLayoutInfo = {0};
    pipelineLayoutInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
    
    vkCreatePipelineLayout(g_ctx->device, &pipelineLayoutInfo, NULL, &g_ctx->pipelineLayout);
    
    VkGraphicsPipelineCreateInfo pipelineInfo = {0};
    pipelineInfo.sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
    pipelineInfo.stageCount = 2;
    pipelineInfo.pStages = shaderStages;
    pipelineInfo.pVertexInputState = &vertexInputInfo;
    pipelineInfo.pInputAssemblyState = &inputAssembly;
    pipelineInfo.pViewportState = &viewportState;
    pipelineInfo.pRasterizationState = &rasterizer;
    pipelineInfo.pMultisampleState = &multisampling;
    pipelineInfo.pColorBlendState = &colorBlending;
    pipelineInfo.layout = g_ctx->pipelineLayout;
    pipelineInfo.renderPass = g_ctx->renderPass;
    pipelineInfo.subpass = 0;
    
    VkResult result = vkCreateGraphicsPipelines(g_ctx->device, VK_NULL_HANDLE, 1, &pipelineInfo, NULL, &g_ctx->graphicsPipeline);
    
    vkDestroyShaderModule(g_ctx->device, vertModule, NULL);
    vkDestroyShaderModule(g_ctx->device, fragModule, NULL);
    
    if (!check_vk_result(result, "Failed to create graphics pipeline")) {
        return 0;
    }
    
    printf("Graphics pipeline created\n");
    return 1;
}

// ============== Framebuffers ==============

int moonbit_vk_create_framebuffers() {
    g_ctx->swapchainFramebuffers = malloc(g_ctx->imageCount * sizeof(VkFramebuffer));
    
    for (uint32_t i = 0; i < g_ctx->imageCount; i++) {
        VkImageView attachments[] = { g_ctx->swapchainImageViews[i] };
        
        VkFramebufferCreateInfo framebufferInfo = {0};
        framebufferInfo.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
        framebufferInfo.renderPass = g_ctx->renderPass;
        framebufferInfo.attachmentCount = 1;
        framebufferInfo.pAttachments = attachments;
        framebufferInfo.width = g_ctx->swapchainExtent.width;
        framebufferInfo.height = g_ctx->swapchainExtent.height;
        framebufferInfo.layers = 1;
        
        VkResult result = vkCreateFramebuffer(g_ctx->device, &framebufferInfo, NULL, &g_ctx->swapchainFramebuffers[i]);
        if (!check_vk_result(result, "Failed to create framebuffer")) {
            return 0;
        }
    }
    
    printf("Framebuffers created\n");
    return 1;
}

// ============== Command Pool & Buffer ==============

int moonbit_vk_create_command_pool() {
    VkCommandPoolCreateInfo poolInfo = {0};
    poolInfo.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
    poolInfo.queueFamilyIndex = g_ctx->graphicsQueueFamily;
    poolInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
    
    VkResult result = vkCreateCommandPool(g_ctx->device, &poolInfo, NULL, &g_ctx->commandPool);
    if (!check_vk_result(result, "Failed to create command pool")) {
        return 0;
    }
    
    printf("Command pool created\n");
    return 1;
}

int moonbit_vk_create_command_buffers() {
    g_ctx->commandBuffers = malloc(g_ctx->imageCount * sizeof(VkCommandBuffer));
    
    VkCommandBufferAllocateInfo allocInfo = {0};
    allocInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
    allocInfo.commandPool = g_ctx->commandPool;
    allocInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
    allocInfo.commandBufferCount = g_ctx->imageCount;
    
    VkResult result = vkAllocateCommandBuffers(g_ctx->device, &allocInfo, g_ctx->commandBuffers);
    if (!check_vk_result(result, "Failed to allocate command buffers")) {
        return 0;
    }
    
    printf("Command buffers created\n");
    return 1;
}

// ============== Sync Objects ==============

#define MAX_FRAMES_IN_FLIGHT 2

int moonbit_vk_create_sync_objects() {
    g_ctx->imageAvailableSemaphores = malloc(MAX_FRAMES_IN_FLIGHT * sizeof(VkSemaphore));
    g_ctx->renderFinishedSemaphores = malloc(MAX_FRAMES_IN_FLIGHT * sizeof(VkSemaphore));
    g_ctx->inFlightFences = malloc(MAX_FRAMES_IN_FLIGHT * sizeof(VkFence));
    g_ctx->currentFrame = 0;
    
    VkSemaphoreCreateInfo semaphoreInfo = {0};
    semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
    
    VkFenceCreateInfo fenceInfo = {0};
    fenceInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
    fenceInfo.flags = VK_FENCE_CREATE_SIGNALED_BIT;
    
    for (int i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vkCreateSemaphore(g_ctx->device, &semaphoreInfo, NULL, &g_ctx->imageAvailableSemaphores[i]);
        vkCreateSemaphore(g_ctx->device, &semaphoreInfo, NULL, &g_ctx->renderFinishedSemaphores[i]);
        vkCreateFence(g_ctx->device, &fenceInfo, NULL, &g_ctx->inFlightFences[i]);
    }
    
    printf("Sync objects created\n");
    return 1;
}

// ============== Recording Commands ==============

void moonbit_vk_record_command_buffer(uint32_t imageIndex) {
    VkCommandBufferBeginInfo beginInfo = {0};
    beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
    
    vkBeginCommandBuffer(g_ctx->commandBuffers[imageIndex], &beginInfo);
    
    VkClearValue clearColor = {{{0.0f, 0.0f, 0.0f, 1.0f}}};
    
    VkRenderPassBeginInfo renderPassInfo = {0};
    renderPassInfo.sType = VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
    renderPassInfo.renderPass = g_ctx->renderPass;
    renderPassInfo.framebuffer = g_ctx->swapchainFramebuffers[imageIndex];
    renderPassInfo.renderArea.offset = (VkOffset2D){0, 0};
    renderPassInfo.renderArea.extent = g_ctx->swapchainExtent;
    renderPassInfo.clearValueCount = 1;
    renderPassInfo.pClearValues = &clearColor;
    
    vkCmdBeginRenderPass(g_ctx->commandBuffers[imageIndex], &renderPassInfo, VK_SUBPASS_CONTENTS_INLINE);
    
    vkCmdBindPipeline(g_ctx->commandBuffers[imageIndex], VK_PIPELINE_BIND_POINT_GRAPHICS, g_ctx->graphicsPipeline);
    
    vkCmdDraw(g_ctx->commandBuffers[imageIndex], 3, 1, 0, 0);
    
    vkCmdEndRenderPass(g_ctx->commandBuffers[imageIndex]);
    
    vkEndCommandBuffer(g_ctx->commandBuffers[imageIndex]);
}

// ============== Draw Frame ==============

void moonbit_vk_draw_frame() {
    vkWaitForFences(g_ctx->device, 1, &g_ctx->inFlightFences[g_ctx->currentFrame], VK_TRUE, UINT64_MAX);
    
    uint32_t imageIndex;
    VkResult result = vkAcquireNextImageKHR(g_ctx->device, g_ctx->swapchain, UINT64_MAX,
        g_ctx->imageAvailableSemaphores[g_ctx->currentFrame], VK_NULL_HANDLE, &imageIndex);
    
    if (result == VK_ERROR_OUT_OF_DATE_KHR) {
        return;
    }
    
    vkResetFences(g_ctx->device, 1, &g_ctx->inFlightFences[g_ctx->currentFrame]);
    
    vkResetCommandBuffer(g_ctx->commandBuffers[imageIndex], 0);
    moonbit_vk_record_command_buffer(imageIndex);
    
    VkSemaphore waitSemaphores[] = { g_ctx->imageAvailableSemaphores[g_ctx->currentFrame] };
    VkPipelineStageFlags waitStages[] = { VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT };
    VkSemaphore signalSemaphores[] = { g_ctx->renderFinishedSemaphores[g_ctx->currentFrame] };
    
    VkSubmitInfo submitInfo = {0};
    submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
    submitInfo.waitSemaphoreCount = 1;
    submitInfo.pWaitSemaphores = waitSemaphores;
    submitInfo.pWaitDstStageMask = waitStages;
    submitInfo.commandBufferCount = 1;
    submitInfo.pCommandBuffers = &g_ctx->commandBuffers[imageIndex];
    submitInfo.signalSemaphoreCount = 1;
    submitInfo.pSignalSemaphores = signalSemaphores;
    
    vkQueueSubmit(g_ctx->graphicsQueue, 1, &submitInfo, g_ctx->inFlightFences[g_ctx->currentFrame]);
    
    VkPresentInfoKHR presentInfo = {0};
    presentInfo.sType = VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
    presentInfo.waitSemaphoreCount = 1;
    presentInfo.pWaitSemaphores = signalSemaphores;
    presentInfo.swapchainCount = 1;
    presentInfo.pSwapchains = &g_ctx->swapchain;
    presentInfo.pImageIndices = &imageIndex;
    
    vkQueuePresentKHR(g_ctx->presentQueue, &presentInfo);

    g_ctx->currentFrame = (g_ctx->currentFrame + 1) % MAX_FRAMES_IN_FLIGHT;
}

// ============== MoonBit Bridge Functions for Phases 10-13 ==============

// Bridge function for graphics pipeline creation
int64_t moonbit_vk_create_graphics_pipeline_bridge(int64_t device, int64_t renderPass, int extentWidth, int extentHeight) {
    printf("Creating graphics pipeline (bridge)\n");
    printf("  Device: %p, RenderPass: %p\n", (void*)device, (void*)renderPass);

    // Load shaders (embedded in shaders_spv.h)
    VkShaderModule vertModule;
    VkShaderModule fragModule;

    VkShaderModuleCreateInfo vertInfo = {0};
    vertInfo.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
    vertInfo.codeSize = vert_shader_size;
    vertInfo.pCode = vert_shader_spv;
    if (vkCreateShaderModule((VkDevice)device, &vertInfo, NULL, &vertModule) != VK_SUCCESS) {
        return 0;
    }

    VkShaderModuleCreateInfo fragInfo = {0};
    fragInfo.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
    fragInfo.codeSize = frag_shader_size;
    fragInfo.pCode = frag_shader_spv;
    if (vkCreateShaderModule((VkDevice)device, &fragInfo, NULL, &fragModule) != VK_SUCCESS) {
        vkDestroyShaderModule((VkDevice)device, vertModule, NULL);
        return 0;
    }

    VkPipelineShaderStageCreateInfo vertStageInfo = {0};
    vertStageInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
    vertStageInfo.stage = VK_SHADER_STAGE_VERTEX_BIT;
    vertStageInfo.module = vertModule;
    vertStageInfo.pName = "main";

    VkPipelineShaderStageCreateInfo fragStageInfo = {0};
    fragStageInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
    fragStageInfo.stage = VK_SHADER_STAGE_FRAGMENT_BIT;
    fragStageInfo.module = fragModule;
    fragStageInfo.pName = "main";

    VkPipelineShaderStageCreateInfo shaderStages[] = { vertStageInfo, fragStageInfo };

    VkPipelineVertexInputStateCreateInfo vertexInputInfo = {0};
    vertexInputInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;

    VkPipelineInputAssemblyStateCreateInfo inputAssembly = {0};
    inputAssembly.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
    inputAssembly.topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;

    VkViewport viewport = {0};
    viewport.x = 0.0f;
    viewport.y = 0.0f;
    viewport.width = (float)extentWidth;
    viewport.height = (float)extentHeight;
    viewport.minDepth = 0.0f;
    viewport.maxDepth = 1.0f;

    VkRect2D scissor = {0};
    scissor.offset.x = 0;
    scissor.offset.y = 0;
    scissor.extent.width = extentWidth;
    scissor.extent.height = extentHeight;

    VkPipelineViewportStateCreateInfo viewportState = {0};
    viewportState.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
    viewportState.viewportCount = 1;
    viewportState.pViewports = &viewport;
    viewportState.scissorCount = 1;
    viewportState.pScissors = &scissor;

    VkPipelineRasterizationStateCreateInfo rasterizer = {0};
    rasterizer.sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
    rasterizer.polygonMode = VK_POLYGON_MODE_FILL;
    rasterizer.lineWidth = 1.0f;
    rasterizer.cullMode = VK_CULL_MODE_BACK_BIT;
    rasterizer.frontFace = VK_FRONT_FACE_CLOCKWISE;

    VkPipelineMultisampleStateCreateInfo multisampling = {0};
    multisampling.sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
    multisampling.rasterizationSamples = VK_SAMPLE_COUNT_1_BIT;

    VkPipelineColorBlendAttachmentState colorBlendAttachment = {0};
    colorBlendAttachment.colorWriteMask = VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT |
                                           VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT;

    VkPipelineColorBlendStateCreateInfo colorBlending = {0};
    colorBlending.sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
    colorBlending.attachmentCount = 1;
    colorBlending.pAttachments = &colorBlendAttachment;

    VkPipelineLayoutCreateInfo pipelineLayoutInfo = {0};
    pipelineLayoutInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;

    VkPipelineLayout pipelineLayout;
    if (vkCreatePipelineLayout((VkDevice)device, &pipelineLayoutInfo, NULL, &pipelineLayout) != VK_SUCCESS) {
        vkDestroyShaderModule((VkDevice)device, fragModule, NULL);
        vkDestroyShaderModule((VkDevice)device, vertModule, NULL);
        return 0;
    }

    VkGraphicsPipelineCreateInfo pipelineInfo = {0};
    pipelineInfo.sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
    pipelineInfo.stageCount = 2;
    pipelineInfo.pStages = shaderStages;
    pipelineInfo.pVertexInputState = &vertexInputInfo;
    pipelineInfo.pInputAssemblyState = &inputAssembly;
    pipelineInfo.pViewportState = &viewportState;
    pipelineInfo.pRasterizationState = &rasterizer;
    pipelineInfo.pMultisampleState = &multisampling;
    pipelineInfo.pColorBlendState = &colorBlending;
    pipelineInfo.layout = pipelineLayout;
    pipelineInfo.renderPass = (VkRenderPass)renderPass;
    pipelineInfo.subpass = 0;

    VkPipeline graphicsPipeline;
    if (vkCreateGraphicsPipelines((VkDevice)device, VK_NULL_HANDLE, 1, &pipelineInfo, NULL, &graphicsPipeline) != VK_SUCCESS) {
        vkDestroyPipelineLayout((VkDevice)device, pipelineLayout, NULL);
        vkDestroyShaderModule((VkDevice)device, fragModule, NULL);
        vkDestroyShaderModule((VkDevice)device, vertModule, NULL);
        return 0;
    }

    vkDestroyShaderModule((VkDevice)device, fragModule, NULL);
    vkDestroyShaderModule((VkDevice)device, vertModule, NULL);

    printf("Graphics pipeline created (bridge)\n");

    // Pack pipeline and pipelineLayout into result
    return ((int64_t)pipelineLayout << 48) | (int64_t)graphicsPipeline;
}

// Bridge function to destroy graphics pipeline
int moonbit_vk_destroy_graphics_pipeline_bridge(int64_t device, int64_t pipeline, int64_t pipelineLayout) {
    printf("Destroying graphics pipeline (bridge)\n");
    vkDestroyPipeline((VkDevice)device, (VkPipeline)pipeline, NULL);
    vkDestroyPipelineLayout((VkDevice)device, (VkPipelineLayout)pipelineLayout, NULL);
    printf("Graphics pipeline destroyed (bridge)\n");
    return 1;
}

// Bridge function for framebuffers creation
int64_t moonbit_vk_create_framebuffers_bridge(int64_t device, int64_t renderPass, int64_t imageViews, int imageCount, int width, int height) {
    printf("Creating framebuffers (bridge)\n");
    printf("  Image count: %d, Size: %dx%d\n", imageCount, width, height);

    VkImageView* views = (VkImageView*)imageViews;
    VkFramebuffer* framebuffers = malloc(imageCount * sizeof(VkFramebuffer));

    for (int i = 0; i < imageCount; i++) {
        VkFramebufferCreateInfo framebufferInfo = {0};
        framebufferInfo.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
        framebufferInfo.renderPass = (VkRenderPass)renderPass;
        framebufferInfo.attachmentCount = 1;
        framebufferInfo.pAttachments = &views[i];
        framebufferInfo.width = width;
        framebufferInfo.height = height;
        framebufferInfo.layers = 1;

        if (vkCreateFramebuffer((VkDevice)device, &framebufferInfo, NULL, &framebuffers[i]) != VK_SUCCESS) {
            free(framebuffers);
            return 0;
        }
    }

    printf("Framebuffers created (bridge)\n");
    return (int64_t)framebuffers;
}

// Bridge function to destroy framebuffers
int moonbit_vk_destroy_framebuffers_bridge(int64_t device, int64_t framebuffers, int imageCount) {
    printf("Destroying framebuffers (bridge)\n");

    VkFramebuffer* fbs = (VkFramebuffer*)framebuffers;
    for (int i = 0; i < imageCount; i++) {
        vkDestroyFramebuffer((VkDevice)device, fbs[i], NULL);
    }

    free(fbs);
    printf("Framebuffers destroyed (bridge)\n");
    return 1;
}

// Bridge function for command pool creation
int64_t moonbit_vk_create_command_pool_bridge(int64_t device, int queueFamily) {
    printf("Creating command pool (bridge)\n");
    printf("  Queue family: %d\n", queueFamily);

    VkCommandPoolCreateInfo poolInfo = {0};
    poolInfo.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
    poolInfo.queueFamilyIndex = queueFamily;
    poolInfo.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;

    VkCommandPool commandPool;
    if (vkCreateCommandPool((VkDevice)device, &poolInfo, NULL, &commandPool) != VK_SUCCESS) {
        return 0;
    }

    printf("Command pool created (bridge)\n");
    return (int64_t)commandPool;
}

// Bridge function for command buffers creation
int64_t moonbit_vk_create_command_buffers_bridge(int64_t device, int64_t commandPool, int imageCount) {
    printf("Creating command buffers (bridge)\n");
    printf("  Image count: %d\n", imageCount);

    VkCommandBufferAllocateInfo allocInfo = {0};
    allocInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
    allocInfo.commandPool = (VkCommandPool)commandPool;
    allocInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
    allocInfo.commandBufferCount = imageCount;

    VkCommandBuffer* commandBuffers = malloc(imageCount * sizeof(VkCommandBuffer));
    if (vkAllocateCommandBuffers((VkDevice)device, &allocInfo, commandBuffers) != VK_SUCCESS) {
        free(commandBuffers);
        return 0;
    }

    printf("Command buffers created (bridge)\n");
    return (int64_t)commandBuffers;
}

// Bridge function to destroy command pool
int moonbit_vk_destroy_command_pool_bridge(int64_t device, int64_t commandPool, int64_t commandBuffers) {
    printf("Destroying command pool (bridge)\n");
    free((void*)commandBuffers);
    vkDestroyCommandPool((VkDevice)device, (VkCommandPool)commandPool, NULL);
    printf("Command pool destroyed (bridge)\n");
    return 1;
}

// Bridge function for sync objects creation
int64_t moonbit_vk_create_sync_objects_bridge(int64_t device) {
    printf("Creating sync objects (bridge)\n");

    // Allocate sync objects structure
    typedef struct {
        VkSemaphore* imageAvailableSemaphores;
        VkSemaphore* renderFinishedSemaphores;
        VkFence* inFlightFences;
        int currentFrame;
    } SyncObjects;

    SyncObjects* sync = malloc(sizeof(SyncObjects));
    sync->currentFrame = 0;

    VkSemaphoreCreateInfo semaphoreInfo = {0};
    semaphoreInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

    VkFenceCreateInfo fenceInfo = {0};
    fenceInfo.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
    fenceInfo.flags = VK_FENCE_CREATE_SIGNALED_BIT;

    sync->imageAvailableSemaphores = malloc(MAX_FRAMES_IN_FLIGHT * sizeof(VkSemaphore));
    sync->renderFinishedSemaphores = malloc(MAX_FRAMES_IN_FLIGHT * sizeof(VkSemaphore));
    sync->inFlightFences = malloc(MAX_FRAMES_IN_FLIGHT * sizeof(VkFence));

    for (int i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        if (vkCreateSemaphore((VkDevice)device, &semaphoreInfo, NULL, &sync->imageAvailableSemaphores[i]) != VK_SUCCESS ||
            vkCreateSemaphore((VkDevice)device, &semaphoreInfo, NULL, &sync->renderFinishedSemaphores[i]) != VK_SUCCESS ||
            vkCreateFence((VkDevice)device, &fenceInfo, NULL, &sync->inFlightFences[i]) != VK_SUCCESS) {
            // Cleanup on failure
            for (int j = 0; j < i; j++) {
                vkDestroySemaphore((VkDevice)device, sync->imageAvailableSemaphores[j], NULL);
                vkDestroySemaphore((VkDevice)device, sync->renderFinishedSemaphores[j], NULL);
                vkDestroyFence((VkDevice)device, sync->inFlightFences[j], NULL);
            }
            free(sync->imageAvailableSemaphores);
            free(sync->renderFinishedSemaphores);
            free(sync->inFlightFences);
            free(sync);
            return 0;
        }
    }

    printf("Sync objects created (bridge)\n");
    return (int64_t)sync;
}

// Bridge function to destroy sync objects
int moonbit_vk_destroy_sync_objects_bridge(int64_t device, int64_t syncObjects) {
    printf("Destroying sync objects (bridge)\n");

    typedef struct {
        VkSemaphore* imageAvailableSemaphores;
        VkSemaphore* renderFinishedSemaphores;
        VkFence* inFlightFences;
        int currentFrame;
    } SyncObjects;

    SyncObjects* sync = (SyncObjects*)syncObjects;

    for (int i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vkDestroySemaphore((VkDevice)device, sync->renderFinishedSemaphores[i], NULL);
        vkDestroySemaphore((VkDevice)device, sync->imageAvailableSemaphores[i], NULL);
        vkDestroyFence((VkDevice)device, sync->inFlightFences[i], NULL);
    }

    free(sync->imageAvailableSemaphores);
    free(sync->renderFinishedSemaphores);
    free(sync->inFlightFences);
    free(sync);

    printf("Sync objects destroyed (bridge)\n");
    return 1;
}

// ============== Cleanup ==============

void moonbit_vk_cleanup() {
    vkDeviceWaitIdle(g_ctx->device);
    
    for (int i = 0; i < MAX_FRAMES_IN_FLIGHT; i++) {
        vkDestroySemaphore(g_ctx->device, g_ctx->renderFinishedSemaphores[i], NULL);
        vkDestroySemaphore(g_ctx->device, g_ctx->imageAvailableSemaphores[i], NULL);
        vkDestroyFence(g_ctx->device, g_ctx->inFlightFences[i], NULL);
    }
    
    vkDestroyCommandPool(g_ctx->device, g_ctx->commandPool, NULL);
    
    for (uint32_t i = 0; i < g_ctx->imageCount; i++) {
        vkDestroyFramebuffer(g_ctx->device, g_ctx->swapchainFramebuffers[i], NULL);
    }
    
    vkDestroyPipeline(g_ctx->device, g_ctx->graphicsPipeline, NULL);
    vkDestroyPipelineLayout(g_ctx->device, g_ctx->pipelineLayout, NULL);
    vkDestroyRenderPass(g_ctx->device, g_ctx->renderPass, NULL);
    
    for (uint32_t i = 0; i < g_ctx->imageCount; i++) {
        vkDestroyImageView(g_ctx->device, g_ctx->swapchainImageViews[i], NULL);
    }
    
    vkDestroySwapchainKHR(g_ctx->device, g_ctx->swapchain, NULL);
    vkDestroyDevice(g_ctx->device, NULL);
    vkDestroySurfaceKHR(g_ctx->instance, g_ctx->surface, NULL);
    vkDestroyInstance(g_ctx->instance, NULL);
    
    glfwDestroyWindow(g_ctx->window);
    glfwTerminate();
    
    free(g_ctx);
    g_ctx = NULL;
    
    printf("Cleanup complete\n");
}

// ============== Initialize All ==============

int moonbit_vk_init(moonbit_string_t appName, int width, int height) {
    char* app_name_cstr = moonbit_string_to_cstr(appName);
    if (!app_name_cstr) {
        fprintf(stderr, "Failed to convert app name\n");
        return 0;
    }
    
    printf("App name: %s\n", app_name_cstr);
    
    int result = 1;
    if (!moonbit_vk_init_window(width, height, app_name_cstr)) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_instance(app_name_cstr)) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_surface()) { result = 0; goto cleanup; }
    if (!moonbit_vk_pick_physical_device()) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_logical_device()) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_swapchain()) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_image_views()) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_render_pass()) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_graphics_pipeline()) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_framebuffers()) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_command_pool()) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_command_buffers()) { result = 0; goto cleanup; }
    if (!moonbit_vk_create_sync_objects()) { result = 0; goto cleanup; }
    
    printf("\n=== Vulkan Initialized Successfully ===\n");
    printf("Ready to render triangle!\n\n");

cleanup:
    free(app_name_cstr);
    return result;
}

// ============== Main Loop ==============

void moonbit_vk_main_loop() {
    printf("Entering main loop...\n");
    while (!moonbit_vk_window_should_close()) {
        moonbit_vk_poll_events();
        moonbit_vk_draw_frame();
    }
    vkDeviceWaitIdle(g_ctx->device);
}
