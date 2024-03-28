import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsService {
  String language() => 'pt';

  List<Color> colors() => [
        Colors.white,
        Colors.orange,
        Colors.green,
        Colors.red,
        Colors.blue,
        Colors.yellow,
      ];

  Future<ThemeMode> themeMode() async => ThemeMode.system;

  Future<void> updateThemeMode(ThemeMode theme) async {}

  Future<void> updateLanguageMode(AppLocalizations localization) async {}

  Future<void> updateColors(List<Color> colors) async {}
}
