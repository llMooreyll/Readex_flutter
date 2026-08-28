// dynamic_color 2.1.0 currently exposes Android's palette as CorePalette.
// Keep this compatibility type at the platform integration boundary.
// ignore_for_file: deprecated_member_use

import 'package:dynamic_color/dynamic_color.dart' show DynamicColorPlugin;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_color_utilities/material_color_utilities.dart' as mcu;

import 'app_router.dart';
import 'app_theme.dart';
import 'shared_link_listener.dart';
import 'theme_controller.dart';

final class ReadItLaterApp extends ConsumerStatefulWidget {
  const ReadItLaterApp({super.key});

  @override
  ConsumerState<ReadItLaterApp> createState() => _ReadItLaterAppState();
}

final class _ReadItLaterAppState extends ConsumerState<ReadItLaterApp> {
  late final Future<mcu.CorePalette?> _dynamicPaletteFuture =
      DynamicColorPlugin.getCorePalette();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<mcu.CorePalette?>(
      future: _dynamicPaletteFuture,
      builder: (context, snapshot) {
        final palette = snapshot.data;
        return MaterialApp.router(
          title: 'Readex',
          theme: AppTheme.light(dynamicPalette: palette),
          darkTheme: AppTheme.dark(dynamicPalette: palette),
          themeMode: ref.watch(themeModeProvider),
          routerConfig: appRouter,
          builder: (context, child) =>
              SharedLinkListener(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
