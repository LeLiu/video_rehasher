import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class ActionButtons extends StatelessWidget {
  final bool isProcessing;
  final bool hasVideoFiles;
  final bool hasTargetDirectory;
  final bool hasErrorMessage;
  final int processedCount;
  final VoidCallback onStartProcessing;
  final VoidCallback onCancelProcessing;
  final VoidCallback onRestartProcessing;
  final VoidCallback onReset;

  const ActionButtons({
    super.key,
    required this.isProcessing,
    required this.hasVideoFiles,
    required this.hasTargetDirectory,
    required this.hasErrorMessage,
    required this.processedCount,
    required this.onStartProcessing,
    required this.onCancelProcessing,
    required this.onRestartProcessing,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TDesignSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // 开始/停止按钮
            ElevatedButton.icon(
              onPressed: isProcessing
                  ? onCancelProcessing
                  : (hasVideoFiles && hasTargetDirectory && !hasErrorMessage
                        ? () {
                            // 如果有已处理的文件，先重新扫描列表
                            if (processedCount > 0) {
                              onRestartProcessing();
                            } else {
                              onStartProcessing();
                            }
                          }
                        : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: isProcessing ? TDesignColors.error : TDesignColors.success,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: TDesignSpacing.lg, vertical: TDesignSpacing.sm),
                minimumSize: const Size(180, 36),
              ),
              icon: Icon(isProcessing ? Icons.stop : Icons.play_arrow, size: 18),
              label: Text(isProcessing ? '停止' : '开始'),
            ),
            const SizedBox(width: TDesignSpacing.xxl),
            // 重置按钮
            OutlinedButton.icon(
              onPressed: isProcessing ? null : onReset,
              style: OutlinedButton.styleFrom(
                foregroundColor: TDesignColors.brand,
                side: const BorderSide(color: TDesignColors.brand),
                padding: const EdgeInsets.symmetric(horizontal: TDesignSpacing.lg, vertical: TDesignSpacing.sm),
                minimumSize: const Size(180, 36),
              ),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('重置'),
            ),
          ],
        ),
      ),
    );
  }
}
