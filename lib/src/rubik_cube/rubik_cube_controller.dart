import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cuber/cuber.dart' as cuber;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette_generator/palette_generator.dart';
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

  Future<void> takePhoto(AppLocalizations locale, int face) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final List<Color> colors = _settingsController.colors;

    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: locale.rubikCubeCropper,
            toolbarColor: Colors.teal,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(title: locale.rubikCubeCropper),
        ],
      );

      if (croppedFile != null) {
        final paletteGenerator = await PaletteGenerator.fromImageProvider(
          FileImage(File(croppedFile.path)),
        );

        if (paletteGenerator.colors.isNotEmpty) {
          final List<Color> averageColors = [];
          final File image = File(croppedFile.path);
          final bytes = await image.readAsBytes();
          final codec = await instantiateImageCodec(bytes);
          final frameInfo = await codec.getNextFrame();

          final imageWidth = frameInfo.image.width;
          final imageHeight = frameInfo.image.height;

          final double squareSize = min(imageWidth, imageHeight) / _sides;

          for (int i = 0; i < _sides; i++) {
            for (int j = 0; j < _sides; j++) {
              final int x = (j * squareSize).toInt();
              final int y = (i * squareSize).toInt();
              final int halfSize = squareSize ~/ 2;
              final int centerX = x + halfSize;
              final int centerY = y + halfSize;
              final ByteData? byteData = await frameInfo.image.toByteData();
              if (byteData != null) {
                final Uint8List uint8List = byteData.buffer.asUint8List();
                const int bytesPerPixel = 4;
                final int stride = bytesPerPixel * imageWidth;
                final int pixelIndex =
                    centerY * stride + centerX * bytesPerPixel;

                final int red = uint8List[pixelIndex];
                final int green = uint8List[pixelIndex + 1];
                final int blue = uint8List[pixelIndex + 2];
                final double alpha = uint8List[pixelIndex + 3] / 255.0;

                averageColors.add(Color.fromRGBO(red, green, blue, alpha));
              }
            }
          }

          final List<Color> closestColors = [];

          for (final color in averageColors) {
            double minDistance = double.infinity;
            Color closestColor = colors.first;

            for (final candidateColor in colors) {
              final distance = _colorDistance(color, candidateColor);
              if (distance < minDistance) {
                minDistance = distance;
                closestColor = candidateColor;
              }
            }

            closestColors.add(closestColor);
          }

          for (int i = 0; i < closestColors.length; i++) {
            if (sides.isEven || (i != (pow(sides, 2) ~/ 2))) {
              _faceColors[face][i] = closestColors[i];
            }
          }
        }
      }
    }

    notifyListeners();
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

      if (_settingsController.blueCharacteristic != null) {
        try {
          _settingsController.blueCharacteristic!.write(getBlueSolution(solve));
        } catch (e) {
          return {'error': locale.messageBluetoothError};
        }
      }

      return {'solve': solve, 'time': time.substring(6, 11), 'moves': moves};
    } catch (e) {
      return {'error': locale.messageNotFindSolution};
    }
  }

  void rotate(int face, {bool clockwise = true}) {
    List<Color> previousColors = List.from(_faceColors[face]);
    List<int> index = _getIndices();

    if (!clockwise) {
      index = index.reversed.toList();
    }

    for (int i = 0; i < pow(sides, 2); i++) {
      _faceColors[face][i] = previousColors[index[i]];
    }

    notifyListeners();
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

  List<int> getBlueSolution(String solve) {
    String solution = _settingsController.blueCharOptions[0] +
        solve.replaceAll(' ', _settingsController.blueCharOptions[1]) +
        _settingsController.blueCharOptions[2];
    return solution.codeUnits;
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

  List<int> _getIndices() {
    List<int> indices = [];
    for (int i = 0; i < pow(sides, 2); i++) {
      if (sides.isEven || (i != (pow(sides, 2) ~/ 2))) {
        indices.add((_sides - 1 - i) * _sides +
            (i ~/ _sides) * (1 + pow(_sides, 2) as int));
      } else {
        indices.add(i);
      }
    }
    return indices;
  }

  double _colorDistance(Color c1, Color c2) {
    return sqrt(
      pow(c1.red - c2.red, 2) +
          pow(c1.green - c2.green, 2) +
          pow(c1.blue - c2.blue, 2),
    );
  }
}
