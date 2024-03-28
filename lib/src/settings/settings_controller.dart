import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  static final SettingsController _instance =
      SettingsController._internal(SettingsService());

  factory SettingsController() => _instance;

  SettingsController._internal(this._settingsService);

  final SettingsService _settingsService;

  late ThemeMode _themeMode;
  late String _language;
  late AppLocalizations _languageMode;
  late List<Color> _colors;

  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  AppLocalizations get languageMode => _languageMode;
  List<Color> get colors => _colors;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _language = _settingsService.language();
    _languageMode = await AppLocalizations.delegate.load(Locale(_language));
    _colors = _settingsService.colors();
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

  Future<void> updateColors(Color? newColor, int index) async {
    if (newColor == null) return;
    if (_colors.contains(newColor)) return;

    _colors[index] = newColor;

    notifyListeners();

    await _settingsService.updateColors(_colors);
  }
}
