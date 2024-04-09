import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/components/rubik_cube_face_dialog.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';

class RubikCubeFace extends StatefulWidget {
  final RubikCubeController rubikCubeController;
  final bool entireProject;
  final String title;
  final int face;

  const RubikCubeFace({
    Key? key,
    required this.rubikCubeController,
    required this.title,
    required this.face,
    required this.entireProject,
  }) : super(key: key);

  @override
  State<RubikCubeFace> createState() => _RubikCubeFaceState();
}

class _RubikCubeFaceState extends State<RubikCubeFace> {
  @override
  Widget build(BuildContext context) {
    List<Widget> stickers = [];
    for (int i = 0; i < pow(widget.rubikCubeController.sides, 2); i++) {
      stickers
          .add(_sticker(widget.rubikCubeController.faceColors[widget.face][i]));
    }

    double faceSize = widget.entireProject
        ? MediaQuery.of(context).size.width / 4 - 4 * 8
        : MediaQuery.of(context).size.width / 2 - 2 * 16;

    return GestureDetector(
      onTap: () => _onClickCubeFace(context, widget.title, widget.face),
      child: Container(
        height: faceSize,
        width: faceSize,
        alignment: Alignment.center,
        child: GridView.count(
          crossAxisCount: widget.rubikCubeController.sides,
          crossAxisSpacing: widget.entireProject ? 2 : 5,
          mainAxisSpacing: widget.entireProject ? 2 : 5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: stickers,
        ),
      ),
    );
  }

  Widget _sticker(Color color) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).hintColor),
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
    );
  }

  Widget _faceToolbox(AppLocalizations locale, int face, Function setStatee) {
    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () async {
              await widget.rubikCubeController.takePhoto(locale, face);
              setState(() {});
              setStatee(() {});
            },
            child: const Icon(Icons.camera_alt_rounded),
          ),
          InkWell(
            onTap: () {
              widget.rubikCubeController.rotate(face);
              setState(() {});
              setStatee(() {});
            },
            child: const Icon(Icons.rotate_90_degrees_cw_outlined),
          ),
          InkWell(
            onTap: () {
              widget.rubikCubeController.rotate(face, clockwise: false);
              setState(() {});
              setStatee(() {});
            },
            child: const Icon(Icons.rotate_90_degrees_ccw_outlined),
          ),
        ],
      ),
    );
  }

  void _onClickCubeFace(BuildContext context, String title, int face) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Column(children: [
              Text(title),
              _faceToolbox(locale, face, setState),
            ]),
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: RubikCubeFaceDialog(
                  rubikCubeController: widget.rubikCubeController,
                  face: face,
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  locale.confirmButton,
                  style: const TextStyle(color: Colors.teal),
                ),
              ),
            ],
          );
        });
      },
    ).then((value) => setState(() {}));
  }
}
