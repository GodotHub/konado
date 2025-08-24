#!/usr/bin/env python3
"""
基础依赖：pip3 install "gdtoolkit==4.*"
使用方法：python gdlinter.py --ignore addons/gut
文档：https://github.com/Scony/godot-gdscript-toolkit/wiki/3.-Linter
"""

import os
import sys
import subprocess
import argparse
from pathlib import Path

def should_ignore_path(path, ignore_patterns):
    """检查路径是否应该被忽略"""
    # 将路径转换为字符串并标准化
    path_str = os.path.normpath(str(path))
    
    # 检查路径是否匹配任何忽略模式
    for pattern in ignore_patterns:
        # 如果是绝对路径模式，直接比较
        if os.path.isabs(pattern):
            if path_str.startswith(os.path.normpath(pattern)):
                return True
        # 否则检查路径中是否包含模式
        else:
            pattern_parts = pattern.split(os.sep)
            path_parts = path_str.split(os.sep)
            
            # 检查路径的每个部分是否包含模式
            for i in range(len(path_parts) - len(pattern_parts) + 1):
                if path_parts[i:i+len(pattern_parts)] == pattern_parts:
                    return True
                    
    return False

def find_gd_files(directory, ignore_patterns=None):
    """递归查找目录中的所有 .gd 和 .gds 文件，忽略指定模式"""
    if ignore_patterns is None:
        ignore_patterns = []
    
    gd_files = []
    
    # 标准化忽略模式
    normalized_ignore_patterns = []
    for pattern in ignore_patterns:
        # 如果模式是相对路径，将其转换为相对于目标目录的绝对路径
        if not os.path.isabs(pattern):
            abs_pattern = os.path.normpath(os.path.join(directory, pattern))
            normalized_ignore_patterns.append(abs_pattern)
        else:
            normalized_ignore_patterns.append(os.path.normpath(pattern))
    
    for root, dirs, files in os.walk(directory):
        # 在遍历时修改dirs列表可以避免进入被忽略的目录
        dirs[:] = [d for d in dirs if not should_ignore_path(os.path.join(root, d), normalized_ignore_patterns)]
        
        # 检查当前目录是否应该被忽略
        if should_ignore_path(root, normalized_ignore_patterns):
            continue
            
        for file in files:
            if file.endswith(('.gd', '.gds')):
                full_path = os.path.join(root, file)
                # 检查文件是否应该被忽略
                if not should_ignore_path(full_path, normalized_ignore_patterns):
                    gd_files.append(full_path)
    
    return gd_files

def run_gdlint_on_files(files, verbose=False):
    """对文件列表运行 gdlint"""
    issues_found = 0
    files_with_issues = 0
    
    for file_path in files:
        if verbose:
            print(f"检查文件: {file_path}")
        
        try:
            # 运行 gdlint 命令
            result = subprocess.run(
                ['gdlint', file_path],
                capture_output=True,
                text=True,
                timeout=30  # 设置超时时间为30秒
            )
            
            # 检查是否有输出（表示有问题）
            if result.stdout:
                print(f"\n检查通过 {file_path}:")
                print(result.stdout)
               
            
            # 检查是否有错误
            if result.stderr:
                files_with_issues += 1
                issues_found += result.stderr.count('\n')
                print(f"发现错误在 {file_path}:")
                print(result.stderr)
                pass
                
        except subprocess.TimeoutExpired:
            print(f"超时当处理 {file_path}，跳过...")
        except FileNotFoundError:
            print("错误: 找不到 gdlint 命令。请确保已安装 gdlint 并在 PATH 中可用。")
            sys.exit(1)
        except Exception as e:
            print(f"未知错误当处理 {file_path}: {e}")
    
    return issues_found, files_with_issues

def main():
    parser = argparse.ArgumentParser(description='使用 gdlint 检查目录中的所有 GDScript 文件')
    parser.add_argument('directory', nargs='?', default='.', 
                       help='要检查的目录（默认为当前目录）')
    parser.add_argument('-v', '--verbose', action='store_true',
                       help='显示详细输出')
    parser.add_argument('-i', '--ignore', action='append', default=[],
                       help='要忽略的目录模式（可以多次使用此参数）')
    parser.add_argument('--ignore-file', type=str,
                       help='包含要忽略的目录列表的文件（每行一个模式）')
    
    args = parser.parse_args()
    
    # 检查目录是否存在
    if not os.path.isdir(args.directory):
        print(f"错误: 目录 '{args.directory}' 不存在")
        sys.exit(1)
    
    # 从文件中读取忽略模式（如果有）
    ignore_patterns = args.ignore.copy()  # 复制命令行参数
    
    if args.ignore_file:
        try:
            with open(args.ignore_file, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith('#'):  # 跳过空行和注释
                        ignore_patterns.append(line)
        except FileNotFoundError:
            print(f"警告: 忽略文件 '{args.ignore_file}' 不存在")
        except Exception as e:
            print(f"错误读取忽略文件: {e}")
    
    print(f"在目录 '{args.directory}' 中查找 GDScript 文件...")
    if ignore_patterns:
        print(f"忽略模式: {', '.join(ignore_patterns)}")
    
    # 查找所有 GDScript 文件
    gd_files = find_gd_files(args.directory, ignore_patterns)
    
    if not gd_files:
        print("未找到任何 .gd 或 .gds 文件")
        return
    
    print(f"找到 {len(gd_files)} 个 GDScript 文件")
    print("开始检查...\n")
    
    # 运行 gdlint
    issues_count, files_with_issues_count = run_gdlint_on_files(gd_files, args.verbose)
    
    # 输出总结
    print("\n" + "="*50)
    print("检查完成!")
    print(f"扫描文件: {len(gd_files)}")
    print(f"有问题文件: {files_with_issues_count}")
    print(f"总问题数: {issues_count}")
    
    if issues_count == 0:
        print("所有文件通过检查!")
        sys.exit(0)
    else:
        print("发现一些问题，请查看上方详情")
        sys.exit(1)

if __name__ == "__main__":
    main()