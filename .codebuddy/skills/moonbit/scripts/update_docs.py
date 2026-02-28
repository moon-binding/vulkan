#!/usr/bin/env python3
"""
MoonBit 文档更新脚本
从官方文档站点 https://docs.moonbitlang.cn 下载最新的语言文档
"""

import subprocess
import os
import re
from pathlib import Path
from datetime import datetime

# 使用代理（如果需要）
PROXY = "ALL_PROXY=socks5h://localhost:30000"

# MoonBit 官方文档 URL
MOONBIT_DOCS_URLS = {
    "index": "https://docs.moonbitlang.cn/language/index.html",
    "introduction": "https://docs.moonbitlang.cn/language/introduction.html",
    "fundamentals": "https://docs.moonbitlang.cn/language/fundamentals.html",
    "methods": "https://docs.moonbitlang.cn/language/methods.html",
    "derive": "https://docs.moonbitlang.cn/language/derive.html",
    "error-handling": "https://docs.moonbitlang.cn/language/error-handling.html",
    "packages": "https://docs.moonbitlang.cn/language/packages.html",
    "tests": "https://docs.moonbitlang.cn/language/tests.html",
    "benchmarks": "https://docs.moonbitlang.cn/language/benchmarks.html",
    "docs": "https://docs.moonbitlang.cn/language/docs.html",
    "attributes": "https://docs.moonbitlang.cn/language/attributes.html",
    "ffi": "https://docs.moonbitlang.cn/language/ffi.html",
    "async-experimental": "https://docs.moonbitlang.cn/language/async-experimental.html",
}

def clean_html_content(html_content):
    """清理 HTML 内容，提取纯文本"""
    # 移除 script 和 style 标签及其内容
    html_content = re.sub(r'<script[^>]*>.*?</script>', '', html_content, flags=re.DOTALL | re.IGNORECASE)
    html_content = re.sub(r'<style[^>]*>.*?</style>', '', html_content, flags=re.DOTALL | re.IGNORECASE)
    
    # 移除 HTML 注释
    html_content = re.sub(r'<!--.*?-->', '', html_content, flags=re.DOTALL)
    
    # 移除导航和页脚
    html_content = re.sub(r'<nav[^>]*>.*?</nav>', '', html_content, flags=re.DOTALL | re.IGNORECASE)
    html_content = re.sub(r'<footer[^>]*>.*?</footer>', '', html_content, flags=re.DOTALL | re.IGNORECASE)
    
    # 将标题转换为 Markdown
    html_content = re.sub(r'<h1[^>]*>(.*?)</h1>', r'# \1\n', html_content, flags=re.DOTALL)
    html_content = re.sub(r'<h2[^>]*>(.*?)</h2>', r'## \1\n', html_content, flags=re.DOTALL)
    html_content = re.sub(r'<h3[^>]*>(.*?)</h3>', r'### \1\n', html_content, flags=re.DOTALL)
    html_content = re.sub(r'<h4[^>]*>(.*?)</h4>', r'#### \1\n', html_content, flags=re.DOTALL)
    
    # 处理代码块
    html_content = re.sub(r'<pre[^>]*><code[^>]*>(.*?)</code></pre>', r'\n```\n\1\n```\n', html_content, flags=re.DOTALL)
    html_content = re.sub(r'<code[^>]*>(.*?)</code>', r'`\1`', html_content, flags=re.DOTALL)
    
    # 处理段落和换行
    html_content = re.sub(r'<p[^>]*>(.*?)</p>', r'\1\n\n', html_content, flags=re.DOTALL)
    html_content = re.sub(r'<br\s*/?>', '\n', html_content)
    
    # 处理列表
    html_content = re.sub(r'<li[^>]*>(.*?)</li>', r'- \1\n', html_content, flags=re.DOTALL)
    html_content = re.sub(r'<ul[^>]*>|</ul>', '', html_content)
    html_content = re.sub(r'<ol[^>]*>|</ol>', '', html_content)
    
    # 处理链接
    html_content = re.sub(r'<a[^>]*href="([^"]*)"[^>]*>(.*?)</a>', r'[\2](\1)', html_content, flags=re.DOTALL)
    
    # 处理强调
    html_content = re.sub(r'<strong[^>]*>(.*?)</strong>', r'**\1**', html_content, flags=re.DOTALL)
    html_content = re.sub(r'<em[^>]*>(.*?)</em>', r'*\1*', html_content, flags=re.DOTALL)
    
    # 移除剩余的 HTML 标签
    html_content = re.sub(r'<[^>]+>', '', html_content)
    
    # 处理 HTML 实体
    html_content = re.sub(r'&nbsp;', ' ', html_content)
    html_content = re.sub(r'&lt;', '<', html_content)
    html_content = re.sub(r'&gt;', '>', html_content)
    html_content = re.sub(r'&amp;', '&', html_content)
    html_content = re.sub(r'&quot;', '"', html_content)
    html_content = re.sub(r'&#39;', "'", html_content)
    
    # 清理空白行
    lines = html_content.split('\n')
    cleaned_lines = []
    prev_empty = False
    for line in lines:
        line = line.strip()
        if not line:
            if not prev_empty:
                cleaned_lines.append('')
                prev_empty = True
        else:
            cleaned_lines.append(line)
            prev_empty = False
    
    return '\n'.join(cleaned_lines)


