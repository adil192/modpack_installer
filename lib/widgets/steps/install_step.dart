import 'package:flutter/material.dart';

class InstallStep extends StatefulWidget {
  const InstallStep({super.key});

  @override
  State<InstallStep> createState() => _InstallStepState();
}

class _InstallStepState extends State<InstallStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Install!',
          style: TextTheme.of(context).headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        
      ],
    );
  }
}
