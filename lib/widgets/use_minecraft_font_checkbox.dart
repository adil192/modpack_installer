import 'package:flutter/material.dart';
import 'package:installer/util/stows.dart';
import 'package:nes_ui/nes_ui.dart';

class UseMinecraftFontCheckbox extends StatelessWidget {
  const UseMinecraftFontCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: stows.useMinecraftFont,
            builder: (context, _, _) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: NesCheckBox(
                  value: stows.useMinecraftFont.value,
                  onChange: (value) => stows.useMinecraftFont.value = value,
                ),
              );
            },
          ),
          Text('Use Minecraft font'),
        ],
      ),
    );
  }
}
