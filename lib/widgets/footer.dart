import 'package:flutter/material.dart';
import 'package:installer/widgets/use_minecraft_font_checkbox.dart';
import 'package:installer/widgets/version_or_update_status.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final column = screenSize.width < 480;
    return Flex(
      direction: column ? .vertical : .horizontal,
      children: [
        const UseMinecraftFontCheckbox(),
        column ? const SizedBox(height: 8) : const Spacer(),
        const VersionOrUpdateStatus(),
      ],
    );
  }
}
