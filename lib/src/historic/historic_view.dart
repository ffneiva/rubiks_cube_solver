import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';

class HistoricView extends StatelessWidget {
  final SettingsController settingsController;
  final RubikCubeController rubikCubeController;

  const HistoricView({
    super.key,
    required this.settingsController,
    required this.rubikCubeController,
  });

  static const routeName = '/historic';

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return RubikScaffold(
      settingsController: settingsController,
      rubikCubeController: rubikCubeController,
      title: locale.historicPage,
      body: Center(child: Text(locale.historicPage)),
    );
  }
}
