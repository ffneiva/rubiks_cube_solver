import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rubiks_cube_solver/src/historic/historic_controller.dart';
import 'package:rubiks_cube_solver/src/historic/historic_view.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'rubik_cube/rubik_cube_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class RubikApp extends StatelessWidget {
  const RubikApp({
    super.key,
    required this.settingsController,
    required this.rubikCubeController,
    required this.historicController,
  });

  final SettingsController settingsController;
  final RubikCubeController rubikCubeController;
  final HistoricController historicController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
            Locale('en', ''),
            Locale('es', ''),
            Locale('fr', ''),
          ],
          locale: Locale(settingsController.language),
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey[200],
          ),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return const SettingsView();
                  case HistoricView.routeName:
                    return const HistoricView();
                  case RubikCubeView.routeName:
                  default:
                    return const RubikCubeView();
                }
              },
            );
          },
        );
      },
    );
  }
}
