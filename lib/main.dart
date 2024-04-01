import 'package:flutter/material.dart';
import 'package:rubiks_cube_solver/src/historic/historic_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/utils/database.dart';
import 'package:sqflite/sqflite.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController();
  final rubikCubeController = RubikCubeController();
  final historicController = HistoricController();

  settingsController.setRubikCubeController(rubikCubeController);
  rubikCubeController.setSettingsController(settingsController);
  rubikCubeController.setHistoricController(historicController);

  await settingsController.loadSettings();
  await rubikCubeController.loadRubikCube();

  Database database = await DatabaseHelper().initDatabase();
  if (!database.isOpen) {
    return;
  }

  runApp(RubikApp(
    settingsController: settingsController,
    rubikCubeController: rubikCubeController,
    historicController: historicController,
  ));
}
