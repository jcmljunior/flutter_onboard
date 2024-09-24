import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@immutable
class Colorize extends ColorMapper {
  final List<Color> targetColors;
  final List<Color> replacementColors;

  const Colorize({
    required this.targetColors,
    required this.replacementColors,
  });

  @override
  Color substitute(
      String? id, String elementName, String attributeName, Color color) {
    for (int i = 0; i < targetColors.length; i++) {
      if (color == targetColors[i]) {
        return replacementColors[i];
      }
    }

    return color;
  }
}
