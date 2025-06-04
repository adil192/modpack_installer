import 'package:flutter/material.dart' hide Step;
import 'package:installer/compute/step_controller.dart';
import 'package:installer/widgets/steps/find_prism_launcher_step.dart';
import 'package:installer/widgets/steps/select_instance_step.dart';
import 'package:installer/widgets/steps/welcome_step.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000),
          child: ListenableBuilder(
            listenable: stepController,
            builder: (context, child) {
              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 32,
                ),
                children: getChildren(
                  context,
                  stepController.currentAndPrevious,
                ).toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  @visibleForTesting
  Iterable<Widget> getChildren(BuildContext context, List<Step> steps) sync* {
    for (final step in steps) {
      switch (step) {
        case Step.welcome:
          yield const _ConstrainedStep(child: WelcomeStep());
        case Step.findPrismLauncher:
          yield const _ConstrainedStep(child: FindPrismLauncherStep());
        case Step.selectModpack:
          yield const _ConstrainedStep(child: SelectInstanceStep());
      }
    }
  }
}

/// Sets the size and spacing of its child.
class _ConstrainedStep extends StatelessWidget {
  const _ConstrainedStep({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
