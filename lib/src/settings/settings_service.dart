import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:path_provider/path_provider.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();

  factory SettingsService() => _instance;

  SettingsService._internal();

  Future<String> language() async {
    String? userLanguage;
    String defaultLanguage = 'pt';

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/language.json');
    if (await file.exists()) {
      userLanguage = await file.readAsString();
    }

    return userLanguage ?? defaultLanguage;
  }

  Future<List<Color>> colors() async {
    List<Color>? userColors;
    List<Color> defaultColors = [
      Colors.white,
      Colors.orange,
      Colors.green,
      Colors.red,
      Colors.blue,
      Colors.yellow,
    ];

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/colors.json');
    if (await file.exists()) {
      List<dynamic> jsonList = jsonDecode(await file.readAsString());
      List<List<String>> colorStrings = jsonList
          .map((dynamic item) {
            return (item as List)
                .map((dynamic innerItem) => innerItem.toString())
                .toList();
          })
          .cast<List<String>>()
          .toList();
      userColors = colorStrings
          .map((c) => Color.fromARGB(
                int.parse(c[0]),
                int.parse(c[1]),
                int.parse(c[2]),
                int.parse(c[3]),
              ))
          .toList();
    }

    return userColors ?? defaultColors;
  }

  BluetoothDevice? bluetoothDevice() => null;

  Future<List<String>> blueChars() async {
    List<String>? userBlueChars;
    List<String> defaultBlueChars = ['\$', ' ', '+'];

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/blue_chars.json');
    if (await file.exists()) {
      List<dynamic> dynamicList = jsonDecode(await file.readAsString());
      userBlueChars =
          dynamicList.map((dynamic item) => item.toString()).toList();
    }

    return userBlueChars ?? defaultBlueChars;
  }

  BluetoothCharacteristic? blueCharacteristic() => null;

  List<String> blueCharOptions() =>
      ['\$', ' ', '+', '-', '_', '.', '@', '#', '%', '&', '*', '(', ')'];

  Future<ThemeMode> themeMode() async {
    String? themeName;
    ThemeMode? userTheme;
    ThemeMode defaultTheme = ThemeMode.system;

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/theme.json');
    if (await file.exists()) {
      themeName = await file.readAsString();
    }

    if (themeName != null) {
      userTheme = themeName == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }

    return userTheme ?? defaultTheme;
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/theme.json');
    await file.writeAsString(theme.toString().split('.').last);
  }

  Future<void> updateLanguageMode(String localization) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/language.json');
    await file.writeAsString(localization);
  }

  Future<void> updateColors(List<Color> colors) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/colors.json');

    List<List<String>> updatedColors = [];

    for (int i = 0; i < colors.length; i++) {
      updatedColors.add([
        colors[i].alpha.toString(),
        colors[i].red.toString(),
        colors[i].green.toString(),
        colors[i].blue.toString(),
      ]);
    }

    await file.writeAsString(updatedColors.toString());
  }

  Future<void> updateBlueDevice(BluetoothDevice? blueDevice) async {}

  Future<void> updateBlueChars(List<String> blueChars) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/blue_chars.json');
    await file.writeAsString(jsonEncode(blueChars));
  }
}
