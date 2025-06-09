import 'package:flutter/material.dart';
import 'package:installer/widgets/theme_provider.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        children: [
          Checkbox.adaptive(
            value: ThemeProvider.of(context).useMinecraftFont,
            onChanged: (value) =>
                ThemeProvider.of(context).useMinecraftFont = value!,
          ),
          Text('Use Minecraft font'),
        ],
      ),
    );
  }
}
