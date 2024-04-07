import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/example/examples_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_view.dart';
import 'package:rubiks_cube_solver/src/solve/solve_view.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({
    super.key,
  });

  static const routeName = '/examples';

  @override
  State<ExampleView> createState() => _ExampleView();
}

class _ExampleView extends State<ExampleView> {
  final ExampleController exampleController = ExampleController();
  final RubikCubeController rubikCubeController = RubikCubeController();

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return RubikScaffold(
      title: locale.examplePage,
      body: FutureBuilder(
        future: exampleController.loadExamples(locale),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var examples = List.from(snapshot.data as Iterable);
            return ListView.builder(
              itemCount: examples.length,
              itemBuilder: (context, index) {
                return exampleListTile(locale, index, examples[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget exampleListTile(
      AppLocalizations locale, int index, Map<String, dynamic> example) {
    var subtitle =
        '${locale.exampleSolution}: ${example['alg']}\n${locale.historicMovesQuantity}: ${example['moves']}';

    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RubikCubeView(solution: example)),
      ),
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: example['alg']));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locale.snackBarSolutionCopied)),
        );
      },
      leading: Text('(${index + 1})'),
      title: Text(
        example['name']!,
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
                    builder: (context) => SolveView(solve: example['alg']!)),
              );
            },
          ),
          _popupItem(
            locale.sendBluetooth,
            Icons.bluetooth,
            () {
              Navigator.pop(context);
              rubikCubeController.sendSolveViaBluettoth(locale, example['alg']);
            },
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
