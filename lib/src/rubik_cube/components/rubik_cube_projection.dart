import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/components/rubik_cube_face.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';

class RubikCubeProjection extends StatefulWidget {
  final SettingsController settingsController;
  final RubikCubeController rubikCubeController;

  const RubikCubeProjection({
    Key? key,
    required this.settingsController,
    required this.rubikCubeController,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RubikCubeProjection createState() => _RubikCubeProjection();
}

class _RubikCubeProjection extends State<RubikCubeProjection> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    List<Map<String, dynamic>> data = [
      {
        'title': locale.projectionUp,
        'color': widget.settingsController.colors[0],
      },
      {
        'title': locale.projectionLeft,
        'color': widget.settingsController.colors[1],
      },
      {
        'title': locale.projectionFront,
        'color': widget.settingsController.colors[2],
      },
      {
        'title': locale.projectionRight,
        'color': widget.settingsController.colors[3],
      },
      {
        'title': locale.projectionBack,
        'color': widget.settingsController.colors[4],
      },
      {
        'title': locale.projectionDown,
        'color': widget.settingsController.colors[5],
      },
    ];

    List<Widget> rubikCubeFaces = [];
    for (int i = 0; i < data.length; i++) {
      rubikCubeFaces
          .add(_rubikCubeFace(context, data[i]['title'], data[i]['color'], i));
    }

    double aspectRatio = MediaQuery.of(context).size.width /
        (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            kToolbarHeight -
            100) /
        2 *
        3;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: aspectRatio,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      crossAxisCount: 2,
      children: rubikCubeFaces,
    );
  }

  Widget _rubikCubeFace(
      BuildContext context, String title, Color color, int face) {
    List<Widget> stickers = [];
    for (int i = 0; i < pow(widget.rubikCubeController.sides, 2); i++) {
      stickers.add(_sticker(widget.rubikCubeController.faceColors[face][i]));
    }

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              )),
          InkWell(
            onTap: () => _takePhoto(face),
            child: const Icon(Icons.camera_alt_rounded),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: GestureDetector(
          onTap: () => _onClickCubeFace(context, title, face),
          child: Container(
            height: MediaQuery.of(context).size.width / 2 - 2 * 16,
            width: MediaQuery.of(context).size.width / 2 - 2 * 16,
            alignment: Alignment.center,
            child: GridView.count(
              crossAxisCount: widget.rubikCubeController.sides,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: stickers,
            ),
          ),
        ),
      ),
    ]);
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

  Future<void> _takePhoto(int face) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await imageFile.delete();
    }
  }

  void _onClickCubeFace(BuildContext context, String title, int face) {
    AppLocalizations locale = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: RubikCubeFace(
                face: face,
                settingsController: widget.settingsController,
                rubikCubeController: widget.rubikCubeController,
              ),
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
    ).then((value) => setState(() {}));
  }
}
