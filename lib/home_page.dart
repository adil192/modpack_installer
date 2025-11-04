import 'package:basics/comparable_basics.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:installer/compute/step_controller.dart';
import 'package:installer/widgets/footer.dart';
import 'package:installer/widgets/steps/download_step.dart';
import 'package:installer/widgets/steps/find_prism_launcher_step.dart';
import 'package:installer/widgets/steps/install_step.dart';
import 'package:installer/widgets/steps/select_instance_step.dart';
import 'package:installer/widgets/steps/select_modpack_step.dart';
import 'package:installer/widgets/steps/welcome_step.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static List<Widget> _lastChildren = [];
  static Step? _lastStep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: stepController,
              builder: (context, _) {
                if (_lastStep != stepController.current) {
                  // Step changed, update children
                  _lastStep = stepController.current;
                  _lastChildren = getChildren(
                    context,
                    stepController.currentAndPrevious,
                  ).toList();
                }

                return ListView(
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingForMaxWidth(
                      MediaQuery.sizeOf(context).width,
                    ),
                    vertical: 32,
                  ),
                  children: _lastChildren,
                );
              },
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }

  double paddingForMaxWidth(double screenWidth) {
    const maxWidth = 1000;
    return max(16, (screenWidth - maxWidth) / 2);
  }

  static final _keys = <Step, GlobalKey>{
    for (final step in Step.values)
      step: GlobalKey(debugLabel: 'StepWidget(${step.name})'),
  };

  @visibleForTesting
  Iterable<Widget> getChildren(BuildContext context, List<Step> steps) sync* {
    for (final step in Step.values.reversed) {
      switch (step) {
        case Step.welcome:
          yield _ConstrainedStep(
            show: steps.contains(Step.welcome),
            child: WelcomeStep(key: _keys[Step.welcome]),
          );
        case Step.findPrismLauncher:
          yield _ConstrainedStep(
            show: steps.contains(Step.findPrismLauncher),
            child: FindPrismLauncherStep(key: _keys[Step.findPrismLauncher]),
          );
        case Step.selectInstance:
          yield _ConstrainedStep(
            show: steps.contains(Step.selectInstance),
            child: SelectInstanceStep(key: _keys[Step.selectInstance]),
          );
        case Step.selectModpack:
          yield _ConstrainedStep(
            show: steps.contains(Step.selectModpack),
            child: SelectModpackStep(key: _keys[Step.selectModpack]),
          );
        case Step.download:
          yield _ConstrainedStep(
            show: steps.contains(Step.download),
            child: DownloadStep(key: _keys[Step.download]),
          );
        case Step.install:
          yield _ConstrainedStep(
            show: steps.contains(Step.install),
            child: InstallStep(key: _keys[Step.install]),
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