def fetch_url(url, use_proxy=False):
    """使用 curl 获取 URL 内容"""
    cmd = ["curl", "-sS", "-L", url]
    if use_proxy:
        cmd = [f"ALL_PROXY=socks5h://localhost:30000", "curl", "-sS", "-L", url]
        # 使用 shell 来设置环境变量
        result = subprocess.run(
            f"export ALL_PROXY=socks5h://localhost:30000 && curl -sS -L '{url}'",
            shell=True,
            capture_output=True,
            text=True,
            timeout=60
        )
    else:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
    
    if result.returncode != 0:
        print(f"Error fetching {url}: {result.stderr}")
        return None
    return result.stdout


def update_all_docs(use_proxy=False):
    """更新所有 MoonBit 文档"""
    reference_dir = Path(__file__).parent.parent / "reference"
    reference_dir.mkdir(parents=True, exist_ok=True)
    
    updated_files = []
    
    for doc_name, url in MOONBIT_DOCS_URLS.items():
        print(f"Fetching {doc_name} from {url}...")
        
        html_content = fetch_url(url, use_proxy)
        if html_content is None:
            print(f"  Failed to fetch {doc_name}")
            continue
        
        # 清理 HTML 内容
        content = clean_html_content(html_content)
        
        # 添加元数据
        metadata = f"""---
MoonBit Documentation: {doc_name.replace('-', ' ').title()}
Source URL: {url}
Last Updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
---

"""
        
        output_file = reference_dir / f"{doc_name}.md"
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(metadata + content)
        
        updated_files.append(str(output_file))
        print(f"  Updated: {output_file}")
    
    print(f"\nUpdated {len(updated_files)} documentation files")
    return updated_files


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Update MoonBit documentation")
    parser.add_argument("--proxy", action="store_true", help="Use proxy (socks5h://localhost:30000)")
    parser.add_argument("--doc", choices=list(MOONBIT_DOCS_URLS.keys()), help="Specific documentation to update")
    
    args = parser.parse_args()
    
    print("MoonBit Documentation Updater")
    print("=" * 50)
    
    reference_dir = Path(__file__).parent.parent / "reference"
    reference_dir.mkdir(parents=True, exist_ok=True)
    
    if args.doc:
        url = MOONBIT_DOCS_URLS[args.doc]
        print(f"Fetching {args.doc} from {url}...")
        
        html_content = fetch_url(url, args.proxy)
        if html_content:
            content = clean_html_content(html_content)
            metadata = f"""---
MoonBit Documentation: {args.doc.replace('-', ' ').title()}
Source URL: {url}
Last Updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
---

"""
            output_file = reference_dir / f"{args.doc}.md"
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(metadata + content)
            print(f"Updated: {output_file}")
    else:
        update_all_docs(args.proxy)


if __name__ == "__main__":
    main()
