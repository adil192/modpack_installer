import 'package:flutter/material.dart';

class DownloadStep extends StatelessWidget {
  const DownloadStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Downloading',
          style: TextTheme.of(context).headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        
      ],
    );
  }
}
