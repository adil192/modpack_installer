import 'package:flutter/material.dart';
import 'package:installer/compute/prism_instance.dart';
import 'package:installer/compute/prism_launcher.dart';
import 'package:nes_ui/nes_ui.dart';

class SelectInstanceStep extends StatefulWidget {
  const SelectInstanceStep({super.key});

  @override
  State<SelectInstanceStep> createState() => _SelectInstanceStepState();
}

class _SelectInstanceStepState extends State<SelectInstanceStep> {
  void _select(PrismInstance instance) {
    print('Selected instance: ${instance.cfgName}');
    PrismLauncher.selectedInstance = instance;
    if (mounted) setState(() {});
  }

  void _deselect() {
    print('Deselected instance: ${PrismLauncher.selectedInstance?.cfgName}');
    PrismLauncher.selectedInstance = null;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selectedInstance = PrismLauncher.selectedInstance;
    if (selectedInstance != null) {
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
          children: [
            Flexible(
              child: Text(
                'Selected instance!',
                style: TextTheme.of(context).titleLarge,
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
          child: Text(
            selectedInstance.cfgName,
            style: TextTheme.of(context).bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
          style: TextTheme.of(context).titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        if (instances == null)
          NesPixelRowLoadingIndicator()
        else if (instances.isEmpty)
          Text(
            'No instances found. Please create one in Prism Launcher.',
            style: TextTheme.of(context).bodyMedium,
          )
        else
          for (final instance in instances)
            _InstanceButton(instance: instance, select: select),
      ],
    );
  }
}

class _InstanceButton extends StatelessWidget {
  const _InstanceButton({required this.instance, required this.select});
  final PrismInstance instance;
  final void Function(PrismInstance instance) select;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: NesButton(
        type: NesButtonType.normal,
        onPressed: () => select(instance),
        child: Text(instance.cfgName),
      ),
    );
  }
}
