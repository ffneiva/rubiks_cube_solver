import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/historic/historic_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_view.dart';
import 'package:rubiks_cube_solver/src/solve/solve_view.dart';
import 'package:rubiks_cube_solver/src/utils/functions.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';

class HistoricView extends StatefulWidget {
  const HistoricView({
    super.key,
  });

  static const routeName = '/historic';

  @override
  State<HistoricView> createState() => _HistoricView();
}

class _HistoricView extends State<HistoricView> {
  final HistoricController historicController = HistoricController();
  final RubikCubeController rubikCubeController = RubikCubeController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return RubikScaffold(
      title: locale.historicPage,
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          offset: const Offset(0, 50),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              _popupItem(locale.historicClearData, Icons.delete, () {
                Navigator.of(context).pop();
                _clearData(
                  locale,
                  locale.historicClearAllDataConfirmation,
                  historicController.clearSolutions(),
                );
              }),
            ];
          },
        ),
      ],
      body: FutureBuilder(
        future: historicController.getSolutions(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          var solutions = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(locale.historicErrorLoadingData));
          } else if (solutions == null || solutions.isEmpty) {
            return Center(child: Text(locale.historicNoData));
          } else {
            solutions = List.from(solutions)
              ..sort((a, b) => DateTime.parse(b['date'])
                  .compareTo(DateTime.parse(a['date'])));
            return ListView.builder(
              itemCount: solutions.length,
              itemBuilder: (context, index) {
                return historicListTile(locale, index, solutions![index]);
              },
            );
          }
        },
      ),
    );
  }

  void _clearData(
      AppLocalizations locale, String message, Future<void> onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                locale.closeButton,
                style: const TextStyle(color: Colors.teal),
              ),
            ),
            TextButton(
              onPressed: () {
                onPressed;
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text(
                locale.confirmButton,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget historicListTile(
      AppLocalizations locale, int index, Map<String, dynamic> solution) {
    var date = formatDate(DateTime.parse(solution['date']));
    var subtitle =
        '${locale.date}: $date\n${locale.historicMovesQuantity}: ${solution['moves']}';

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
        solution['alg'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      trailing: PopupMenuButton(itemBuilder: (BuildContext popupContext) {
        return <PopupMenuEntry>[
          _popupItem(
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
          _popupItem(
            locale.sendBluetooth,
            Icons.bluetooth,
            () {
              Navigator.pop(context);
              rubikCubeController.sendSolveViaBluettoth(
                  locale, solution['alg']);
            },
          ),
          _popupItem(
            locale.historicDeleteButton,
            Icons.delete,
            () => _clearData(
              locale,
              locale.historicClearDataConfirmation(index + 1, solution['alg']),
              historicController.deleteSolution(solution['id'].toString()),
            ),
          ),
        ];
      }),
    );
  }

  dynamic _popupItem(String title, IconData icon, VoidCallback onTap) =>
      PopupMenuItem(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          dense: true,
          contentPadding: const EdgeInsets.all(0),
          onTap: onTap,
        ),
      );
}
