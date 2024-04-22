import 'package:cuber/cuber.dart' as cuber;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExampleService {
  List<Map<String, dynamic>> getCubes(AppLocalizations locale) {
    List<Map<String, dynamic>> cubes = [
      {
        'name': locale.exampleMaxPark313,
        'cube': cuber.Cube.from(
            'BURFUFFUFURBBRFBBURLRBFRFLLDDUDDUDBLDLDFLDLRLURRUBDFLB'),
        'alg': "R2 D' F D L' U' F R D' F R U' L2 D' F2 B2 U L2 F2 U' D'",
        'moves': '21',
      },
      {
        'name': locale.exampleYushengDu347,
        'cube': cuber.Cube.yushengDu347,
        'alg': "R2 F2 B L B2 U2 D2 B U2 L U' R2 D B2 D2 F2 B2 R2 F2 U'",
        'moves': '20',
      },
      {
        'name': locale.exampleFeliksZemdegs422,
        'cube': cuber.Cube.feliksZemdegs422,
        'alg': "U2 B' R2 L2 B D B' U F2 B' L' F2 R2 D B2 R2 U L2 U' B2 U2",
        'moves': '21',
      },
      {
        'name': locale.examplePllJa,
        'cube': cuber.Cube.from(
            'UUUUUUUUURRRRRRRRRLLFFFFFFFDDDDDDDDDFFBLLLLLLBBLBBBBBB'),
        'alg': "U B2 U' B2 D B2 D' R2 U R2 B2",
        'moves': '11',
      },
      {
        'name': locale.examplePllJb,
        'cube': cuber.Cube.from(
            'UUUUUUUUUBFFRRRRRRFRRFFFFFFDDDDDDDDDLLLLLLLLLRBBBBBBBB'),
        'alg': "U R2 B2 U B2 U' B2 D B2 D' R2",
        'moves': '11',
      },
      {
        'name': locale.examplePllY,
        'cube': cuber.Cube.from(
            'UUUUUUUUULRRRRRRRRFFBFFFFFFDDDDDDDDDRBLLLLLLLBLFBBBBBB'),
        'alg': "R U R' F2 L D' L' U L2 U' L2 D L2 U L2 U' F2",
        'moves': '17',
      },
      {
        'name': locale.examplePllH,
        'cube': cuber.Cube.from(
            'UUUUUUUUURLRRRRRRRFBFFFFFFFDDDDDDDDDLRLLLLLLLBFBBBBBBB'),
        'alg': "U R2 F2 B2 L2 D' R2 F2 B2 L2",
        'moves': '10',
      },
      {
        'name': locale.exampleSune,
        'cube': cuber.Cube.from(
            'RUFUUUUULBBURRRRRRBFUFFFFFFDDDDDDDDDFRRLLLLLLLLUBBBBBB'),
        'alg': "R U R2 U' R2 U R U2 F2 R2 F2 U2 F2 R2 F2 U",
        'moves': '16',
      },
      {
        'name': locale.exampleCheckerboard,
        'cube': cuber.Cube.from(
            'UDUDUDUDURLRLRLRLRFBFBFBFBFDUDUDUDUDLRLRLRLRLBFBFBFBFB'),
        'alg': "U2 D2 R2 L2 F2 B2",
        'moves': '6',
      },
      {
        'name': locale.exampleCheckerboard2,
        'cube': cuber.Cube.checkerboard,
        'alg': "F' R L' F2 U D' R2 F' B R' U R2 L2 F2 B2 D B2 D2 B2 U2",
        'moves': '20',
      },
      {
        'name': locale.exampleCrossOne,
        'cube': cuber.Cube.crossOne,
        'alg': "U R2 L2 F2 U2 D2 R2 L2 B2 U D2",
        'moves': '11',
      },
      {
        'name': locale.exampleCrossTwo,
        'cube': cuber.Cube.crossTwo,
        'alg': "R U2 F2 B2 U2 F2 B2 R L2 U F2 B2 U2 R2 L2 D F2 B2",
        'moves': '18',
      },
      {
        'name': locale.exampleCubeInCube,
        'cube': cuber.Cube.cubeInCube,
        'alg': "U' B2 D' F' L F' L F' L D B2 U' F2 R2 U2",
        'moves': '15',
      },
      {
        'name': locale.exampleCubeInCubeInCube,
        'cube': cuber.Cube.cubeInCubeInCube,
        'alg': "U R D B R2 F2 R L2 B2 D B' R2 D2 R2 D' L2 F2 U' B2 D' F2",
        'moves': '21',
      },
      {
        'name': locale.exampleAnaconda,
        'cube': cuber.Cube.anaconda,
        'alg': "R B U' R' U' B2 U L B L' U B2 U' B2 U' L2 U' L2 U' B2",
        'moves': '20',
      },
      {
        'name': locale.examplePython,
        'cube': cuber.Cube.python,
        'alg': "U R U F' L2 F U' R' F2 U' F2 U L2 U' F2 D L2 D'",
        'moves': '18',
      },
      {
        'name': locale.exampleFourSpots,
        'cube': cuber.Cube.fourSpots,
        'alg': "U R2 L2 U D' F2 B2 D'",
        'moves': '8',
      },
      {
        'name': locale.exampleSixSpots,
        'cube': cuber.Cube.sixSpots,
        'alg': "U D F B R L U2 L2 F2 R2 D2 L2 B2 U' D' F2",
        'moves': '16',
      },
      {
        'name': locale.exampleSixTs,
        'cube': cuber.Cube.sixTs,
        'alg': "U D F2 R2 U D' L2 B2 D2",
        'moves': '9',
      },
      {
        'name': locale.exampleStripes,
        'cube': cuber.Cube.stripes,
        'alg': "R L' F U D' L2 B2 L F B' U' F2 D F2 B2 U B2 R2 F2 D",
        'moves': '20',
      },
      {
        'name': locale.exampleTetris,
        'cube': cuber.Cube.tetris,
        'alg': "U D F B R L F2 R2 F2 R2 U' D' R2 F2 L2 B2",
        'moves': '16',
      },
      {
        'name': locale.exampleSpiral,
        'cube': cuber.Cube.spiral,
        'alg': "R2 L U F D2 B R' U2 L' U B' R2 U2 R2 D' B2 U F2 U' B2 U",
        'moves': '21',
      },
      {
        'name': locale.exampleTwister,
        'cube': cuber.Cube.twister,
        'alg': "U' F2 U R' U2 R F' R2 F' U2 R2 F2 R2 U2 F2 R2 U' F2 U",
        'moves': '19',
      },
      {
        'name': locale.exampleWire,
        'cube': cuber.Cube.wire,
        'alg': "R L U2 R L F2 U' D' F2 B2 R2 U D F2",
        'moves': '14',
      },
      {
        'name': locale.exampleChickenFeet,
        'cube': cuber.Cube.chickenFeet,
        'alg': "R B2 U2 L' F' U D R' L' F' L2 F2 D R2 F2 U B2 D L2 U'",
        'moves': '20',
      },
      {
        'name': locale.exampleSolved,
        'cube': cuber.Cube.solved,
        'alg': '',
        'moves': '0',
      },
    ];

    return cubes;
  }
}
