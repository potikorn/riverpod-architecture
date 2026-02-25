import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod3_2026/core/presentation/controllers/locale_controller.dart';
import 'package:riverpod3_2026/core/router/app_router_provider.dart';
import 'package:riverpod3_2026/core/theme/app_theme.dart';
import 'package:riverpod3_2026/core/theme/theme_provider.dart';
import 'package:riverpod3_2026/i18n/strings.g.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeControllerProvider);
    final appRouter = ref.watch(appRouterProvider);
    final themeProvider = ref.watch(themeModeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeProvider.value ?? ThemeMode.system,
      locale: currentLocale.flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: appRouter,
    );
  }
}
