import 'package:cuber/cuber.dart' as cuber;
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
    Map<String, cuber.Cube> cubes = {
      locale.exampleMaxPark313: cuber.Cube.from(
          'BURFUFFUFURBBRFBBURLRBFRFLLDDUDDUDBLDLDFLDLRLURRUBDFLB'),
      locale.exampleYushengDu347: cuber.Cube.yushengDu347,
      locale.exampleFeliksZemdegs422: cuber.Cube.feliksZemdegs422,
      locale.examplePllJa: cuber.Cube.from(
          'UUUUUUUUURRRRRRRRRLLFFFFFFFDDDDDDDDDFFBLLLLLLBBLBBBBBB'),
      locale.examplePllJb: cuber.Cube.from(
          'UUUUUUUUUBFFRRRRRRFRRFFFFFFDDDDDDDDDLLLLLLLLLRBBBBBBBB'),
      locale.exampleCheckerboard: cuber.Cube.from(
          'UDUDUDUDURLRLRLRLRFBFBFBFBFDUDUDUDUDLRLRLRLRLBFBFBFBFB'),
      locale.exampleCheckerboard2: cuber.Cube.checkerboard,
      locale.exampleCrossOne: cuber.Cube.crossOne,
      locale.exampleCrossTwo: cuber.Cube.crossTwo,
      locale.exampleCubeInCube: cuber.Cube.cubeInCube,
      locale.exampleCubeInCubeInCube: cuber.Cube.cubeInCubeInCube,
      locale.exampleAnaconda: cuber.Cube.anaconda, // Anaconda
      locale.examplePython: cuber.Cube.python,
      locale.exampleFourSpots: cuber.Cube.fourSpots,
      locale.exampleSixSpots: cuber.Cube.sixSpots,
      locale.exampleSixTs: cuber.Cube.sixTs,
      locale.exampleStripes: cuber.Cube.stripes,
      locale.exampleTetris: cuber.Cube.tetris,
      locale.exampleSpiral: cuber.Cube.spiral,
      locale.exampleTwister: cuber.Cube.twister,
      locale.exampleWire: cuber.Cube.wire,
      locale.exampleChickenFeet: cuber.Cube.chickenFeet,
    };

    List<Map<String, String>> examples = [];
    cubes.forEach((name, cube) async {
      cuber.Solution? solution = await _getSolution(cube);
      if (solution != null) {
        examples.add({
          'name': name,
          'alg': solution.toString(),
          'scramble': cube.definition,
          'moves': solution.length.toString(),
        });
      }
    });
    examples.add({
      'name': locale.exampleSolved,
      'alg': '',
      'scramble': cuber.Cube.solved.definition,
      'moves': '0',
    });

    return examples;
  }

  Future<cuber.Solution?> _getSolution(cuber.Cube cube) async {
    Stream<cuber.Solution> solutions =
        cube.solveDeeply(timeout: const Duration(seconds: 3));
    try {
      cuber.Solution solution = await solutions.first;
      return solution;
    } catch (e) {}
    return null;
  }
}
