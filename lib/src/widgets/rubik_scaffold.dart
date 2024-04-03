import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/historic/historic_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_drawer.dart';

class RubikScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Function? onBack;

  const RubikScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.onBack,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RubikScaffoldState createState() => _RubikScaffoldState();
}

class _RubikScaffoldState extends State<RubikScaffold> {
  late final GlobalKey<ScaffoldState> _scaffoldState;
  final SettingsController settingsController = SettingsController();
  final RubikCubeController rubikCubeController = RubikCubeController();
  final HistoricController historicController = HistoricController();

  @override
  void initState() {
    super.initState();
    _scaffoldState = GlobalKey<ScaffoldState>();
    BackButtonInterceptor.add(_onWillPop);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_onWillPop);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: FittedBox(fit: BoxFit.scaleDown, child: Text(widget.title)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: widget.actions,
      ),
      drawer: RubikDrawer(scaffoldState: _scaffoldState),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );
  }

  bool _onWillPop(bool stopDefaultButtonEvent, RouteInfo info) {
    if (!Navigator.of(context).canPop()) {
      _showBackDialog(context);
    }
    return false;
  }

  Future<void> _showBackDialog(BuildContext context) async {
    AppLocalizations locale = AppLocalizations.of(context)!;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(locale.confirmExit),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                locale.backButton,
                style: const TextStyle(color: Colors.teal),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pop(context);
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
