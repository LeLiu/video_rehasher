import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/design_system.dart';
import 'state/video_rehasher_state.dart';
import 'widgets/video_processor_ui.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => VideoRehasherState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Video ReHasher', theme: AppTheme.lightTheme, home: const VideoRehasherHomePage());
  }
}

class VideoRehasherHomePage extends StatelessWidget {
  const VideoRehasherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.videocam, size: 24, color: TDesignColors.brand);
              },
            ),
            const SizedBox(width: 8.0),
            Text('Video Rehasher', style: TDesignTypography.titleMedium),
          ],
        ),
        backgroundColor: TDesignColors.bgContainer,
        foregroundColor: TDesignColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: const VideoProcessorUI(),
    );
  }
}
