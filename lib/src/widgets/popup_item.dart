import 'package:flutter/material.dart';

PopupMenuItem popupItem(
    BuildContext context, String title, IconData icon, VoidCallback onTap) {
  return PopupMenuItem(
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      dense: true,
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
    ),
  );
}
