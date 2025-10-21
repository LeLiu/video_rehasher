import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../theme/design_system.dart';

class DirectorySelection extends StatelessWidget {
  final String? sourceDirectory;
  final String? targetDirectory;
  final bool isProcessing;
  final VoidCallback onSelectSourceDirectory;
  final VoidCallback onSelectTargetDirectory;

  const DirectorySelection({
    super.key,
    required this.sourceDirectory,
    required this.targetDirectory,
    required this.isProcessing,
    required this.onSelectSourceDirectory,
    required this.onSelectTargetDirectory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(TDesignSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('目录设置', style: TDesignTypography.titleMedium),
            const SizedBox(height: TDesignSpacing.sm),
            //Text('源目录', style: TDesignTypography.bodyMedium),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: sourceDirectory != null
                            ? () async {
                                final directory = Directory(sourceDirectory!);
                                if (directory.existsSync()) {
                                  final uri = Uri.file(sourceDirectory!);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  }
                                }
                              }
                            : null,
                        child: Text(
                          sourceDirectory ?? '未选择',
                          style: TDesignTypography.bodyMedium.copyWith(
                            color: sourceDirectory != null ? TDesignColors.brand : TDesignColors.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: TDesignSpacing.lg),
                ElevatedButton.icon(
                  onPressed: isProcessing ? null : onSelectSourceDirectory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: TDesignSpacing.lg, vertical: TDesignSpacing.sm),
                    minimumSize: const Size(180, 36),
                  ),
                  icon: const Icon(Icons.folder_open, size: 18),
                  label: const Text('选择源目录'),
                ),
              ],
            ),
            const SizedBox(height: TDesignSpacing.sm),
            //Text('目标目录', style: TDesignTypography.bodyMedium),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: targetDirectory != null
                            ? () async {
                                final directory = Directory(targetDirectory!);
                                if (directory.existsSync()) {
                                  final uri = Uri.file(targetDirectory!);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri);
                                  }
                                }
                              }
                            : null,
                        child: Text(
                          targetDirectory ?? '未选择',
                          style: TDesignTypography.bodyMedium.copyWith(
                            color: targetDirectory != null ? TDesignColors.brand : TDesignColors.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: TDesignSpacing.lg),
                ElevatedButton.icon(
                  onPressed: isProcessing ? null : onSelectTargetDirectory,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: TDesignSpacing.lg, vertical: TDesignSpacing.sm),
                    minimumSize: const Size(180, 36),
                  ),
                  icon: const Icon(Icons.folder_open, size: 18),
                  label: const Text('选择目标目录'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
