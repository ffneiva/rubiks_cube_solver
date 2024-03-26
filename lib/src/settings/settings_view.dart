import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';
import 'settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return RubikScaffold(
      title: locale.settingsTitle,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5 - 16,
                  child: Text(locale.settingsTheme),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5 - 16,
                  child: DropdownButton<ThemeMode>(
                    value: controller.themeMode,
                    isExpanded: true,
                    onChanged: controller.updateThemeMode,
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(locale.settingsSystemTheme),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text(locale.settingsLightTheme),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text(locale.settingsDarkTheme),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5 - 16,
                  child: Text(locale.settingsLanguage),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5 - 16,
                  child: DropdownButton(
                    value: controller.language,
                    isExpanded: true,
                    onChanged: controller.updateLanguageMode,
                    items: [
                      DropdownMenuItem(
                        value: 'pt',
                        child: Row(
                          children: [
                            Flag.fromCode(FlagsCode.BR, height: 16, width: 24),
                            const SizedBox(width: 8),
                            Text(locale.settingsPortuguese),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Row(
                          children: [
                            Flag.fromCode(FlagsCode.US, height: 16, width: 24),
                            const SizedBox(width: 8),
                            Text(locale.settingsEnglish),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'es',
                        child: Row(
                          children: [
                            Flag.fromCode(FlagsCode.ES, height: 16, width: 24),
                            const SizedBox(width: 8),
                            Text(locale.settingsSpanish),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
