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
  State<RubikCubeEntireProjection> createState() =>
      _RubikCubeEntireProjectionState();
}

class _RubikCubeEntireProjectionState extends State<RubikCubeEntireProjection> {
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
        'x': 2,
        'y': 1,
      },
      {
        'title': locale.projectionBack,
        'color': settingsController.colors[4],
        'x': 3,
        'y': 1,
      },
      {
        'title': locale.projectionDown,
        'color': settingsController.colors[5],
        'x': 1,
        'y': 2,
      },
    ];

    int count = 0;
    List<Widget> rubikCubeFaces = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 4; j++) {
        var item = data.where((d) => d['y'] == i && d['x'] == j);
        if (item.isNotEmpty) {
          rubikCubeFaces.add(RubikCubeFace(
            rubikCubeController: widget.rubikCubeController,
            entireProject: true,
            title: item.first['title'],
            face: count,
          ));
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
}
