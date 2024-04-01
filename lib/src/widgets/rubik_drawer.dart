import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/historic/historic_view.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_view.dart';
import 'package:rubiks_cube_solver/src/settings/settings_view.dart';
import 'package:rubiks_cube_solver/src/utils/functions.dart';
import 'package:url_launcher/url_launcher.dart';

class RubikDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const RubikDrawer({
    Key? key,
    required this.scaffoldState,
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
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _drawerHeader(locale),
                _listTileItem(
                    Icons.extension, locale.rubikPage, const RubikCubeView()),
                _listTileItem(
                    Icons.history, locale.historicPage, const HistoricView()),
                _listTileItem(
                    Icons.settings, locale.settingsPage, const SettingsView()),
              ],
            ),
          ),
          _copyright(),
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
            radius: 50,
            child: Image.asset('assets/images/logo.png'),
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
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _copyright() {
    return ListTile(
      title: Center(
        child: Text(getCopyright(), style: const TextStyle(fontSize: 12)),
      ),
      onTap: () => launchUrl(Uri.parse(getCopyrightLink())),
    );
  }
}
