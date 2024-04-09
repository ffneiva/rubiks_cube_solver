import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/example/examples_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';
import 'package:rubiks_cube_solver/src/widgets/solution_list_tile.dart';

class ExampleView extends StatefulWidget {
  const ExampleView({
    super.key,
  });

  static const routeName = '/examples';

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
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
                var example = examples[index];
                return solutionListTile(context, locale, index, example, []);
              },
            );
          }
        },
      ),
    );
  }
}
