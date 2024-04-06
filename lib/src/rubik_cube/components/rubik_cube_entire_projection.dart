import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/components/rubik_cube_face.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';

class RubikCubeEntireProjection extends StatefulWidget {
  final RubikCubeController rubikCubeController;

  const RubikCubeEntireProjection({
    Key? key,
    required this.rubikCubeController,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RubikCubeEntireProjection createState() => _RubikCubeEntireProjection();
}

class _RubikCubeEntireProjection extends State<RubikCubeEntireProjection> {
  final SettingsController settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    List<Map<String, dynamic>> data = [
      {
        'title': locale.projectionUp,
        'color': settingsController.colors[0],
        'x': 1,
        'y': 0,
      },
      {
        'title': locale.projectionLeft,
        'color': settingsController.colors[1],
        'x': 0,
        'y': 1,
      },
      {
        'title': locale.projectionFront,
        'color': settingsController.colors[2],
        'x': 1,
        'y': 1,
      },
      {
        'title': locale.projectionRight,
        'color': settingsController.colors[3],
        'x': 1,
        'y': 2,
      },
      {
        'title': locale.projectionBack,
        'color': settingsController.colors[4],
        'x': 1,
        'y': 3,
      },
      {
        'title': locale.projectionDown,
        'color': settingsController.colors[5],
        'x': 2,
        'y': 1,
      },
    ];

    int count = 0;
    List<Widget> rubikCubeFaces = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        var item = data.where((d) => d['x'] == i && d['y'] == j);
        if (item.isNotEmpty) {
          rubikCubeFaces.add(_rubikCubeFace(
              context, item.first['title'], item.first['color'], count));
          count++;
        } else {
          rubikCubeFaces.add(const SizedBox());
        }
      }
    }

    double height = min(MediaQuery.of(context).size.width * 4,
        MediaQuery.of(context).size.height - (kToolbarHeight * 2 + 8));

    return SizedBox(
      height: height,
      child: Center(
        child: SingleChildScrollView(
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            crossAxisCount: 4,
            children: rubikCubeFaces,
          ),
        ),
      ),
    );
  }

  Widget _rubikCubeFace(
      BuildContext context, String title, Color color, int face) {
    List<Widget> stickers = [];
    for (int i = 0; i < pow(widget.rubikCubeController.sides, 2); i++) {
      stickers.add(_sticker(widget.rubikCubeController.faceColors[face][i]));
    }

    return GestureDetector(
      onTap: () => _onClickCubeFace(context, title, face),
      child: Container(
        height: MediaQuery.of(context).size.width / 4 - 4 * 8,
        width: MediaQuery.of(context).size.width / 4 - 4 * 8,
        alignment: Alignment.center,
        child: GridView.count(
          crossAxisCount: widget.rubikCubeController.sides,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
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

  void _onClickCubeFace(BuildContext context, String title, int face) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Column(children: [
                Text(title),
                SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          await widget.rubikCubeController
                              .takePhoto(locale, face);
                          setState(() {});
                        },
                        child: const Icon(Icons.camera_alt_rounded),
                      ),
                      InkWell(
                        onTap: () {
                          widget.rubikCubeController.rotate(face);
                          setState(() {});
                        },
                        child: const Icon(Icons.rotate_90_degrees_cw_outlined),
                      ),
                      InkWell(
                        onTap: () {
                          widget.rubikCubeController
                              .rotate(face, clockwise: false);
                          setState(() {});
                        },
                        child: const Icon(Icons.rotate_90_degrees_ccw_outlined),
                      ),
                    ],
                  ),
                ),
              ]),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RubikCubeFace(face: face),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {Navigator.of(context).pop()},
                  child: Text(
                    locale.confirmButton,
                    style: const TextStyle(color: Colors.teal),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((value) => setState(() {}));
  }
}
