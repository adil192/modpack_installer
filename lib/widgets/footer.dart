import 'package:flutter/material.dart';
import 'package:installer/util/stows.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        children: [
          ValueListenableBuilder(
            valueListenable: stows.useMinecraftFont,
            builder: (context, _, _) {
              return Checkbox.adaptive(
                value: stows.useMinecraftFont.value,
                onChanged: (value) => stows.useMinecraftFont.value = value!,
              );
            },
          ),
          Text('Use Minecraft font'),
        ],
      ),
    );
  }
}
