import 'dart:math';

import 'package:flutter/material.dart';
import 'package:installer/compute/prism_instance.dart';
import 'package:nes_ui/nes_ui.dart';

class MinecraftInstanceCard extends StatelessWidget {
  const MinecraftInstanceCard({super.key, required this.instance});
  final PrismInstance instance;

  @override
  Widget build(BuildContext context) {
    final gradient = cardGradientFromName(instance.cfgName);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(instance.cfgName, style: TextTheme.of(context).titleMedium),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (instance.minecraftVersion.isNotEmpty)
                  _ComponentChip(
                    instance.minecraftVersion,
                    borderColor: gradient.first,
                  ),
                if (instance.modLoader.isNotEmpty)
                  _ComponentChip(
                    instance.modLoader,
                    borderColor: gradient.first,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static List<Color> cardGradientFromName(String name) {
    final hash = name.hashCode;
    final primaries = Colors.primaries;
    final primaryIndex = (hash % primaries.length).toInt();
    final primaryColor = primaries[primaryIndex];
    final firstColor = Color.lerp(Colors.white, primaryColor, 0.1)!;

    final halfHash = hash / 2;
    final accents = Colors.accents;
    final accentIndex = (halfHash % accents.length).toInt();
    final accentColor = accents[accentIndex];
    final secondColor = Color.lerp(Colors.white, accentColor, 0.15)!;

    return [firstColor, Colors.white, secondColor];
  }
}

class _ComponentChip extends StatelessWidget {
  const _ComponentChip(this.component, {required this.borderColor});
  final String component;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return NesContainer(
      backgroundColor: Colors.white.withValues(alpha: 0.7),
      borderColor: Color.lerp(Colors.black, borderColor, 0.9)!,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(component, style: TextTheme.of(context).bodyMedium),
    );
  }
}
