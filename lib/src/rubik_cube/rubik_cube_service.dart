import 'dart:math';
import 'package:flutter/material.dart';

class RubikCubeService {
  int sides() => 3;

  Color defaultColor() => Colors.transparent;

  List<List<Color>> colors(int sides, Color color, List<Color> defaultColors) {
    List<List<Color>> faceColors =
        List.generate(6, (_) => List.filled(sides * sides, Colors.transparent));
    for (int face = 0; face < 6; face++) {
      for (int sticker = 0; sticker < pow(sides, 2); sticker++) {
        if (sides.isOdd && sticker == (sides * sides ~/ 2)) {
          faceColors[face][sticker] = defaultColors[face];
        } else {
          faceColors[face][sticker] = color;
        }
      }
    }
    return faceColors;
  }

  Future<void> updateSides(int sides) async {}

  Future<void> updateDefaultColor(Color defaultColor) async {}

  Future<void> updateColors(List<List<Color>> colors) async {}
}
