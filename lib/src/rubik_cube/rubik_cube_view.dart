import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/components/rubik_cube_projection.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';
import '../settings/settings_view.dart';

class RubikCubeView extends StatefulWidget {
  final SettingsController settingsController;
  final RubikCubeController rubikCubeController;

  const RubikCubeView({
    Key? key,
    required this.settingsController,
    required this.rubikCubeController,
  }) : super(key: key);

  static const routeName = '/';

  @override
  // ignore: library_private_types_in_public_api
  _RubikCubeView createState() => _RubikCubeView();
}

class _RubikCubeView extends State<RubikCubeView> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return RubikScaffold(
      title: locale.appTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RubikCubeProjection(
              settingsController: widget.settingsController,
              rubikCubeController: widget.rubikCubeController,
            ),
          ),
          GestureDetector(
            onTap: () =>
                widget.rubikCubeController.solve(widget.settingsController),
            child: Container(
              height: 80,
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              color: Colors.teal,
              child: Text(
                locale.solve,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
