import 'dart:math';
import 'package:cuber/cuber.dart' as cuber;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  Future<Map<String, String>> solve(
      SettingsController settingsController, AppLocalizations locale) async {
    for (int face = 0; face < 6; face++) {
      for (int sticker = 0; sticker < pow(sides, 2); sticker++) {
        if (_faceColors[face][sticker] == Colors.transparent) {
          return {'error': locale.messageNotFilled};
        }
        if (!settingsController.colors.any((materialColor) =>
            materialColor.value == _faceColors[face][sticker].value)) {
          return {'error': locale.messageInvalidFilling};
        }
      }
    }

    try {
      String scramble = colors2notation(settingsController, _faceColors);
      cuber.Cube cube = cuber.Cube.from(scramble);
      if (cube == cuber.Cube.solved) {
        return {'error': locale.messageCubeSolved};
      }
      Stream<cuber.Solution> solutions =
          cube.solveDeeply(timeout: const Duration(seconds: 3));
      cuber.Solution solution = await solutions.first;
      return {
        'solve': solution.toString(),
        'time': solution.elapsedTime.toString().substring(6),
        'moves': solution.length.toString(),
      };
    } catch (e) {
      return {'error': locale.messageNotFindSolution};
    }
  }

  String colors2notation(
      SettingsController settingsController, List<List<Color>> colors) {
    String notation = '';
    for (int face = 0; face < 6; face++) {
      for (int sticker = 0; sticker < pow(sides, 2); sticker++) {
        notation +=
            _getFaceNotation(settingsController, _faceColors[face][sticker]);
      }
    }

    notation = _getPart(notation, 0) +
        _getPart(notation, 3) +
        _getPart(notation, 2) +
        _getPart(notation, 5) +
        _getPart(notation, 1) +
        _getPart(notation, 4);
    return notation;
  }

  String _getFaceNotation(SettingsController settingsController, Color color) {
    if (color == settingsController.colors[0]) {
      return 'U';
    } else if (color == settingsController.colors[1]) {
      return 'L';
    } else if (color == settingsController.colors[2]) {
      return 'F';
    } else if (color == settingsController.colors[3]) {
      return 'R';
    } else if (color == settingsController.colors[4]) {
      return 'B';
    } else if (color == settingsController.colors[5]) {
      return 'D';
    } else {
      return '';
    }
  }

  String _getPart(String string, int part) {
    // Contagem de part inicia em 0
    int s = pow(sides, 2) as int;

    return part == 0
        ? string.substring(0, s)
        : string.substring(part * s, (part + 1) * s);
  }
}
