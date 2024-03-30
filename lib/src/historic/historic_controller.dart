import 'package:flutter/material.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';
import 'historic_service.dart';

class HistoricController with ChangeNotifier {
  static final HistoricController _instance =
      HistoricController._internal(HistoricService());

  factory HistoricController() => _instance;

  HistoricController._internal(this._historicService);

  late RubikCubeController _rubikCubeController;
  late SettingsController _settingsController;
  final HistoricService _historicService;

  void setSettingsController(SettingsController controller) {
    _settingsController = controller;
  }

  void setRubikCubeController(RubikCubeController controller) {
    _rubikCubeController = controller;
  }

  Future<void> loadHistoric() async {
    notifyListeners();
  }
}
