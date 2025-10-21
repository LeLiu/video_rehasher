# FFmpeg 依赖说明

## 问题描述

`windows/depend/ffmpeg.exe` 文件大小为 146.86 MB，超过了 GitHub 的 100 MB 文件大小限制，因此无法直接推送到 GitHub 仓库。

## 解决方案

1. **已从 Git 中移除**：`ffmpeg.exe` 已从 Git 版本控制中移除，但保留在本地文件系统中
2. **添加到 .gitignore**：已配置 `.gitignore` 文件防止未来意外提交
3. **本地保留**：应用程序仍然可以使用本地的 `ffmpeg.exe` 文件

## 开发环境设置

### 对于新开发者

1. 克隆仓库后，需要手动下载 FFmpeg：
   ```bash
   # 在项目根目录下创建依赖目录
   mkdir -p windows/depend
   
   # 下载 FFmpeg (Windows 版本)
   # 从 https://ffmpeg.org/download.html 下载 Windows 版本
   # 解压后将 ffmpeg.exe 放入 windows/depend/ 目录
   ```

2. 或者使用包管理器安装：
   ```bash
   # 使用 Chocolatey (Windows)
   choco install ffmpeg
   
   # 使用 Scoop (Windows)
   scoop install ffmpeg
   ```

### 构建和分发

对于最终用户，FFmpeg 应该包含在应用程序的安装包中，或者提供下载说明。

## 替代方案

考虑使用以下方法之一：

1. **Git LFS**：使用 Git Large File Storage 管理大文件
2. **外部下载**：在首次运行时下载 FFmpeg
3. **系统 FFmpeg**：依赖用户系统上已安装的 FFmpeg

## 当前状态

- ✅ `ffmpeg.exe` 已从 Git 历史记录中移除
- ✅ `.gitignore` 已更新以防止未来提交
- ✅ 本地开发环境中的 `ffmpeg.exe` 保持不变
- ✅ 应用程序功能不受影响