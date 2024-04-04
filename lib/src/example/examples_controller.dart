import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/example/examples_service.dart';

class ExampleController with ChangeNotifier {
  static final ExampleController _instance =
      ExampleController._internal(ExampleService());

  factory ExampleController() => _instance;

  ExampleController._internal(this._exampleService);

  final ExampleService _exampleService;

  Future<List<Map<String, String>>> loadExamples(
      AppLocalizations locale) async {
    List<Map<String, dynamic>> cubes = _exampleService.getCubes(locale);

    List<Map<String, String>> examples = [];
    for (int i = 0; i < cubes.length; i++) {
      examples.add({
        'name': cubes[i]['name'],
        'alg': cubes[i]['alg'],
        'scramble': cubes[i]['cube'].definition,
        'moves': cubes[i]['moves'],
      });
    }

    return examples;
  }
}
