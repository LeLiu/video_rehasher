import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class ProgressSection extends StatelessWidget {
  final bool isProcessing;
  final double overallProgress;
  final String currentStatus;
  final int processedCount;
  final int totalCount;

  const ProgressSection({
    super.key,
    required this.isProcessing,
    required this.overallProgress,
    required this.currentStatus,
    required this.processedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    if (!isProcessing && overallProgress == 0.0) {
      return Container(); // 不显示进度区域
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TDesignSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('处理进度', style: TDesignTypography.titleMedium),
            const SizedBox(height: TDesignSpacing.sm),
            Row(
              children: [
                // 圆形进度指示器
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        constraints: const BoxConstraints(maxHeight: 48, maxWidth: 48, minHeight: 48, minWidth: 48),
                        value: overallProgress,
                        strokeWidth: 6,
                        backgroundColor: TDesignColors.bgComponent,
                        valueColor: AlwaysStoppedAnimation<Color>(TDesignColors.brand),
                      ),
                      Text(
                        '${(overallProgress * 100).toStringAsFixed(0)}%',
                        style: TDesignTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: TDesignSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentStatus, style: TDesignTypography.bodyMedium),
                      const SizedBox(height: TDesignSpacing.sm),
                      LinearProgressIndicator(
                        value: overallProgress,
                        backgroundColor: TDesignColors.bgComponent,
                        color: TDesignColors.brand,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(TDesignRadius.sm),
                      ),
                      const SizedBox(height: TDesignSpacing.xs),
                      Text('已完成: $processedCount/$totalCount 文件', style: TDesignTypography.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
