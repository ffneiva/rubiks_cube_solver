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
            onTap: () => _solve(locale),
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

  void _solve(AppLocalizations locale) async {
    Map<String, String> message = await widget.rubikCubeController.solve(
      widget.settingsController,
      locale,
    );
    if (message['error'] != null) {
      _errorMessage(locale, message['error']!);
    }
    if (message['solve'] != null) {
      _solveMessage(locale, message);
    }
  }

  void _errorMessage(AppLocalizations locale, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            const Icon(Icons.error_outline),
            const SizedBox(width: 10),
            Text(
              locale.error,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ]),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                locale.closeButton,
                style: const TextStyle(color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }

  void _solveMessage(AppLocalizations locale, Map<String, String> message) {
    String title = locale.messageSolve(message['moves']!, message['time']!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            message['solve']!,
            style: const TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                locale.closeButton,
                style: const TextStyle(color: Colors.teal),
              ),
            ),
          ],
        );
      },
    );
  }
}
