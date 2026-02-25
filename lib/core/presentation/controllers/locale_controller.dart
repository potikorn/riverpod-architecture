import 'package:flutter/widgets.dart';
import 'package:riverpod3_2026/i18n/strings.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale_controller.g.dart';

@riverpod
class LocaleController extends _$LocaleController with WidgetsBindingObserver {
  @override
  AppLocale build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() => WidgetsBinding.instance.removeObserver(this));
    final initialLocale = AppLocaleUtils.findDeviceLocale();
    LocaleSettings.setLocale(initialLocale);
    return initialLocale;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    final newDeviceLocale = AppLocaleUtils.findDeviceLocale();
    setLocale(newDeviceLocale);
  }

  void setLocale(AppLocale newLocale) {
    LocaleSettings.setLocale(newLocale);
    state = newLocale;
  }
}

@riverpod
Translations translations(Ref ref) {
  ref.watch(localeControllerProvider);
  return t;
}
