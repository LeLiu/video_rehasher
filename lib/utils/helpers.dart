import 'dart:io';
import 'package:path/path.dart' as path;

// 格式化文件大小
String formatFileSize(int bytes) {
  if (bytes < 1024) {
    return '$bytes B';
  } else if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  } else if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  } else {
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

// 格式化时长显示
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

// 格式化处理耗时（毫秒）
String formatProcessingTime(Duration? duration) {
  if (duration == null) return '';
  final milliseconds = duration.inMilliseconds;
  if (milliseconds < 1000) {
    return '${milliseconds}ms';
  } else {
    final seconds = duration.inSeconds;
    final remainingMilliseconds = milliseconds % 1000;
    return '${seconds}s${remainingMilliseconds}ms';
  }
}

// 获取视频格式对应的图标路径
String getVideoFormatIcon(String format) {
  final formatMap = {
    '.mp4': 'mp4.png',
    '.avi': 'avi.png',
    '.mov': 'mov.png',
    '.mkv': 'mkv.png',
    '.flv': 'flv.png',
    '.3gp': '3gp.png',
    '.webm': 'webm.png',
  };
  final iconName = formatMap[format.toLowerCase()] ?? 'video.png';
  return 'assets/images/$iconName';
}

// 支持的视频格式列表
List<String> getSupportedVideoFormats() {
  return ['.mp4', '.avi', '.mov', '.mkv', '.flv', '.wmv', '.webm'];
}

// 检查文件是否为支持的视频格式
bool isSupportedVideoFormat(String filePath) {
  final fileExtension = path.extension(filePath).toLowerCase();
  return getSupportedVideoFormats().contains(fileExtension);
}

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
    // 获取应用包路径
    final bundlePath = Platform.resolvedExecutable;
    final bundleDir = path.dirname(bundlePath);
    print('Bundle path: $bundlePath');
    print('Bundle dir: $bundleDir');

    // 检查应用包内是否有ffmpeg
    final bundleFfmpegPath = path.join(bundleDir, 'ffmpeg');
    final bundleFfmpegFile = File(bundleFfmpegPath);
    print('Bundle FFmpeg path: $bundleFfmpegPath');
    print('Bundle FFmpeg exists: ${bundleFfmpegFile.existsSync()}');

    if (bundleFfmpegFile.existsSync()) {
      return bundleFfmpegPath;
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
