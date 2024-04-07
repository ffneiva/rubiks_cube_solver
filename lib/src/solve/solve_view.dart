import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';

class SolveView extends StatefulWidget {
  final String solve;

  const SolveView({
    Key? key,
    required this.solve,
  }) : super(key: key);

  static const routeName = '/solve';

  @override
  // ignore: library_private_types_in_public_api
  _SolveView createState() => _SolveView();
}

class _SolveView extends State<SolveView> {
  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final RubikCubeController rubikCubeController = RubikCubeController();
    AppLocalizations locale = AppLocalizations.of(context)!;
    List<String> solution = widget.solve.split(' ');

    List<Widget> solutionMoves = [];
    for (int i = 0; i < solution.length; i++) {
      solutionMoves.add(_move(locale, i + 1, widget.solve.split(' ')[i]));
    }

    return RubikScaffold(
      title: locale.solvePage,
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(16),
        child: Center(child: Column(children: solutionMoves)),
      ),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          offset: const Offset(0, 50),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              _popupItem(
                locale.solveReturnToTop,
                Icons.straight_outlined,
                () => scrollController.animateTo(0,
                    duration: const Duration(seconds: 1),
                    curve: Curves.bounceInOut),
              ),
              _popupItem(
                locale.sendBluetooth,
                Icons.bluetooth,
                () => rubikCubeController.sendSolveViaBluettoth(
                    locale, widget.solve),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _move(AppLocalizations locale, int index, String move) {
    String localeMove = '';
    switch (move) {
      case 'U':
        localeMove = locale.moveU;
        break;
      case 'U\'':
        localeMove = locale.moveUprime;
        break;
      case 'U2':
        localeMove = locale.moveU2;
        break;
      case 'L':
        localeMove = locale.moveL;
        break;
      case 'L\'':
        localeMove = locale.moveLprime;
        break;
      case 'L2':
        localeMove = locale.moveL2;
        break;
      case 'F':
        localeMove = locale.moveF;
        break;
      case 'F\'':
        localeMove = locale.moveFprime;
        break;
      case 'F2':
        localeMove = locale.moveF2;
        break;
      case 'R':
        localeMove = locale.moveR;
        break;
      case 'R\'':
        localeMove = locale.moveRprime;
        break;
      case 'R2':
        localeMove = locale.moveR2;
        break;
      case 'B':
        localeMove = locale.moveB;
        break;
      case 'B\'':
        localeMove = locale.moveBprime;
        break;
      case 'B2':
        localeMove = locale.moveB2;
        break;
      case 'D':
        localeMove = locale.moveD;
        break;
      case 'D\'':
        localeMove = locale.moveDprime;
        break;
      case 'D2':
        localeMove = locale.moveD2;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(children: [
        Text('$index - $localeMove ($move)'),
        Image.asset('assets/moves/$move.png'),
      ]),
    );
  }

  dynamic _popupItem(String title, IconData icon, VoidCallback onTap) =>
      PopupMenuItem(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          dense: true,
          contentPadding: const EdgeInsets.all(0),
          onTap: () {
            onTap();
            Navigator.of(context).pop();
            setState(() {});
          },
        ),
      );
}
