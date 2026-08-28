import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'motion.dart';
import 'theme_controller.dart';

final class ThemeModeMenu extends ConsumerWidget {
  const ThemeModeMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return PopupMenuButton<ThemeMode>(
      tooltip: 'Theme',
      initialValue: mode,
      popUpAnimationStyle: AppMotion.popupMenu,
      onSelected: (value) =>
          ref.read(themeModeProvider.notifier).setThemeMode(value),
      itemBuilder: (context) => const [
        CheckedPopupMenuItem(
          value: ThemeMode.system,
          child: Text('System default'),
        ),
        CheckedPopupMenuItem(
          value: ThemeMode.light,
          child: Text('Light theme'),
        ),
        CheckedPopupMenuItem(value: ThemeMode.dark, child: Text('Dark theme')),
      ],
      icon: Icon(
        mode == ThemeMode.dark
            ? Icons.dark_mode_outlined
            : Icons.brightness_6_outlined,
      ),
    );
  }
}
