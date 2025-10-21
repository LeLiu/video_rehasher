import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class ErrorBanner extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onClose;

  const ErrorBanner({super.key, required this.errorMessage, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(TDesignSpacing.sm),
      margin: const EdgeInsets.only(bottom: TDesignSpacing.sm),
      decoration: BoxDecoration(
        color: TDesignColors.error.withValues(alpha: 0.08),
        border: Border.all(color: TDesignColors.error.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(TDesignRadius.md),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: TDesignColors.error, size: 20),
          const SizedBox(width: TDesignSpacing.sm),
          Expanded(
            child: Text(errorMessage, style: TDesignTypography.bodyMedium.copyWith(color: TDesignColors.error)),
          ),
          IconButton(
            icon: Icon(Icons.close, color: TDesignColors.error, size: 16),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
