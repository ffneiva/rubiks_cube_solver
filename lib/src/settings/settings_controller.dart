import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'settings_service.dart';

class SettingsController with ChangeNotifier {
  static final SettingsController _instance =
      SettingsController._internal(SettingsService());

  factory SettingsController() => _instance;

  SettingsController._internal(this._settingsService);

  late RubikCubeController _rubikCubeController;
  final SettingsService _settingsService;

  late ThemeMode _themeMode;
  late String _language;
  late AppLocalizations _languageMode;
  late List<Color> _colors;
  late BluetoothDevice? _blueDevice;
  late List<BluetoothService>? _blueServices;
  late BluetoothCharacteristic? _blueCharacteristic;
  late List<String> _blueChars;
  late List<String> _blueCharOptions;

  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  AppLocalizations get languageMode => _languageMode;
  List<Color> get colors => _colors;
  BluetoothDevice? get blueDevice => _blueDevice;
  List<String> get blueChars => _blueChars;
  List<BluetoothService>? get blueServices => _blueServices;
  BluetoothCharacteristic? get blueCharacteristic => _blueCharacteristic;
  List<String> get blueCharOptions => _blueCharOptions;

  void setRubikCubeController(RubikCubeController controller) {
    _rubikCubeController = controller;
  }

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _language = await _settingsService.language();
    _languageMode = await AppLocalizations.delegate.load(Locale(_language));
    _colors = await _settingsService.colors();

    _blueChars = await _settingsService.blueChars();
    _blueDevice = _settingsService.bluetoothDevice();
    _blueCharacteristic = _settingsService.blueCharacteristic();
    _blueCharOptions = _settingsService.blueCharOptions();

    updateBlueCharOptions();

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

    await _settingsService.updateLanguageMode(_language);
  }

  Future<void> updateColors(Color? newColor, int index) async {
    if (newColor == null) return;
    if (_colors.contains(newColor)) return;

    _colors[index] = newColor;

    _rubikCubeController.clearColors();

    notifyListeners();

    await _settingsService.updateColors(_colors);
  }

  Future<void> updateBlueDevice(BluetoothDevice? device) async {
    if (device == null) return;
    if (_blueDevice == device) return;

    _blueDevice = device;
    _blueServices = await _blueDevice!.discoverServices();

    _blueServices?.forEach((s) {
      if (s.characteristics.isNotEmpty) {
        for (int i = 0; i < s.characteristics.length; i++) {
          if (s.characteristics[i].properties.write) {
            _blueCharacteristic = s.characteristics[i];
          }
        }
      }
    });

    notifyListeners();

    await _settingsService.updateBlueDevice(_blueDevice);
  }

  Future<void> updateBlueChars(String? newChar, int index) async {
    if (newChar == null) return;
    if (_blueChars.contains(newChar)) return;

    _blueChars[index] = newChar;
    updateBlueCharOptions();

    notifyListeners();

    await _settingsService.updateBlueChars(_blueChars);
  }

  Future<void> updateBlueCharOptions() async {
    _blueCharOptions = _settingsService.blueCharOptions();
    _blueCharOptions =
        _blueCharOptions.where((c) => !_blueChars.contains(c)).toList();
  }

  Future<void> scanDevices(List<BluetoothDevice> devices) async {
    try {
      var subscription = FlutterBluePlus.onScanResults.listen((results) {
        for (ScanResult result in results) {
          if (!devices.contains(result.device)) {
            devices.add(result.device);
          }
        }
      });
      FlutterBluePlus.cancelWhenScanComplete(subscription);
    } catch (e) {}
  }

  Future<void> connectToDevice(
      BluetoothDevice? device, BluetoothDevice? selectedDevice) async {
    if (device == null) {
      return;
    }
    try {
      if (selectedDevice != null) {
        await selectedDevice.disconnect();
      }

      await device.connect();

      selectedDevice = device;
    } catch (e) {}
  }

  void requestBluetoothPermission(devices) async {
    PermissionStatus bluetoothStatus = await Permission.bluetoothScan.request();
    PermissionStatus locationStatus = await Permission.location.request();

    if (bluetoothStatus.isGranted && locationStatus.isGranted) {
      scanDevices(devices);
    }
  }

  void startBluetooth() async {
    var subscription = FlutterBluePlus.adapterState
        .listen((BluetoothAdapterState state) async {
      if (state == BluetoothAdapterState.off) {
        await FlutterBluePlus.turnOn();
      }
    });
    subscription.cancel();
  }

  Future<void> deviceConnect(
      BluetoothDevice device, BluetoothDevice? selectedDevice) async {
    try {
      await device.connect();
      await updateBlueDevice(device);
      selectedDevice = device;
    } catch (e) {}
  }
}
