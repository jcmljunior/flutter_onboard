import 'dart:ui' show Color;
import 'package:flutter_svg/flutter_svg.dart';

class ColorizeVector extends ColorMapper {
  final List<Color> targetColors;
  final List<Color> replacementColors;

  const ColorizeVector({
    required this.targetColors,
    required this.replacementColors,
  }) : assert(targetColors.length == replacementColors.length,
            'targetColors e replacementColors devem ter o mesmo tamanho.');

  @override
  Color substitute(
    String? id,
    String elementName,
    String attributeName,
    Color color,
  ) {
    for (int i = 0; i < targetColors.length; i++) {
      if (color == targetColors[i]) {
        return replacementColors[i];
      }
    }

    return color;
  }
}
