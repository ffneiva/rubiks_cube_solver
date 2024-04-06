import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/components/rubik_cube_entire_projection.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/components/rubik_cube_projection.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';

class RubikCubeView extends StatefulWidget {
  final Map<String, dynamic>? solution;

  const RubikCubeView({
    Key? key,
    this.solution,
  }) : super(key: key);

  static const routeName = '/';

  @override
  // ignore: library_private_types_in_public_api
  _RubikCubeView createState() => _RubikCubeView();
}

class _RubikCubeView extends State<RubikCubeView> {
  final RubikCubeController rubikCubeController = RubikCubeController();
  late bool entireProjection;

  @override
  void initState() {
    super.initState();
    entireProjection = true;
    if (widget.solution != null) {
      rubikCubeController.notation2colors(widget.solution!['scramble']);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return RubikScaffold(
      title: locale.appTitle,
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          offset: const Offset(0, 50),
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              _popupItem(
                locale.rubikCubeClearColors,
                Icons.delete,
                rubikCubeController.clearColors,
              ),
              _popupItem(
                entireProjection
                    ? locale.rubikCubeFaces
                    : locale.rubikCubeProjection,
                entireProjection
                    ? Icons.zoom_out_map_outlined
                    : Icons.zoom_in_map_outlined,
                () {
                  entireProjection = !entireProjection;
                  setState(() {});
                },
              ),
            ];
          },
        ),
      ],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: entireProjection
                  ? RubikCubeEntireProjection(
                      rubikCubeController: rubikCubeController)
                  : RubikCubeProjection(
                      rubikCubeController: rubikCubeController),
            ),
          ),
          GestureDetector(
            onTap: () => _solve(locale),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
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

  void _solve(AppLocalizations locale) async {
    Map<String, String> message = await rubikCubeController.solve(locale);
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
          content: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: message['solve']!));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(locale.snackBarSolutionCopied)),
              );
            },
            child: Text(
              message['solve']!,
              style: const TextStyle(fontSize: 16),
            ),
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
