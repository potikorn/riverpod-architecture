import 'package:flutter/material.dart';
import 'package:riverpod3_2026/core/storage/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  Future<ThemeMode> build() async {
    final storage = ref.read(sharedPrefsProvider);
    final currentTheme = storage.getString("theme_mode");
    if (currentTheme == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values.firstWhere((mode) => mode.name == currentTheme);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = AsyncValue.data(themeMode);
    final storage = ref.read(sharedPrefsProvider);
    storage.setString("theme_mode", themeMode.name);
  }
}
