import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'haptics.dart';
import 'theme_controller.dart';

final class ThemeModeMenu extends ConsumerWidget {
  const ThemeModeMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == ThemeMode.dark;
    return IconButton(
      tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
      onPressed: () {
        Haptics.light();
        ref
            .read(themeModeProvider.notifier)
            .setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
      },
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
    );
  }
}
