import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/historic/historic_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/widgets/popup_item.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';
import 'package:rubiks_cube_solver/src/widgets/solution_list_tile.dart';

class HistoricView extends StatefulWidget {
  const HistoricView({
    super.key,
  });

  static const routeName = '/historic';

  @override
  State<HistoricView> createState() => _HistoricViewState();
}

class _HistoricViewState extends State<HistoricView> {
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
              popupItem(context, locale.historicClearData, Icons.delete, () {
                Navigator.of(context).pop();
                _clearData(
                  locale,
                  locale.historicClearAllDataConfirmation,
                  historicController.clearSolutions(),
                );
                setState(() {});
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
                var solution = solutions![index];
                return solutionListTile(context, locale, index, solution, [
                  popupItem(
                    context,
                    locale.historicDeleteButton,
                    Icons.delete,
                    () {
                      _clearData(
                        locale,
                        locale.historicClearDataConfirmation(
                            index + 1, solution['alg']),
                        historicController
                            .deleteSolution(solution['id'].toString()),
                      );
                      setState(() {});
                    },
                  ),
                ]);
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
}
