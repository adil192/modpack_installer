import 'package:flutter/material.dart';
import 'package:installer/compute/prism_instance.dart';
import 'package:installer/widgets/painting.dart';
import 'package:nes_ui/nes_ui.dart';

class MinecraftInstanceCard extends StatelessWidget {
  const MinecraftInstanceCard({super.key, required this.instance});
  final PrismInstance instance;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: instance.instanceDir.path,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: NesContainer(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(16),
          child: _ArrangedCard(
            title: Text(
              instance.cfgName,
              style: TextTheme.of(context).titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            paintingHash: instance.paintingHash,
            chips: [
              if (instance.minecraftVersion.isNotEmpty)
                _ComponentChip(instance.minecraftVersion),
              if (instance.modLoader.isNotEmpty)
                _ComponentChip(instance.modLoader),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComponentChip extends StatelessWidget {
  const _ComponentChip(this.component);
  final String component;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return NesContainer(
      backgroundColor: Color.lerp(
        colorScheme.inverseSurface,
        colorScheme.surface,
        0.95,
      )!,
      borderColor: Color.lerp(
        colorScheme.inverseSurface,
        colorScheme.shadow,
        0.8,
      )!,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(component, style: TextTheme.of(context).bodyMedium),
    );
  }
}

class _ArrangedCard extends StatelessWidget {
  const _ArrangedCard({
    required this.title,
    required this.paintingHash,
    required this.chips,
  });
  final Widget title;
  final int paintingHash;
  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 270) {
          return Row(
            spacing: 8,
            children: [
              Painting(
                paintingHash: paintingHash,
                size: constraints.maxWidth > 400 ? 64 : 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    title,
                    Wrap(spacing: 8, children: chips),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Row(
                spacing: 8,
                children: [
                  Painting(paintingHash: paintingHash, size: 38),
                  Expanded(child: title),
                ],
              ),
              Wrap(spacing: 8, runSpacing: 4, children: chips),
            ],
          );
        }
      },
    );
  }
}
