import 'dart:math';
import 'package:cuber/cuber.dart' as cuber;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:rubiks_cube_solver/src/historic/historic_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_service.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';

class RubikCubeController with ChangeNotifier {
  static final RubikCubeController _instance =
      RubikCubeController._internal(RubikCubeService());

  factory RubikCubeController() => _instance;

  RubikCubeController._internal(this._rubikCubeService);

  late SettingsController _settingsController;
  late HistoricController _historicController;
  final RubikCubeService _rubikCubeService;

  late List<List<Color>> _faceColors;
  late int _sides;
  late Color _defaultColor;

  int get sides => _sides;
  Color get defaultColor => _defaultColor;
  List<List<Color>> get faceColors => _faceColors;

  void setSettingsController(SettingsController controller) =>
      _settingsController = controller;

  void setHistoricController(HistoricController controller) =>
      _historicController = controller;

  void setFaceColors(List<List<Color>> colors) => _faceColors = colors;

  Future<void> loadRubikCube() async {
    _sides = _rubikCubeService.sides();
    _defaultColor = _rubikCubeService.defaultColor();
    _faceColors = _rubikCubeService.colors(
      _sides,
      _defaultColor,
      _settingsController.colors,
    );
    notifyListeners();
  }

  Future<void> clearColors() async {
    _faceColors = _rubikCubeService.colors(
      _sides,
      _defaultColor,
      _settingsController.colors,
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

  Future<Map<String, String>> solve(AppLocalizations locale) async {
    for (int face = 0; face < 6; face++) {
      for (int sticker = 0; sticker < pow(sides, 2); sticker++) {
        if (_faceColors[face][sticker] == Colors.transparent) {
          return {'error': locale.messageNotFilled};
        }
        if (!_settingsController.colors.any((materialColor) =>
            materialColor.value == _faceColors[face][sticker].value)) {
          return {'error': locale.messageInvalidFilling};
        }
      }
    }

    try {
      String scramble = colors2notation(_faceColors);
      cuber.Cube cube = cuber.Cube.from(scramble);

      if (cube == cuber.Cube.solved) {
        return {'error': locale.messageCubeSolved};
      }

      Stream<cuber.Solution> solutions =
          cube.solveDeeply(timeout: const Duration(seconds: 3));
      cuber.Solution solution = await solutions.first;

      String solve = solution.toString();
      String time = solution.elapsedTime.toString();
      String moves = solution.length.toString();

      _historicController.saveSolutions({
        'date': DateTime.now().toString(),
        'scramble': scramble,
        'alg': solve,
        'time': time,
        'moves': moves,
      });

      return {'solve': solve, 'time': time.substring(6, 11), 'moves': moves};
    } catch (e) {
      return {'error': locale.messageNotFindSolution};
    }
  }

  void notation2colors(String notation) {
    notation = _getPart(notation, 0) +
        _getPart(notation, 4) +
        _getPart(notation, 2) +
        _getPart(notation, 1) +
        _getPart(notation, 5) +
        _getPart(notation, 3);
    int counter = 0;
    for (int face = 0; face < 6; face++) {
      for (int sticker = 0; sticker < pow(sides, 2); sticker++) {
        _faceColors[face][sticker] = _getFaceColor(notation[counter]);
        counter++;
      }
    }
  }

  String colors2notation(List<List<Color>> colors) {
    String notation = '';
    for (int face = 0; face < 6; face++) {
      for (int sticker = 0; sticker < pow(sides, 2); sticker++) {
        notation += _getFaceNotation(_faceColors[face][sticker]);
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

  String _getFaceNotation(Color color) {
    if (color == _settingsController.colors[0]) {
      return 'U';
    } else if (color == _settingsController.colors[1]) {
      return 'L';
    } else if (color == _settingsController.colors[2]) {
      return 'F';
    } else if (color == _settingsController.colors[3]) {
      return 'R';
    } else if (color == _settingsController.colors[4]) {
      return 'B';
    } else if (color == _settingsController.colors[5]) {
      return 'D';
    } else {
      return '';
    }
  }

  Color _getFaceColor(String notation) {
    if (notation == 'U') {
      return _settingsController.colors[0];
    } else if (notation == 'L') {
      return _settingsController.colors[1];
    } else if (notation == 'F') {
      return _settingsController.colors[2];
    } else if (notation == 'R') {
      return _settingsController.colors[3];
    } else if (notation == 'B') {
      return _settingsController.colors[4];
    } else if (notation == 'D') {
      return _settingsController.colors[5];
    } else {
      return Colors.transparent;
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
