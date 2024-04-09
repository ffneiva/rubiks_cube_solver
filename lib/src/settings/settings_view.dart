// ignore_for_file: deprecated_member_use
import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/settings';

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController settingsController = SettingsController();
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;

  @override
  void initState() {
    super.initState();
    selectedDevice = settingsController.blueDevice;
    settingsController.startBluetooth();
    settingsController.requestBluetoothPermission(devices);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return RubikScaffold(
      title: locale.settingsTitle,
      body: RefreshIndicator(
        onRefresh: () async {
          await settingsController.scanDevices(devices);
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _generalSettings(locale),
                const SizedBox(height: 20),
                _bluetoothSettings(locale, devices),
                const SizedBox(height: 20),
                _cubeSettings(locale),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _generalSettings(AppLocalizations locale) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            locale.generalSettings,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
      _configOption(
        context,
        locale.settingsTheme,
        DropdownButton<ThemeMode>(
          value: settingsController.themeMode,
          isExpanded: true,
          onChanged: (t) {
            settingsController.updateThemeMode(t);
            setState(() {});
          },
          items: [
            DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(locale.settingsSystemTheme)),
            DropdownMenuItem(
                value: ThemeMode.light, child: Text(locale.settingsLightTheme)),
            DropdownMenuItem(
                value: ThemeMode.dark, child: Text(locale.settingsDarkTheme)),
          ],
        ),
      ),
      _configOption(
        context,
        locale.settingsLanguage,
        DropdownButton(
          value: settingsController.language,
          isExpanded: true,
          onChanged: (l) {
            settingsController.updateLanguageMode(l);
            setState(() {});
          },
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
    ]);
  }

  Widget _bluetoothSettings(
      AppLocalizations locale, List<BluetoothDevice?> devices) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            locale.bluetoothSettings,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
      _configOption(
        context,
        locale.settingsDeviceConnect,
        DropdownButton<BluetoothDevice>(
          value: selectedDevice,
          isExpanded: true,
          onChanged: (d) async {
            await settingsController.connectToDevice(d, selectedDevice);
            await settingsController.updateBlueDevice(d);
            setState(() {});
          },
          items: devices.map((device) {
            return DropdownMenuItem<BluetoothDevice>(
              value: device!,
              child: Text(device.advName != ''
                  ? device.advName
                  : device.platformName != ''
                      ? device.platformName
                      : device.localName != ''
                          ? device.localName
                          : (device.name != ''
                              ? device.name
                              : device.remoteId.toString())),
              onTap: () async => await settingsController.deviceConnect(
                  device, selectedDevice),
            );
          }).toList(),
        ),
      ),
      _configOption(
        context,
        locale.settingsBluetoothFirstChar,
        DropdownButton<String>(
          value: settingsController.blueChars[0],
          isExpanded: true,
          onChanged: (c) {
            settingsController.updateBlueChars(c, 0);
            setState(() {});
          },
          items: [
            settingsController.blueChars[0],
            ...settingsController.blueCharOptions,
          ].map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
        ),
      ),
      _configOption(
        context,
        locale.settingsBluetoothMiddleChar,
        DropdownButton<String>(
          value: settingsController.blueChars[1],
          isExpanded: true,
          onChanged: (c) {
            settingsController.updateBlueChars(c, 1);
            setState(() {});
          },
          items: [
            settingsController.blueChars[1],
            ...settingsController.blueCharOptions,
          ].map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
        ),
      ),
      _configOption(
        context,
        locale.settingsBluetoothLastChar,
        DropdownButton<String>(
          value: settingsController.blueChars[2],
          isExpanded: true,
          onChanged: (c) {
            settingsController.updateBlueChars(c, 2);
            setState(() {});
          },
          items: [
            settingsController.blueChars[2],
            ...settingsController.blueCharOptions,
          ].map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
        ),
      ),
    ]);
  }

  Widget _cubeSettings(AppLocalizations locale) {
    List<String> colorPositions = [
      locale.settingsUpColor,
      locale.settingsLeftColor,
      locale.settingsFrontColor,
      locale.settingsRightColor,
      locale.settingsBackColor,
      locale.settingsDownColor,
    ];

    List<Widget> colorWidgets = [];
    for (int i = 0; i < settingsController.colors.length; i++) {
      colorWidgets.add(_configOption(
        context,
        colorPositions[i],
        GestureDetector(
          onTap: () => _colorPicker(context, locale, i),
          child: Container(
            height: 25,
            decoration: BoxDecoration(
              color: settingsController.colors[i],
              border: Border.all(color: Colors.black),
            ),
          ),
        ),
      ));
    }

    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            locale.cubeSettings,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
      ...colorWidgets,
    ]);
  }

  void _colorPicker(BuildContext context, AppLocalizations locale, int index) {
    Color previousColor = settingsController.colors[index]; // Cor anterior

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(locale.settingsPickColor),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: previousColor,
              onColorChanged: (c) {
                settingsController.updateColors(c, index);
                setState(() {});
              },
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
                settingsController.updateColors(previousColor, index);
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
      height: 40,
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
