import 'package:flutter/material.dart' hide Step;
import 'package:installer/compute/step_controller.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    stepController.markStepComplete(Step.welcome);
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Welcome to adil192\'s\n'
            'modpack installer!',
            style: TextTheme.of(context).displaySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
