import 'package:flutter/material.dart' hide Step;
import 'package:installer/compute/step_controller.dart';
import 'package:installer/widgets/steps/download_step.dart';
import 'package:installer/widgets/steps/find_prism_launcher_step.dart';
import 'package:installer/widgets/steps/install_step.dart';
import 'package:installer/widgets/steps/select_instance_step.dart';
import 'package:installer/widgets/steps/select_modpack_step.dart';
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
    for (final step in Step.values) {
      switch (step) {
        case Step.welcome:
          yield _ConstrainedStep(
            show: steps.contains(Step.welcome),
            child: WelcomeStep(),
          );
        case Step.findPrismLauncher:
          yield _ConstrainedStep(
            show: steps.contains(Step.findPrismLauncher),
            child: FindPrismLauncherStep(),
          );
        case Step.selectInstance:
          yield _ConstrainedStep(
            show: steps.contains(Step.selectInstance),
            child: SelectInstanceStep(),
          );
        case Step.selectModpack:
          yield _ConstrainedStep(
            show: steps.contains(Step.selectModpack),
            child: SelectModpackStep(),
          );
        case Step.download:
          yield _ConstrainedStep(
            show: steps.contains(Step.download),
            child: DownloadStep(),
          );
        case Step.install:
          yield _ConstrainedStep(
            show: steps.contains(Step.install),
            child: InstallStep(),
          );
      }
    }
  }
}

/// Sets the size and spacing of its child.
class _ConstrainedStep extends StatelessWidget {
  const _ConstrainedStep({required this.show, required this.child});
  final bool show;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
      opacity: show ? 1 : 0,
      child: show
          ? SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: child,
              ),
            )
          : SizedBox(width: double.infinity, height: 1),
    );
  }
}
