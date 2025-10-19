import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../models/video_file.dart';
import '../services/ffmpeg_service.dart';
import '../utils/helpers.dart';

class VideoRehasherState extends ChangeNotifier {
  String? _sourceDirectory;
  String? _targetDirectory;
  final List<VideoFile> _videoFiles = [];
  bool _isProcessing = false;
  double _overallProgress = 0.0;
  String _currentStatus = '等待选择目录';
  int _processedCount = 0;
  int _currentProcessingIndex = -1; // 当前正在处理的文件索引
  String? _errorMessage; // 错误消息，用于显示横幅

  String? get sourceDirectory => _sourceDirectory;
  String? get targetDirectory => _targetDirectory;
  List<VideoFile> get videoFiles => _videoFiles;
  bool get isProcessing => _isProcessing;
  double get overallProgress => _overallProgress;
  String get currentStatus => _currentStatus;
  int get processedCount => _processedCount;
  int get currentProcessingIndex => _currentProcessingIndex;
  String? get errorMessage => _errorMessage;

  Future<void> selectSourceDirectory() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        _sourceDirectory = selectedDirectory;

        // 检查输入输出目录是否相同
        if (_sourceDirectory == _targetDirectory) {
          _errorMessage = '错误：输入目录和输出目录不能相同';
          _videoFiles.clear(); // 清除文件列表
          _currentStatus = '目录相同，无法扫描文件';
        } else {
          _errorMessage = null; // 清除错误消息
          await _scanVideoFiles();
        }

        notifyListeners();
      }
    } catch (e) {
      _currentStatus = '选择源目录失败: $e';
      notifyListeners();
    }
  }

  Future<void> selectTargetDirectory() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        _targetDirectory = selectedDirectory;

        // 检查输入输出目录是否相同
        if (_sourceDirectory == _targetDirectory) {
          _errorMessage = '错误：输入目录和输出目录不能相同';
        } else {
          _errorMessage = null; // 清除错误消息
        }

        notifyListeners();
      }
    } catch (e) {
      _currentStatus = '选择目标目录失败: $e';
      notifyListeners();
    }
  }

  Future<void> _scanVideoFiles() async {
    if (_sourceDirectory == null) return;

    _currentStatus = '正在扫描视频文件...';
    notifyListeners();

    _videoFiles.clear();
    final dir = Directory(_sourceDirectory!);
    try {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          final fileName = path.basename(entity.path);
          final fileExtension = path.extension(entity.path).toLowerCase();

          if (isSupportedVideoFormat(entity.path)) {
            final fileStat = await entity.stat();
            final originalMd5 = await FfmpegService.calculateFileMd5(entity.path);
            final duration = await FfmpegService.getVideoDuration(entity.path);

            // 计算相对于源目录的相对路径
            final relativePath = path.relative(entity.path, from: _sourceDirectory!);

            _videoFiles.add(
              VideoFile(
                name: fileName,
                path: entity.path,
                relativePath: relativePath,
                format: fileExtension,
                size: fileStat.size,
                originalMd5: originalMd5,
                duration: duration,
              ),
            );
          }
        }
      }
      _currentStatus = '扫描完成，找到 ${_videoFiles.length} 个视频文件';
    } catch (e) {
      _currentStatus = '扫描文件时出错: $e';
    }
    notifyListeners();
  }

  Future<void> processVideos() async {
    if (_targetDirectory == null) {
      _currentStatus = '请选择目标目录';
      notifyListeners();
      return;
    }

    if (_videoFiles.isEmpty) {
      _currentStatus = '没有找到视频文件';
      notifyListeners();
      return;
    }

    _isProcessing = true;
    _processedCount = 0;
    _overallProgress = 0.0;
    _currentProcessingIndex = -1;
    _currentStatus = '开始处理视频文件...';
    notifyListeners();

    try {
      for (int i = 0; i < _videoFiles.length; i++) {
        if (!_isProcessing) break; // 如果用户取消了处理

        _currentProcessingIndex = i;
        final videoFile = _videoFiles[i];

        // 使用相对路径构建目标文件路径，保持目录结构
        final relativeDir = path.dirname(videoFile.relativePath);
        final outputDir = path.join(_targetDirectory!, relativeDir);
        final outputFileName = '${path.basenameWithoutExtension(videoFile.path)}_rehashed${videoFile.format}';
        final outputFile = path.join(outputDir, outputFileName);

        _currentStatus = '正在处理: ${videoFile.name}';
        notifyListeners();

        // 确保目标目录存在
        final outputDirectory = Directory(outputDir);
        if (!outputDirectory.existsSync()) {
          await outputDirectory.create(recursive: true);
        }

        // 处理视频文件
        await _processVideoFile(videoFile, outputFile);

        videoFile.processed = true;
        _processedCount++;

        _overallProgress = (i + 1) / _videoFiles.length;
        notifyListeners();
      }

      _isProcessing = false;
      _currentProcessingIndex = -1;
      _currentStatus = '处理完成 ($_processedCount/${_videoFiles.length} 个文件)';
      notifyListeners();
    } catch (e) {
      _isProcessing = false;
      _currentProcessingIndex = -1;
      _currentStatus = '处理过程中发生错误: $e';
      notifyListeners();
    }
  }

  Future<void> _processVideoFile(VideoFile videoFile, String outputFile) async {
    final startTime = DateTime.now();

    // 使用FFmpeg进行真正的视频处理
    await FfmpegService.processVideoFile(videoFile, outputFile, (status) {
      _currentStatus = status;
      notifyListeners();
    });

    // 计算处理后文件的MD5
    final processedFile = File(outputFile);
    if (processedFile.existsSync()) {
      final processedMd5 = await FfmpegService.calculateFileMd5(outputFile);
      videoFile.processedMd5 = processedMd5;
      videoFile.processedPath = outputFile;
      videoFile.processingTime = DateTime.now().difference(startTime);
    }
  }

  void cancelProcessing() {
    _isProcessing = false;
    _currentProcessingIndex = -1;
    _currentStatus = '处理已取消';
    notifyListeners();
  }

  Future<void> restartProcessing() async {
    if (_sourceDirectory == null) {
      _currentStatus = '请选择源目录';
      notifyListeners();
      return;
    }

    if (_targetDirectory == null) {
      _currentStatus = '请选择目标目录';
      notifyListeners();
      return;
    }

    // 重置处理状态
    for (var videoFile in _videoFiles) {
      videoFile.processed = false;
      videoFile.progress = 0.0;
      videoFile.processedMd5 = null;
      videoFile.processedPath = null;
      videoFile.processingTime = null;
    }

    _processedCount = 0;
    _overallProgress = 0.0;
    _currentProcessingIndex = -1;

    // 重新扫描文件
    await _scanVideoFiles();

    // 开始处理
    await processVideos();
  }

  void reset() {
    _sourceDirectory = null;
    _targetDirectory = null;
    _videoFiles.clear();
    _isProcessing = false;
    _overallProgress = 0.0;
    _currentStatus = '等待选择目录';
    _processedCount = 0;
    _currentProcessingIndex = -1;
    _errorMessage = null; // 清除错误消息
    notifyListeners();
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
