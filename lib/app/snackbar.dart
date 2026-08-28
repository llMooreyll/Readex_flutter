import 'package:flutter/material.dart';

import 'haptics.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
showAutoDismissSnackBar(
  BuildContext context, {
  required String message,
  SnackBarAction? action,
  Duration duration = const Duration(seconds: 4),
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  final controller = messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
      action: action == null
          ? null
          : SnackBarAction(
              label: action.label,
              onPressed: () {
                Haptics.selection();
                action.onPressed();
              },
            ),
    ),
  );
  return controller;
}
