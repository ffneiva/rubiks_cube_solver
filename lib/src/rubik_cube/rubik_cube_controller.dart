import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_service.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';

class RubikCubeController with ChangeNotifier {
  static final RubikCubeController _instance =
      RubikCubeController._internal(RubikCubeService());

  factory RubikCubeController() => _instance;

  RubikCubeController._internal(this._rubikCubeService);

  final RubikCubeService _rubikCubeService;

  late List<List<Color>> _faceColors;
  late int _sides;
  late Color _defaultColor;

  int get sides => _sides;
  Color get defaultColor => _defaultColor;
  List<List<Color>> get faceColors => _faceColors;

  Future<void> loadRubikCube(SettingsController settingsController) async {
    _sides = _rubikCubeService.sides();
    _defaultColor = _rubikCubeService.defaultColor();
    _faceColors = _rubikCubeService.colors(
      _sides,
      _defaultColor,
      settingsController.colors,
    );
    notifyListeners();
  }

  Future<void> clearColors(SettingsController settingsController) async {
    _faceColors = _rubikCubeService.colors(
      _sides,
      _defaultColor,
      settingsController.colors,
    );
    notifyListeners();
  }

  Future<void> updateSticker(Color? newColor, int face, int sticker) async {
    if (newColor == null) return;
    if (sticker == (sides * sides ~/ 2)) return;

    _faceColors[face][sticker] = newColor;

    notifyListeners();

    await _rubikCubeService.updateColors(_faceColors);
  }

  Future<void> solve(SettingsController settingsController) async {
    for (int face = 0; face < 6; face++) {
      for (int sticker = 0; sticker < pow(sides, 2); sticker++) {
        if (_faceColors[face][sticker] == Colors.transparent) {
          return;
        }
        if (!settingsController.colors.contains(_faceColors[face][sticker])) {
          return;
        }
      }
    }
    print(colors2notation(settingsController, _faceColors));
  }

  String colors2notation(
      SettingsController settingsController, List<List<Color>> colors) {
    String notation = '';
    for (int face = 0; face < 6; face++) {
      for (int sticker = 0; sticker < pow(sides, 2); sticker++) {
        if (_faceColors[face][sticker] == settingsController.colors[face]) {
          switch (face) {
            case 0:
              notation += 'U';
            case 1:
              notation += 'L';
            case 2:
              notation += 'F';
            case 3:
              notation += 'R';
            case 4:
              notation += 'B';
            case 5:
              notation += 'D';
          }
        }
      }
    }
    return notation;
  }
}
