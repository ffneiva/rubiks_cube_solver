import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/components/rubik_cube_face.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';

class RubikCubeProjection extends StatefulWidget {
  final RubikCubeController rubikCubeController;

  const RubikCubeProjection({
    Key? key,
    required this.rubikCubeController,
  }) : super(key: key);

  @override
  State<RubikCubeProjection> createState() => _RubikCubeProjectionState();
}

class _RubikCubeProjectionState extends State<RubikCubeProjection> {
  final SettingsController settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    List<Map<String, dynamic>> data = [
      {
        'title': locale.projectionUp,
        'color': settingsController.colors[0],
      },
      {
        'title': locale.projectionLeft,
        'color': settingsController.colors[1],
      },
      {
        'title': locale.projectionFront,
        'color': settingsController.colors[2],
      },
      {
        'title': locale.projectionRight,
        'color': settingsController.colors[3],
      },
      {
        'title': locale.projectionBack,
        'color': settingsController.colors[4],
      },
      {
        'title': locale.projectionDown,
        'color': settingsController.colors[5],
      },
    ];

    List<Widget> rubikCubeFaces = [];
    for (int i = 0; i < data.length; i++) {
      rubikCubeFaces
          .add(_rubikCubeFace(context, data[i]['title'], data[i]['color'], i));
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.80,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      crossAxisCount: 2,
      children: rubikCubeFaces,
    );
  }

  Widget _rubikCubeFace(
      BuildContext context, String title, Color color, int face) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return Column(children: [
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(title, textAlign: TextAlign.center),
      ),
      SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () async {
                await widget.rubikCubeController.takePhoto(locale, face);
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
                widget.rubikCubeController.rotate(face, clockwise: false);
                setState(() {});
              },
              child: const Icon(Icons.rotate_90_degrees_ccw_outlined),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: RubikCubeFace(
          rubikCubeController: widget.rubikCubeController,
          entireProject: false,
          title: title,
          face: face,
        ),
      ),
    ]);
  }
}
