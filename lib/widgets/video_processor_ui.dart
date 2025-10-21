import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/video_rehasher_state.dart';
import 'error_banner.dart';
import 'progress_section.dart';
import 'directory_selection.dart';
import 'file_list.dart';
import 'action_buttons.dart';

class VideoProcessorUI extends StatefulWidget {
  const VideoProcessorUI({super.key});

  @override
  State<VideoProcessorUI> createState() => _VideoProcessorUIState();
}

class _VideoProcessorUIState extends State<VideoProcessorUI> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final processor = context.watch<VideoRehasherState>();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 错误横幅区域
            if (processor.errorMessage != null)
              ErrorBanner(errorMessage: processor.errorMessage!, onClose: () => processor.clearErrorMessage()),
            // 目录选择区域
            DirectorySelection(
              sourceDirectory: processor.sourceDirectory,
              targetDirectory: processor.targetDirectory,
              isProcessing: processor.isProcessing,
              onSelectSourceDirectory: () => processor.selectSourceDirectory(),
              onSelectTargetDirectory: () => processor.selectTargetDirectory(),
            ),
            //const SizedBox(height: 8.0),
            // 进度监控区域
            ProgressSection(
              isProcessing: processor.isProcessing,
              overallProgress: processor.overallProgress,
              currentStatus: processor.currentStatus,
              processedCount: processor.processedCount,
              totalCount: processor.videoFiles.length,
            ),
            //const SizedBox(height: 8.0),
            // 文件列表区域
            Expanded(
              child: FileList(
                videoFiles: processor.videoFiles,
                isProcessing: processor.isProcessing,
                currentProcessingIndex: processor.currentProcessingIndex,
                scrollController: _scrollController,
              ),
            ),
            // 操作按钮区域
            ActionButtons(
              isProcessing: processor.isProcessing,
              hasVideoFiles: processor.videoFiles.isNotEmpty,
              hasTargetDirectory: processor.targetDirectory != null,
              hasErrorMessage: processor.errorMessage != null,
              processedCount: processor.processedCount,
              onStartProcessing: () => processor.processVideos(),
              onCancelProcessing: () => processor.cancelProcessing(),
              onRestartProcessing: () => processor.restartProcessing(),
              onReset: () => processor.reset(),
            ),
          ],
        ),
      ),
    );
  }
}
