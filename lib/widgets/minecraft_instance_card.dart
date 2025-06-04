import 'dart:math';

import 'package:flutter/material.dart';
import 'package:installer/compute/prism_instance.dart';
import 'package:nes_ui/nes_ui.dart';

class MinecraftInstanceCard extends StatelessWidget {
  const MinecraftInstanceCard({super.key, required this.instance});
  final PrismInstance instance;

  @override
  Widget build(BuildContext context) {
    final gradient = cardGradientFromName(
      instance.cfgName,
      ColorScheme.of(context).surface,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
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
                borderColor: gradient.first,
              ),
            if (instance.modLoader.isNotEmpty)
              _ComponentChip(instance.modLoader, borderColor: gradient.first),
          ],
        ),
      ),
    );
  }

  static List<Color> cardGradientFromName(String name, Color background) {
    final hash = name.hashCode;
    final primaries = Colors.primaries;
    final primaryIndex = (hash % primaries.length).toInt();
    final primaryColor = primaries[primaryIndex];
    final firstColor = Color.lerp(background, primaryColor, 0.1)!;

    final halfHash = hash / 2;
    final accents = Colors.accents;
    final accentIndex = (halfHash % accents.length).toInt();
    final accentColor = accents[accentIndex];
    final lastColor = Color.lerp(background, accentColor, 0.15)!;

    return [firstColor, background, lastColor];
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
