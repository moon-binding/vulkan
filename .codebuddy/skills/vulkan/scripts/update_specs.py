#!/usr/bin/env python3
"""
Vulkan 规范文档更新脚本
从 Vulkan 官方仓库下载最新的规范和 API 文档
"""

import requests
import json
import re
from pathlib import Path
from datetime import datetime


VULKAN_GITHUB_API = "https://api.github.com/repos/KhronosGroup/Vulkan-Docs"
VULKAN_REGISTRY_URL = "https://raw.githubusercontent.com/KhronosGroup/Vulkan-Docs/main/xml/vk.xml"
VULKAN_SPEC_URL = "https://raw.githubusercontent.com/KhronosGroup/Vulkan-Docs/main/html/spec.html"


def get_latest_version():
    """获取 Vulkan 最新版本信息"""
    print("Fetching Vulkan latest version...")
    try:
        response = requests.get(f"{VULKAN_GITHUB_API}/releases/latest", timeout=30)
        response.raise_for_status()
        data = response.json()
        return data.get("tag_name", "unknown"), data.get("name", "unknown")
    except Exception as e:
        print(f"Warning: Could not fetch version: {e}")
        return "unknown", "unknown"


def fetch_vk_xml():
    """下载 Vulkan XML 注册表"""
    print("Fetching Vulkan XML registry...")
    try:
        response = requests.get(VULKAN_REGISTRY_URL, timeout=60)
        response.raise_for_status()
        return response.text
    except Exception as e:
        print(f"Error fetching vk.xml: {e}")
        return None


def parse_vk_xml_to_markdown(xml_content):
    """解析 Vulkan XML 并转换为 Markdown 格式"""
    print("Parsing Vulkan XML to Markdown...")

    lines = []
    lines.append("# Vulkan API Registry\n")
    lines.append(f"Last Updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")

    # 解析 enums
    enums = re.findall(r'<enum\s+name="([^"]+)"\s+value="([^"]+)"', xml_content)
    if enums:
        lines.append("## Constants\n")
        for name, value in enums[:50]:  # 限制数量避免过长
            lines.append(f"- `{name}` = {value}")
        lines.append("")

    # 解析 commands (函数)
    commands = re.findall(r'<command>\s+<proto>\s+<type>([^<]+)</type>\s+<name>([^<]+)</name>', xml_content)
    if commands:
        lines.append("## Commands (Functions)\n")
        lines.append(f"Total commands found: {len(commands)}\n")
        lines.append("Core functions (first 50):\n")
        for ret_type, func_name in commands[:50]:
            lines.append(f"- `{func_name}` → `{ret_type}`")
        lines.append("")

    return "\n".join(lines)


def fetch_and_parse_spec():
    """下载并解析 Vulkan 规范文档"""
    print("Fetching Vulkan specification...")
    try:
        response = requests.get(VULKAN_SPEC_URL, timeout=60)
        response.raise_for_status()
        html_content = response.text

        # 简单的 HTML 转 Markdown
        lines = ["# Vulkan Specification\n"]
        lines.append(f"Last Updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")

        # 提取章节标题
        chapters = re.findall(r'<h([1-3])[^>]*>([^<]+)</h\1>', html_content)
        for level, title in chapters[:30]:
            indent = "  " * (int(level) - 1)
            lines.append(f"{indent}- {title}")

        return "\n".join(lines)
    except Exception as e:
        print(f"Error fetching spec: {e}")
        return "# Vulkan Specification\n\nError loading specification."


def update_vulkan_docs():
    """更新所有 Vulkan 文档"""
    references_dir = Path(__file__).parent.parent / "references"
    references_dir.mkdir(parents=True, exist_ok=True)

    # 获取版本信息
    version, name = get_latest_version()
    version_info = f"""
---
Vulkan Version: {version}
Version Name: {name}
Last Updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
---

"""

    # 更新 XML 注册表
    print("\n" + "="*60)
    xml_content = fetch_vk_xml()
    if xml_content:
        markdown_content = parse_vk_xml_to_markdown(xml_content)
        registry_file = references_dir / "api_registry.md"
        with open(registry_file, 'w', encoding='utf-8') as f:
            f.write(version_info + markdown_content)
        print(f"✅ Updated: {registry_file}")

    # 更新规范文档
    print("\n" + "="*60)
    spec_content = fetch_and_parse_spec()
    spec_file = references_dir / "specification.md"
    with open(spec_file, 'w', encoding='utf-8') as f:
        f.write(version_info + spec_content)
    print(f"✅ Updated: {spec_file}")

    # 更新扩展列表（简化版）
    print("\n" + "="*60)
    extensions_content = """# Vulkan Extensions

Last Updated: {}

## Core Extensions

### VK_KHR_swapchain
Swapchain 扩展，用于渲染到窗口表面。

### VK_KHR_surface
表面扩展，定义窗口表面接口。

### VK_EXT_debug_utils
调试工具扩展，提供调试标记和对象名称功能。

## Common Extensions

### VK_KHR_ray_tracing_pipeline
光线追踪管线扩展。

### VK_KHR_ray_query
光线查询扩展。

### VK_KHR_synchronization2
增强的同步原语。

### VK_KHR_dynamic_rendering
动态渲染扩展，允许无需渲染通道的渲染。

## Device Extensions

### VK_KHR_fragment_shading_rate
片段着色率扩展，用于可变速率着色。

### VK_KHR_mesh_shader
网格着色器扩展，用于网格管线。

### VK_KHR_acceleration_structure
加速结构扩展，用于光线追踪。

## Validation Layers

### VK_LAYER_KHRONOS_validation
Khronos 验证层，用于检测 Vulkan 应用程序中的常见错误。

## 注意

完整的扩展列表请参考 Vulkan 官方文档。使用 `grep` 在 `api_registry.md` 中搜索特定扩展。
""".format(datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

    extensions_file = references_dir / "extensions.md"
    with open(extensions_file, 'w', encoding='utf-8') as f:
        f.write(extensions_content)
    print(f"✅ Updated: {extensions_file}")

    print("\n" + "="*60)
    print(f"📚 Vulkan documentation updated successfully!")
    print(f"   Version: {version} ({name})")
    print(f"\n💡 Next steps:")
    print(f"   1. Review the updated documentation files")
    print(f"   2. Use grep to search for specific APIs or features")
    print(f"   3. Test the skill with a Vulkan-related task")


def main():
    print("🚀 Vulkan Documentation Updater")
    print("="*60)

    import argparse
    parser = argparse.ArgumentParser(description="Update Vulkan documentation")
    parser.add_argument(
        "--version-only",
        action="store_true",
        help="Only check and display the latest version"
    )

    args = parser.parse_args()

    if args.version_only:
        version, name = get_latest_version()
        print(f"\nLatest Vulkan version: {version} ({name})")
        return

    update_vulkan_docs()


if __name__ == "__main__":
    main()
