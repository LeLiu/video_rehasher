import 'dart:io';
import 'dart:async';
import 'package:crypto/crypto.dart';
import '../models/video_file.dart';
import '../utils/helpers.dart';

class FfmpegService {
  // 处理单个视频文件
  static Future<void> processVideoFile(VideoFile videoFile, String outputFile, Function(String) onStatusUpdate) async {
    final _ = DateTime.now(); // 保留时间戳但不使用

    try {
      // 检查源文件是否存在
      final sourceFile = File(videoFile.path);
      if (!sourceFile.existsSync()) {
        throw Exception('源文件不存在: ${videoFile.path}');
      }

      // 获取当前时间信息
      final now = DateTime.now();
      final currentTime = now.toUtc();
      final timestamp = now.millisecondsSinceEpoch ~/ 1000;

      // 获取源文件信息
      final sourceStat = await sourceFile.stat();
      final sourceModifiedTime = sourceStat.modified;

      // 获取当前用户名
      final platform = Platform.environment;
      final userName = platform['USERNAME'] ?? platform['USER'] ?? 'UnknownUser';
      final hostName = platform['COMPUTERNAME'] ?? 'UnknownHost';

      // 构建FFmpeg命令 - 使用metadata修改方法
      // -c copy: 复制流而不重新编码
      // -map_metadata -1: 清除所有原始metadata
      // -metadata: 添加新的metadata信息
      final command = [
        '-i',
        videoFile.path,
        '-c',
        'copy',
        '-map_metadata',
        '-1',
        '-metadata',
        'creation_time="${currentTime.toIso8601String()}"',
        '-metadata',
        'title="Video ReHasher Processed: ${videoFile.name}"',
        '-metadata',
        'artist="Processed by $userName"',
        '-metadata',
        'album="Video ReHasher Batch"',
        '-metadata',
        'date="${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}"',
        '-metadata',
        'comment="Original: ${sourceModifiedTime.toIso8601String()}"',
        '-metadata',
        'copyright="Processed on $hostName"',
        '-metadata',
        'ReHasher_Version="2.1.0"',
        '-metadata',
        'ReHasher_ProcessID="$pid"',
        '-metadata',
        'ReHasher_Timestamp="$timestamp"',
        '-y',
        outputFile,
      ];

      onStatusUpdate('正在处理: ${videoFile.name}');

      // 获取ffmpeg.exe的路径
      final ffmpegPath = getFfmpegPath();

      // 执行FFmpeg命令 - 使用项目自带的ffmpeg.exe
      final result = await Process.run(ffmpegPath, command);

      if (result.exitCode == 0) {
        onStatusUpdate('完成: ${videoFile.name}');

        // 验证输出文件
        final output = File(outputFile);
        if (!output.existsSync()) {
          throw Exception('输出文件未生成');
        }

        final outputStat = await output.stat();
        if (outputStat.size == 0) {
          throw Exception('输出文件为空');
        }
      } else {
        throw Exception('FFmpeg处理失败: ${result.exitCode}\n${result.stderr}');
      }
    } catch (e) {
      onStatusUpdate('处理文件失败 ${videoFile.name}: $e');
      rethrow;
    }
  }

  // 计算文件的MD5摘要
  static Future<String> calculateFileMd5(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final digest = await _computeMd5(bytes);
      return digest;
    } catch (e) {
      return '计算失败';
    }
  }

  // 计算字节数组的MD5
  static Future<String> _computeMd5(List<int> bytes) async {
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  // 获取视频时长（简化实现）
  static Future<Duration?> getVideoDuration(String filePath) async {
    try {
      // 这里应该使用FFmpeg或视频处理库来获取真实时长
      // 简化实现，返回一个模拟时长
      final file = File(filePath);
      final stat = await file.stat();
      // 基于文件大小模拟时长（每10MB约1分钟）
      final minutes = (stat.size / (10 * 1024 * 1024)).ceil();
      return Duration(minutes: minutes.clamp(1, 120));
    } catch (e) {
      return null;
    }
  }
}
