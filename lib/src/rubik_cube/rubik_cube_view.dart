import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../settings/settings_view.dart';

class RubikCubeView extends StatefulWidget {
  const RubikCubeView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  // ignore: library_private_types_in_public_api
  _RubikCubeView createState() => _RubikCubeView();
}

class _RubikCubeView extends State<RubikCubeView>
    with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _cube;

  @override
  void initState() {
    super.initState();
    gyroscopeEventStream().listen((GyroscopeEvent event) {
      setState(() {
        if (_cube != null) {
          _cube!.rotation.x += event.y;
          _cube!.rotation.y -= event.x;
          _cube!.rotation.z += event.z;
          _cube!.updateTransform();
          _scene.update();
        }
      });
    });
  }

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    scene.camera.position.z = 20;
    scene.camera.target.y = 2;
    _cube = Object(
        scale: Vector3(10.0, 10.0, 10.0),
        backfaceCulling: false,
        fileName: 'assets/cube/Robik.obj');
    scene.world.add(_cube!);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    return RubikScaffold(
      title: locale.appTitle,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.restorablePushNamed(context, SettingsView.routeName);
          },
        ),
      ],
      body: Center(child: Cube(onSceneCreated: _onSceneCreated)),
    );
  }
}
