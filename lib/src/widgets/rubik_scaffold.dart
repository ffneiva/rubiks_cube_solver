import 'package:flutter/material.dart';
import 'package:rubiks_cube_solver/src/rubik_cube/rubik_cube_controller.dart';
import 'package:rubiks_cube_solver/src/settings/settings_controller.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_drawer.dart';

class RubikScaffold extends StatefulWidget {
  final SettingsController settingsController;
  final RubikCubeController rubikCubeController;
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const RubikScaffold({
    Key? key,
    required this.settingsController,
    required this.rubikCubeController,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RubikScaffoldState createState() => _RubikScaffoldState();
}

class _RubikScaffoldState extends State<RubikScaffold> {
  late final GlobalKey<ScaffoldState> _scaffoldState;

  @override
  void initState() {
    super.initState();
    _scaffoldState = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontSize: 20)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: widget.actions,
      ),
      drawer: RubikDrawer(
        scaffoldState: _scaffoldState,
        settingsController: widget.settingsController,
        rubikCubeController: widget.rubikCubeController,
      ),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
