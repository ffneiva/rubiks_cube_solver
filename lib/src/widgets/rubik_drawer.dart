import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/historic/historic_view.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_view.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';
import 'package:rubiks_cube_solver/src/settings/settings_view.dart';

class RubikDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;
  final SettingsController settingsController;
  final RubikCubeController rubikCubeController;

  const RubikDrawer({
    Key? key,
    required this.scaffoldState,
    required this.settingsController,
    required this.rubikCubeController,
  }) : super(key: key);

  static const routeName = '/';

  @override
  // ignore: library_private_types_in_public_api
  _RubikDrawer createState() => _RubikDrawer();
}

class _RubikDrawer extends State<RubikDrawer> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return Drawer(
      child: ListView(
        children: [
          _drawerHeader(locale),
          _listTileItem(
            Icons.extension,
            locale.rubikPage,
            RubikCubeView(
              settingsController: widget.settingsController,
              rubikCubeController: widget.rubikCubeController,
            ),
          ),
          _listTileItem(
            Icons.history,
            locale.historicPage,
            HistoricView(
              settingsController: widget.settingsController,
              rubikCubeController: widget.rubikCubeController,
            ),
          ),
          _listTileItem(
            Icons.settings,
            locale.settingsPage,
            SettingsView(
              settingsController: widget.settingsController,
              rubikCubeController: widget.rubikCubeController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerHeader(AppLocalizations locale) {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.teal),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 40,
            child: Image.asset('assets/images/logo.png', height: 80),
          ),
          const SizedBox(height: 8),
          Text(
            locale.appTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _listTileItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
