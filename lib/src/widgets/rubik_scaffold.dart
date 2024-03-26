import 'package:flutter/material.dart';

class RubikScaffold extends StatefulWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const RubikScaffold({
    Key? key,
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
        title: Text(widget.title),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: widget.actions,
      ),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
