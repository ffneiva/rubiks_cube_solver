import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_view.dart';
import 'package:rubiks_cube_solver/src/solve/solve_view.dart';
import 'package:rubiks_cube_solver/src/utils/functions.dart';
import 'package:rubiks_cube_solver/src/widgets/popup_item.dart';

Widget solutionListTile(BuildContext context, AppLocalizations locale,
    int index, Map<String, dynamic> solution, List<PopupMenuItem>? popupItems) {
  final RubikCubeController rubikCubeController = RubikCubeController();

  String subtitle = '';
  if (solution['date'] != null && solution['date'] != '') {
    String date = formatDate(DateTime.parse(solution['date']));
    subtitle += '\n${locale.date}: $date\n';
  }
  if (solution['alg'] != null && solution['alg'] != '') {
    subtitle += '\n${locale.exampleSolution}: ${solution['alg']}\n';
  }
  if (solution['moves'] != null && solution['moves'] != '') {
    subtitle += '\n${locale.historicMovesQuantity}: ${solution['moves']}\n';
  }

  subtitle = subtitle.replaceAll('\n\n', '\n');
  subtitle = subtitle.trim();

  return ListTile(
    dense: true,
    visualDensity: VisualDensity.compact,
    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RubikCubeView(solution: solution)),
    ),
    onLongPress: () {
      Clipboard.setData(ClipboardData(text: solution['alg']));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.snackBarSolutionCopied)),
      );
    },
    leading: Text('(${index + 1})'),
    title: Text(
      solution['name'] ?? solution['alg'],
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(subtitle),
    trailing: PopupMenuButton(itemBuilder: (BuildContext context) {
      return <PopupMenuEntry>[
        popupItem(
          context,
          locale.solvePage,
          Icons.extension,
          () {
            Navigator.pop(context);
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SolveView(solve: solution['alg']!)),
            );
          },
        ),
        popupItem(
          context,
          locale.sendBluetooth,
          Icons.bluetooth,
          () {
            Navigator.pop(context);
            rubikCubeController.sendSolveViaBluettoth(locale, solution['alg']);
          },
        ),
        ...?popupItems,
      ];
    }),
  );
}
