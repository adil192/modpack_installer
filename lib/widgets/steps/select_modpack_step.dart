import 'package:flutter/material.dart' hide Step;
import 'package:installer/compute/prism_launcher.dart';
import 'package:installer/compute/step_controller.dart';
import 'package:installer/util/switcher_layout_builder.dart';
import 'package:nes_ui/nes_ui.dart';

class SelectModpackStep extends StatelessWidget {
  const SelectModpackStep({super.key});

  static final modpackUrl = ValueNotifier<Uri?>(null);
  static void _findInitialModpackUrl() {
    final uri = tryParse(PrismLauncher.selectedInstance?.cfgManagedPackID);
    if (uri == null) return;
    _ChooseModpackState._lastInput = uri.toString();
    print('SelectModpackStep: Found initial modpack URL: $uri');
  }

  static Uri? tryParse(String? input) {
    if (input == null || input.isEmpty) return null;
    if (!input.startsWith('http')) return null;
    if (!input.endsWith('.zip')) return null;
    return Uri.tryParse(input);
  }

  static void _select(Uri modpackUrl) {
    print('SelectModpackStep: selected `$modpackUrl`');
    SelectModpackStep.modpackUrl.value = modpackUrl;
    stepController.markStepComplete(Step.selectModpack);
  }

  static void deselect() {
    print('SelectModpackStep: deselected `${modpackUrl.value}`');
    if (SelectModpackStep.modpackUrl.value != null) {
      _ChooseModpackState._lastInput = SelectModpackStep.modpackUrl.value!
          .toString();
      SelectModpackStep.modpackUrl.value = null;
    }
    stepController.goBackToStep(Step.selectModpack);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: modpackUrl,
      builder: (context, modpackUrl, _) {
        final child = _unanimatedBuild(context, modpackUrl);
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          layoutBuilder: topLeftLayoutBuilder,
          child: SizedBox(
            key: ValueKey(child),
            width: double.infinity,
            child: child,
          ),
        );
      },
    );
  }

  Widget _unanimatedBuild(BuildContext context, Uri? modpackUrl) {
    if (modpackUrl == null) {
      return _ChooseModpack(select: _select);
    } else {
      stepController.markStepComplete(Step.selectModpack);
      return _Success(modpackUrl, deselect: deselect);
    }
  }
}

class _Success extends StatelessWidget {
  const _Success(this.modpackUrl, {required this.deselect});
  final Uri modpackUrl;
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
                'Selected modpack!',
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
        Row(
          children: [
            NesIcon(
              iconData: NesIcons.download,
              size: Size.square(
                TextTheme.of(context).bodyMedium?.fontSize ?? 8,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                modpackUrl.toString(),
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

class _ChooseModpack extends StatefulWidget {
  const _ChooseModpack({required this.select});
  final void Function(Uri modpackUrl) select;

  @override
  State<_ChooseModpack> createState() => _ChooseModpackState();
}

class _ChooseModpackState extends State<_ChooseModpack> {
  late final _formKey = GlobalKey<FormState>();
  late final _urlFieldController = TextEditingController(
    text: SelectModpackStep.modpackUrl.value?.toString() ?? _lastInput,
  );
  static String? _lastInput;

  void trySelect(BuildContext context, String input) {
    final uri = SelectModpackStep.tryParse(input.trim());
    if (uri != null) {
      widget.select(uri);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid URL: $input')));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SelectModpackStep._findInitialModpackUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select a modpack', style: TextTheme.of(context).headlineSmall),
          const SizedBox(height: 8),
          TextFormField(
            controller: _urlFieldController,
            decoration: InputDecoration(
              labelText: 'Modpack URL',
              hintText: 'https://example.com/modpack.zip',
            ),
            validator: (value) => SelectModpackStep.tryParse(value) == null
                ? 'Invalid URL'
                : null,
            onChanged: (value) => _lastInput = value.trim(),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: NesButton(
              type: NesButtonType.normal,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  trySelect(context, _urlFieldController.text);
                }
              },
              child: Text('Download'),
            ),
          ),
        ],
      ),
    );
  }
}
