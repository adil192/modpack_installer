import 'package:flutter/material.dart' hide Step;
import 'package:installer/compute/step_controller.dart';
import 'package:installer/util/stows.dart';
import 'package:nes_ui/nes_ui.dart';

class FindPrismLauncherStep extends StatelessWidget {
  const FindPrismLauncherStep({super.key});

  @override
  Widget build(BuildContext context) {
    final prismDir = stows.prismDir.value;

    if (prismDir == null) {
      return _Error();
    } else {
      stepController.markStepComplete(Step.findPrismLauncher);
      return _Success(prismDir);
    }
  }
}

class _Success extends StatelessWidget {
  const _Success(this.prismDir);
  final String prismDir;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Located Prism Launcher!',
          style: TextTheme.of(context).headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            NesIcon(
              iconData: NesIcons.openFolder,
              size: Size.square(
                TextTheme.of(context).bodyMedium?.fontSize ?? 8,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                prismDir,
                style: TextTheme.of(context).bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Couldn\'t find Prism Launcher',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        SelectableText(
          'Please ensure Prism Launcher is installed and has been run at least once.',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
