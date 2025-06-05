import 'dart:math';

import 'package:flutter/material.dart';
import 'package:installer/compute/prism_instance.dart';
import 'package:nes_ui/nes_ui.dart';

class MinecraftInstanceCard extends StatelessWidget {
  const MinecraftInstanceCard({super.key, required this.instance});
  final PrismInstance instance;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colorScheme = ColorScheme.of(context);

    final primaryColor = brightness == Brightness.light
        ? instance.primaryColorLight
        : instance.primaryColorDark;
    final secondaryColor = brightness == Brightness.light
        ? instance.secondaryColorLight
        : instance.secondaryColorDark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            colorScheme.surfaceContainerLowest,
            secondaryColor,
          ],
          transform: GradientRotation(pi * 0.4),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: NesContainer(
        backgroundColor: Colors.transparent,
        child: _RowOrColumn(
          title: Text(
            instance.cfgName,
            style: TextTheme.of(context).titleMedium,
          ),
          chips: [
            if (instance.minecraftVersion.isNotEmpty)
              _ComponentChip(
                instance.minecraftVersion,
                borderColor: primaryColor,
              ),
            if (instance.modLoader.isNotEmpty)
              _ComponentChip(instance.modLoader, borderColor: primaryColor),
          ],
        ),
      ),
    );
  }
}

class _ComponentChip extends StatelessWidget {
  const _ComponentChip(this.component, {required this.borderColor});
  final String component;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return NesContainer(
      backgroundColor: Color.lerp(
        colorScheme.inverseSurface,
        colorScheme.surfaceContainerLowest,
        0.95,
      )!,
      borderColor: Color.lerp(colorScheme.inverseSurface, borderColor, 0.8)!,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(component, style: TextTheme.of(context).bodyMedium),
    );
  }
}

class _RowOrColumn extends StatelessWidget {
  const _RowOrColumn({required this.title, required this.chips});
  final Widget title;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 400) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Expanded(child: title),
              const SizedBox(width: 8),
              ...chips,
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: chips),
            ],
          );
        }
      },
    );
  }
}
