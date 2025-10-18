import 'package:flutter/material.dart' hide Step;
import 'package:installer/compute/prism_instance.dart';
import 'package:installer/compute/prism_launcher.dart';
import 'package:installer/compute/step_controller.dart';
import 'package:installer/util/switcher_layout_builder.dart';
import 'package:installer/widgets/minecraft_instance_card.dart';
import 'package:installer/widgets/steps/select_modpack_step.dart';
import 'package:nes_ui/nes_ui.dart';

class SelectInstanceStep extends StatefulWidget {
  const SelectInstanceStep({super.key});

  @override
  State<SelectInstanceStep> createState() => _SelectInstanceStepState();
}

class _SelectInstanceStepState extends State<SelectInstanceStep> {
  void _select(PrismInstance instance) {
    print('SelectInstanceStep: selected `${instance.cfgName}`');
    PrismLauncher.selectedInstance = instance;
    stepController.markStepComplete(Step.selectInstance);
    if (mounted) setState(() {});
  }

  void _deselect() {
    print(
      'SelectInstanceStep: deselected `${PrismLauncher.selectedInstance?.cfgName}`',
    );
    PrismLauncher.selectedInstance = null;
    SelectModpackStep.deselect();
    stepController.goBackToStep(Step.selectInstance);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final child = _unanimatedBuild(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      layoutBuilder: topLeftLayoutBuilder,
      child: child,
    );
  }

  Widget _unanimatedBuild(BuildContext context) {
    final selectedInstance = PrismLauncher.selectedInstance;
    if (selectedInstance != null) {
      stepController.markStepComplete(Step.selectInstance);
      return _Success(selectedInstance, deselect: _deselect);
    }

    final instances = PrismLauncher.instances;
    return _Choose(instances, select: _select);
  }
}

class _Success extends StatelessWidget {
  const _Success(this.selectedInstance, {required this.deselect});
  final PrismInstance selectedInstance;
  final VoidCallback deselect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Flexible(
              child: Text(
                'Selected instance!',
                style: TextTheme.of(context).headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            NesIconButton(
              onPress: deselect,
              size: Size.square(TextTheme.of(context).bodySmall?.fontSize ?? 8),
              primaryColor: Color(0xFF444444),
              icon: NesIcons.edit,
            ),
          ],
        ),
        const SizedBox(height: 8),
        NesPressable(
          onPress: deselect,
          child: SizedBox(
            width: double.infinity,
            child: MinecraftInstanceCard(instance: selectedInstance),
          ),
        ),
      ],
    );
  }
}

class _Choose extends StatelessWidget {
  const _Choose(this.instances, {required this.select});
  final List<PrismInstance>? instances;
  final void Function(PrismInstance instance) select;

  @override
  Widget build(BuildContext context) {
    final instances = this.instances;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select an instance',
          style: TextTheme.of(context).headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        if (instances == null)
          NesPixelRowLoadingIndicator()
        else if (instances.isEmpty)
          // TODO: Create an instance here
          Text(
            'No instances found. Please create one in Prism Launcher.',
            style: TextTheme.of(context).bodyMedium,
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              return _InstanceCards(
                cardWidth: constraints.maxWidth < 400
                    ? double.infinity
                    : (constraints.maxWidth - 8) / 2,
                instances: instances,
                select: select,
              );
            },
          ),
      ],
    );
  }
}

class _InstanceCards extends StatefulWidget {
  const _InstanceCards({
    required this.cardWidth,
    required this.instances,
    required this.select,
  });

  final double cardWidth;
  final List<PrismInstance> instances;
  final void Function(PrismInstance instance) select;

  @override
  State<_InstanceCards> createState() => _InstanceCardsState();
}

class _InstanceCardsState extends State<_InstanceCards> {
  bool showAllInstances = false;

  late final allInstances = widget.instances;
  late final filteredInstances = allInstances
      .where((instance) => instance.cfgManagedPackID.startsWith('http'))
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    final instances = (showAllInstances || filteredInstances.isEmpty)
        ? allInstances
        : filteredInstances;
    final hiddenInstances = allInstances.length - instances.length;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final instance in instances)
          SizedBox(
            width: widget.cardWidth,
            child: NesPressable(
              onPress: () => widget.select(instance),
              child: MinecraftInstanceCard(instance: instance),
            ),
          ),
        if (hiddenInstances > 0)
          SizedBox(
            width: double.infinity,
            child: NesButton(
              onPressed: () {
                setState(() {
                  showAllInstances = !showAllInstances;
                });
              },
              type: NesButtonType.normal,
              child: Text('Show $hiddenInstances more instances'),
            ),
          ),
      ],
    );
  }
}
