import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';

class RubikCubeFace extends StatefulWidget {
  final int face;
  final SettingsController settingsController;
  final RubikCubeController rubikCubeController;

  const RubikCubeFace({
    Key? key,
    required this.face,
    required this.settingsController,
    required this.rubikCubeController,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RubikCubeFace createState() => _RubikCubeFace();
}

class _RubikCubeFace extends State<RubikCubeFace> {
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    List<Widget> colorPalette = [];
    for (int i = 0; i < 6; i++) {
      colorPalette.add(_makeColorPallete(i));
    }
    return Column(
      children: [
        _rubikCubeFace(context, widget.face),
        const SizedBox(height: 20),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 6,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: colorPalette,
        ),
      ],
    );
  }

  Widget _makeColorPallete(int index) {
    Color color = widget.settingsController.colors[index];
    bool isSelected = selectedColor == color;
    Color borderColor = isSelected
        ? (color == Colors.teal ? Colors.teal.shade800 : Colors.teal)
        : Colors.black;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedColor == color) {
            selectedColor = null;
          } else {
            selectedColor = color;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.7) : color,
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3.0 : 1.5,
          ),
        ),
      ),
    );
  }

  Widget _rubikCubeFace(BuildContext context, int face) {
    List<Widget> stickers = [];
    for (int i = 0; i < pow(widget.rubikCubeController.sides, 2); i++) {
      stickers.add(_sticker(widget.rubikCubeController.faceColors[face][i], i));
    }

    return GestureDetector(
      child: GridView.count(
        crossAxisCount: widget.rubikCubeController.sides,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: stickers,
      ),
    );
  }

  Widget _sticker(Color color, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedColor == null) {
            widget.rubikCubeController
                .updateSticker(Colors.transparent, widget.face, index);
          } else {
            widget.rubikCubeController
                .updateSticker(selectedColor, widget.face, index);
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).hintColor),
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
      ),
    );
  }
}
