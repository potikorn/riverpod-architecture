import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod3_2026/core/presentation/app.dart';
import 'package:riverpod3_2026/core/config/app_config.dart';
import 'package:riverpod3_2026/core/storage/storage_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appConfig = AppConfig(
    appFlavor: AppFlavor.dev,
    baseUrl: 'https://dummyjson.com',
    apiKey: 'your_api_key',
  );

  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        appConfigProvider.overrideWithValue(appConfig),
      ],
      child: const MainApp(),
    ),
  );
}
