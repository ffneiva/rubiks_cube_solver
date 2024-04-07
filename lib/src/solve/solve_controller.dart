import 'package:flutter/material.dart';
import 'package:rubiks_cube_solver/src/solve/solve_service.dart';

class SolveController with ChangeNotifier {
  static final SolveController _instance =
      SolveController._internal(SolveService());

  factory SolveController() => _instance;

  SolveController._internal(this._solveService);

  final SolveService _solveService;
}
