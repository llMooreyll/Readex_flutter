import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'theme_mode';

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>(
  (ref) {
    return ThemeModeController();
  },
);

final class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.system) {
    unawaited(_load());
  }

  ThemeMode get currentMode => state;

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_themeModeKey, mode.name);
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_themeModeKey);
    if (saved == null) {
      return;
    }

    final mode = ThemeMode.values.where((value) => value.name == saved);
    if (mode.isNotEmpty) {
      state = mode.first;
    }
  }
}
