import 'package:flutter/material.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';

void main() async {
  final settingsController = SettingsController();
  final rubikCubeController = RubikCubeController();

  settingsController.setRubikCubeController(rubikCubeController);
  rubikCubeController.setSettingsController(settingsController);

  await settingsController.loadSettings();
  await rubikCubeController.loadRubikCube();

  runApp(RubikApp(
    settingsController: settingsController,
    rubikCubeController: rubikCubeController,
  ));
}
