#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <vulkan/vulkan.h>
#include <moonbit.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    Display* display;
    Window window;
    int width;
    int height;
    VkSurfaceKHR surface;
} WindowContext;

WindowContext g_window_context = {0};

// Custom memory allocation functions for MoonBit FFI
void* vulkan_alloc(size_t size) {
    return malloc(size);
}

void vulkan_free(void* ptr) {
    if (ptr) {
        free(ptr);
    }
}

// Create X11 window and Vulkan surface
int32_t moonbit_create_window(int32_t width, int32_t height) {
    g_window_context.display = XOpenDisplay(NULL);
    if (!g_window_context.display) {
        fprintf(stderr, "Failed to open X11 display\n");
        return -1;
    }

    Window root = DefaultRootWindow(g_window_context.display);
    XSetWindowAttributes swa = {0};
    swa.event_mask = ExposureMask | KeyPressMask;

    g_window_context.window = XCreateWindow(
        g_window_context.display, root,
        100, 100, width, height, 0,
        CopyFromParent, InputOutput, CopyFromParent,
        CWEventMask, &swa
    );

    XMapWindow(g_window_context.display, g_window_context.window);
    XStoreName(g_window_context.display, g_window_context.window, "Vulkan Triangle - MoonBit");
    XFlush(g_window_context.display);

    g_window_context.width = width;
    g_window_context.height = height;

    return 0;
}

// Destroy X11 window
void moonbit_destroy_window() {
    if (g_window_context.window) {
        XDestroyWindow(g_window_context.display, g_window_context.window);
    }
    if (g_window_context.display) {
        XCloseDisplay(g_window_context.display);
    }
    memset(&g_window_context, 0, sizeof(g_window_context));
}

// Get X11 display (for Vulkan surface creation)
void* moonbit_get_display() {
    return g_window_context.display;
}

// Get X11 window (for Vulkan surface creation)
int64_t moonbit_get_window() {
    return (int64_t)g_window_context.window;
}

// Poll X11 events (returns 1 if should quit, 0 otherwise)
int32_t moonbit_poll_events() {
    XEvent event;
    while (XPending(g_window_context.display)) {
        XNextEvent(g_window_context.display, &event);
        if (event.type == KeyPress) {
            return 1; // Quit on key press
        }
    }
    return 0;
}

// Set Vulkan surface (called from MoonBit after creating surface)
void moonbit_set_surface(void* surface) {
    g_window_context.surface = (VkSurfaceKHR)surface;
}

// Get Vulkan surface
void* moonbit_get_surface() {
    return g_window_context.surface;
}
