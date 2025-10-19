class VideoFile {
  final String name;
  final String path;
  final String relativePath; // 相对于源目录的相对路径
  final String format;
  final int size;
  bool processed;
  double progress;
  Duration? duration; // 视频时长
  String? originalMd5; // 原始MD5摘要
  String? processedMd5; // 处理后MD5摘要
  String? processedPath; // 处理后文件路径
  Duration? processingTime; // 处理耗时

  VideoFile({
    required this.name,
    required this.path,
    required this.relativePath,
    required this.format,
    required this.size,
    this.processed = false,
    this.progress = 0.0,
    this.duration,
    this.originalMd5,
    this.processedMd5,
    this.processedPath,
    this.processingTime,
  });

  // 复制方法，用于创建副本
  VideoFile copyWith({
    String? name,
    String? path,
    String? relativePath,
    String? format,
    int? size,
    bool? processed,
    double? progress,
    Duration? duration,
    String? originalMd5,
    String? processedMd5,
    String? processedPath,
    Duration? processingTime,
  }) {
    return VideoFile(
      name: name ?? this.name,
      path: path ?? this.path,
      relativePath: relativePath ?? this.relativePath,
      format: format ?? this.format,
      size: size ?? this.size,
      processed: processed ?? this.processed,
      progress: progress ?? this.progress,
      duration: duration ?? this.duration,
      originalMd5: originalMd5 ?? this.originalMd5,
      processedMd5: processedMd5 ?? this.processedMd5,
      processedPath: processedPath ?? this.processedPath,
      processingTime: processingTime ?? this.processingTime,
    );
  }

  @override
  String toString() {
    return 'VideoFile{name: $name, path: $path, processed: $processed, progress: $progress}';
  }
}
