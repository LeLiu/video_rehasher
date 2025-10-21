import 'dart:io';
import 'package:path/path.dart' as path;

// 获取ffmpeg的路径
String getFfmpegPath() {
  if (Platform.isWindows) {
    // 在Windows上，ffmpeg.exe会被拷贝到应用程序目录
    final appDir = Directory.current.path;
    final ffmpegPath = path.join(appDir, 'ffmpeg.exe');

    // 检查应用程序目录中的ffmpeg.exe是否存在
    final ffmpegFile = File(ffmpegPath);
    if (ffmpegFile.existsSync()) {
      return ffmpegPath;
    }

    // 如果应用程序目录中没有，则使用项目目录中的ffmpeg.exe
    final projectFfmpegPath = path.join(Directory.current.path, 'windows', 'depend', 'ffmpeg.exe');
    final projectFfmpegFile = File(projectFfmpegPath);
    if (projectFfmpegFile.existsSync()) {
      return projectFfmpegPath;
    }
  } else if (Platform.isMacOS) {
    // 在macOS上，首先尝试应用包内的ffmpeg
    final bundlePath = Platform.resolvedExecutable;
    final bundleDir = path.dirname(bundlePath);
    final appBundleFfmpegPath = path.join(bundleDir, 'ffmpeg');
    final appBundleFfmpegFile = File(appBundleFfmpegPath);
    print('Bundle path: $bundlePath');
    print('Bundle dir: $bundleDir');
    print('App bundle FFmpeg path: $appBundleFfmpegPath');
    print('App bundle FFmpeg exists: ${appBundleFfmpegFile.existsSync()}');
    
    if (appBundleFfmpegFile.existsSync()) {
      return appBundleFfmpegPath;
    }

    // 如果应用包内没有，则使用项目目录中的ffmpeg二进制文件（开发环境）
    final projectFfmpegPath = path.join(Directory.current.path, 'macos', 'depend', 'ffmpeg');
    final projectFfmpegFile = File(projectFfmpegPath);
    print('Project FFmpeg path: $projectFfmpegPath');
    print('Project FFmpeg exists: ${projectFfmpegFile.existsSync()}');
    
    if (projectFfmpegFile.existsSync()) {
      return projectFfmpegPath;
    }
  }

  // 如果都没有找到，则使用系统ffmpeg作为后备
  return 'ffmpeg';
}

void main() async {
  print('Testing FFmpeg path detection on macOS...');
  print('Current directory: ${Directory.current.path}');
  print('Platform: ${Platform.operatingSystem}');
  
  final ffmpegPath = getFfmpegPath();
  print('Detected FFmpeg path: $ffmpegPath');
  
  // 测试FFmpeg是否可执行
  try {
    final result = await Process.run(ffmpegPath, ['-version']);
    print('FFmpeg test result: ${result.exitCode}');
    print('FFmpeg output: ${result.stdout}');
    if (result.stderr.isNotEmpty) {
      print('FFmpeg error: ${result.stderr}');
    }
  } catch (e) {
    print('Error running FFmpeg: $e');
  }
}