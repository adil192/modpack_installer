import 'package:flutter/material.dart';

class Painting extends StatelessWidget {
  const Painting({super.key, required this.paintingHash, required this.size});
  final int paintingHash;
  final double size;

  @override
  Widget build(BuildContext context) {
    final index = paintingHash.abs() % paintings.length;
    return Stack(
      children: [
        Image(
          image: paintings[index],
          width: size,
          height: size,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none, // Pixelated
        ),
        // The paintings are different resolutions leading to inconsistent borders.
        // Add borders here to make them look more uniform.
        Positioned.fill(
          child: Container(
            foregroundDecoration: BoxDecoration(
              border: Border.all(color: Color(0xFF503405), width: size / 16),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            foregroundDecoration: BoxDecoration(
              border: Border.all(color: Color(0xFF491704), width: size / 32),
            ),
          ),
        ),
      ],
    );
  }

  /// Paintings sourced from
  /// https://github.com/Faithful-Resource-Pack/Faithful-32x-Java/tree/java-snapshot/assets/minecraft/textures/painting
  static const paintings = [
    AssetImage('assets/painting/alban.png'),
    AssetImage('assets/painting/aztec.png'),
    AssetImage('assets/painting/aztec2.png'),
    AssetImage('assets/painting/baroque.png'),
    AssetImage('assets/painting/bomb.png'),
    AssetImage('assets/painting/bouquet.png'),
    AssetImage('assets/painting/burning_skull.png'),
    AssetImage('assets/painting/bust.png'),
    AssetImage('assets/painting/cavebird.png'),
    AssetImage('assets/painting/cotan.png'),
    AssetImage('assets/painting/dennis.png'),
    AssetImage('assets/painting/earth.png'),
    AssetImage('assets/painting/endboss.png'),
    AssetImage('assets/painting/fern.png'),
    AssetImage('assets/painting/fire.png'),
    AssetImage('assets/painting/humble.png'),
    AssetImage('assets/painting/kebab.png'),
    AssetImage('assets/painting/match.png'),
    AssetImage('assets/painting/meditative.png'),
    AssetImage('assets/painting/orb.png'),
    AssetImage('assets/painting/owlemons.png'),
    AssetImage('assets/painting/pigscene.png'),
    AssetImage('assets/painting/plant.png'),
    AssetImage('assets/painting/pointer.png'),
    AssetImage('assets/painting/skull_and_roses.png'),
    AssetImage('assets/painting/stage.png'),
    AssetImage('assets/painting/sunflowers.png'),
    AssetImage('assets/painting/tides.png'),
    AssetImage('assets/painting/unpacked.png'),
    AssetImage('assets/painting/void.png'),
    AssetImage('assets/painting/wasteland.png'),
    AssetImage('assets/painting/water.png'),
    AssetImage('assets/painting/wind.png'),
    AssetImage('assets/painting/wither.png'),
  ];
}
