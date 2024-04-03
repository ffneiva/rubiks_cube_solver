import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/example/examples_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_view.dart';
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
                var example = examples[index];
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
                  leading: Text('(${index + 1})'),
                  title: Text(
                    example['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(subtitle),
                );
              },
            );
          }
        },
      ),
    );
  }
}
