import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_it_later/app/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('persists the selected theme mode', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = ThemeModeController();

    await controller.setThemeMode(ThemeMode.dark);

    final restored = ThemeModeController();
    await Future<void>.delayed(Duration.zero);

    expect(restored.currentMode, ThemeMode.dark);
    controller.dispose();
    restored.dispose();
  });
}
