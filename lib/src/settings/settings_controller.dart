import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  late ThemeMode _themeMode;
  late String _language;
  late AppLocalizations _languageMode;

  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  AppLocalizations get languageMode => _languageMode;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _language = _settingsService.language();
    _languageMode = await AppLocalizations.delegate.load(Locale(_language));
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    notifyListeners();

    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> updateLanguageMode(String? newLanguage) async {
    if (newLanguage == null) return;
    if (newLanguage == _language) return;

    _language = newLanguage;
    _languageMode = await AppLocalizations.delegate.load(Locale(_language));

    notifyListeners();

    await _settingsService.updateLanguageMode(_languageMode);
  }
}
