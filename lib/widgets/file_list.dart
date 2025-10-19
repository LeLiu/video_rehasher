import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import '../models/video_file.dart';
import '../theme/design_system.dart';
import '../utils/helpers.dart';

class FileList extends StatefulWidget {
  final List<VideoFile> videoFiles;
  final bool isProcessing;
  final int currentProcessingIndex;
  final ScrollController scrollController;

  const FileList({
    super.key,
    required this.videoFiles,
    required this.isProcessing,
    required this.currentProcessingIndex,
    required this.scrollController,
  });

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  @override
  void initState() {
    super.initState();
    // 自动滚动到当前处理的项目
    if (widget.isProcessing && widget.currentProcessingIndex >= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.scrollController.hasClients) {
          widget.scrollController.animateTo(
            widget.currentProcessingIndex * 80.0, // 估算每个项目的高度
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TDesignSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('视频文件列表', style: TDesignTypography.titleMedium),
            const SizedBox(height: TDesignSpacing.md),
            Text('找到 ${widget.videoFiles.length} 个视频文件', style: TDesignTypography.bodyMedium),
            const SizedBox(height: TDesignSpacing.sm),
            Expanded(
              child: widget.videoFiles.isEmpty
                  ? Center(
                      child: Text(
                        '没有找到视频文件',
                        style: TDesignTypography.bodyMedium.copyWith(color: TDesignColors.textTertiary),
                      ),
                    )
                  : ListView.builder(
                      controller: widget.scrollController,
                      itemCount: widget.videoFiles.length,
                      itemBuilder: (context, index) {
                        final video = widget.videoFiles[index];
                        final isProcessing = widget.isProcessing && widget.currentProcessingIndex == index;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: TDesignSpacing.xs),
                          decoration: BoxDecoration(
                            color: isProcessing ? TDesignColors.highlight : TDesignColors.bgContainer,
                            border: Border.all(color: TDesignColors.border),
                            borderRadius: BorderRadius.circular(TDesignRadius.sm),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(TDesignSpacing.sm),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 视频格式图标
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(TDesignRadius.sm)),
                                  child: Center(
                                    child: Image.asset(
                                      getVideoFormatIcon(video.format),
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.videocam, size: 20, color: TDesignColors.textTertiary);
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: TDesignSpacing.sm),
                                // 文件信息和详情
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 文件名（大字体）
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              video.name,
                                              style: TDesignTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (video.processed && video.processingTime != null)
                                            Text(
                                              formatProcessingTime(video.processingTime),
                                              style: TDesignTypography.caption,
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: TDesignSpacing.xs),
                                      // 时长、格式、大小、MD5信息（在同一行，用"|"隔开）
                                      Row(
                                        children: [
                                          Text(
                                            '${video.duration != null ? formatDuration(video.duration!) : "未知时长"} | ${video.format.toUpperCase()} | ${formatFileSize(video.size)}',
                                            style: TDesignTypography.caption,
                                          ),
                                          if (video.originalMd5 != null || video.processedMd5 != null) ...[
                                            Text(' | ', style: TDesignTypography.caption),
                                            Expanded(
                                              child: Text(
                                                '${video.originalMd5 ?? "未计算"} | ${video.processedMd5 ?? "未计算"}',
                                                style: TDesignTypography.caption.copyWith(fontFamily: 'monospace'),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      // 处理前和处理后文件路径（在同一行，用箭头图标分隔）
                                      if (video.path.isNotEmpty || video.processedPath != null)
                                        Row(
                                          children: [
                                            Flexible(
                                              flex: 3,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  final directory = Directory(path.dirname(video.path));
                                                  if (directory.existsSync()) {
                                                    final uri = Uri.file(path.dirname(video.path));
                                                    if (await canLaunchUrl(uri)) {
                                                      await launchUrl(uri);
                                                    }
                                                  }
                                                },
                                                child: Text(
                                                  video.path,
                                                  style: TDesignTypography.bodySmall.copyWith(
                                                    color: TDesignColors.brand,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: TDesignSpacing.xs),
                                            Icon(Icons.arrow_forward, size: 12, color: TDesignColors.textTertiary),
                                            const SizedBox(width: TDesignSpacing.xs),
                                            Flexible(
                                              flex: 2,
                                              child: GestureDetector(
                                                onTap: video.processedPath != null
                                                    ? () async {
                                                        final directory = Directory(path.dirname(video.processedPath!));
                                                        if (directory.existsSync()) {
                                                          final uri = Uri.file(path.dirname(video.processedPath!));
                                                          if (await canLaunchUrl(uri)) {
                                                            await launchUrl(uri);
                                                          }
                                                        }
                                                      }
                                                    : null,
                                                child: Text(
                                                  video.processedPath ?? '未处理',
                                                  style: TDesignTypography.bodySmall.copyWith(
                                                    color: video.processedPath != null
                                                        ? TDesignColors.brand
                                                        : TDesignColors.textTertiary,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: TDesignSpacing.sm),
                                // 处理状态指示器
                                if (video.processed)
                                  Icon(Icons.check_circle, color: TDesignColors.success, size: 20)
                                else if (isProcessing)
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: TDesignColors.brand),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
