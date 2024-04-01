import 'package:flutter/material.dart';
import 'package:rubiks_cube_solver/src/historic/historic_service.dart';
import 'package:rubiks_cube_solver/src/utils/database.dart';
import 'package:sqflite/sqflite.dart';

class HistoricController with ChangeNotifier {
  static final HistoricController _instance =
      HistoricController._internal(HistoricService());

  factory HistoricController() => _instance;

  HistoricController._internal(this._historicService);

  final HistoricService _historicService;

  Future<void> saveSolutions(Map<String, String> solutions) async {
    DatabaseHelper().database.then((db) async {
      await db.insert(
        'solutions',
        solutions,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<List<Map<String, dynamic>>> getSolutions() async {
    final db = await DatabaseHelper().database;
    return await db.query('solutions');
  }

  Future<void> deleteSolution(String id) async {
    final db = await DatabaseHelper().database;
    db.delete('solutions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearSolutions() async {
    final db = await DatabaseHelper().database;
    db.delete('solutions');
  }

  Future<void> loadHistoric() async {
    notifyListeners();
  }
}
