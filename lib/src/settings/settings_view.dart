import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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

    List<String> colorPositions = [
      locale.settingsUpColor,
      locale.settingsLeftColor,
      locale.settingsFrontColor,
      locale.settingsRightColor,
      locale.settingsBackColor,
      locale.settingsDownColor,
    ];

    List<Widget> colorWidgets = [];
    for (int i = 0; i < controller.colors.length; i++) {
      colorWidgets.add(_configOption(
        context,
        colorPositions[i],
        GestureDetector(
          onTap: () => _colorPicker(context, locale, i),
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: controller.colors[i],
              border: Border.all(color: Colors.black),
            ),
          ),
        ),
      ));
    }

    return RubikScaffold(
      title: locale.settingsTitle,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.generalSettings,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          _configOption(
            context,
            locale.settingsTheme,
            DropdownButton<ThemeMode>(
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
          _configOption(
            context,
            locale.settingsLanguage,
            DropdownButton(
              value: controller.language,
              isExpanded: true,
              onChanged: (l) => controller.updateLanguageMode(l),
              items: [
                _dropdownMenuItemLocation(
                    'pt', FlagsCode.BR, locale.settingsPortuguese),
                _dropdownMenuItemLocation(
                    'en', FlagsCode.US, locale.settingsEnglish),
                _dropdownMenuItemLocation(
                    'es', FlagsCode.ES, locale.settingsSpanish),
                _dropdownMenuItemLocation(
                    'fr', FlagsCode.FR, locale.settingsFrench),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.cubeSettings,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          ...colorWidgets,
        ]),
      ),
    );
  }

  void _colorPicker(BuildContext context, AppLocalizations locale, int index) {
    Color previousColor = controller.colors[index]; // Cor anterior

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(locale.settingsPickColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: previousColor,
              onColorChanged: (Color newColor) =>
                  controller.updateColors(newColor, index),
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                locale.confirmButton,
                style: const TextStyle(color: Colors.teal),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.updateColors(previousColor, index);
                Navigator.of(context).pop();
              },
              child: Text(
                locale.backButton,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _configOption(BuildContext context, String title, Widget widget) {
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5 - 16,
            child: Text(title, style: const TextStyle(fontSize: 16)),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5 - 16,
            child: widget,
          ),
        ],
      ),
    );
  }

  DropdownMenuItem _dropdownMenuItemLocation(
      String value, FlagsCode flag, String description) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Flag.fromCode(flag, height: 16, width: 24),
          const SizedBox(width: 8),
          Text(description),
        ],
      ),
    );
  }
}
