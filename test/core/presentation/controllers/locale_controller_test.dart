import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod3_2026/core/presentation/controllers/locale_controller.dart';
import 'package:riverpod3_2026/i18n/strings.g.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocaleController', () {
    late ProviderContainer container;

    setUp(() {
      LocaleSettings.setLocaleSync(AppLocale.en);
    });

    tearDown(() {
      container.dispose();
    });

    test('build initializes with device locale', () {
      container = ProviderContainer();

      final result = container.read(localeControllerProvider);

      expect(result, isA<AppLocale>());
      expect(AppLocale.values.contains(result), isTrue);
    });

    test('setLocale updates state to th', () {
      container = ProviderContainer();
      container.read(localeControllerProvider);

      final controller = container.read(localeControllerProvider.notifier);

      controller.setLocale(AppLocale.th);

      expect(container.read(localeControllerProvider), AppLocale.th);
    });

    test('setLocale updates state to en', () {
      container = ProviderContainer();
      container.read(localeControllerProvider);

      final controller = container.read(localeControllerProvider.notifier);

      controller.setLocale(AppLocale.en);

      expect(container.read(localeControllerProvider), AppLocale.en);
    });

    test('state changes can be listened to', () {
      container = ProviderContainer();
      final states = <AppLocale?>[];

      final sub = container.listen<AppLocale>(
        localeControllerProvider,
        (prev, next) => states.add(next),
        fireImmediately: true,
      );

      final controller = container.read(localeControllerProvider.notifier);
      controller.setLocale(AppLocale.th);
      controller.setLocale(AppLocale.en);

      expect(states.length, 3);
      expect(states[1], AppLocale.th);
      expect(states[2], AppLocale.en);

      sub.close();
    });
  });

  group('translationsProvider', () {
    late ProviderContainer container;

    setUp(() {
      LocaleSettings.setLocaleSync(AppLocale.en);
    });

    tearDown(() {
      container.dispose();
    });

    test('returns current translations', () {
      container = ProviderContainer();

      final translations = container.read(translationsProvider);

      expect(translations, isA<Translations>());
    });

    test('updates when locale changes', () {
      container = ProviderContainer();
      container.read(localeControllerProvider);

      final controller = container.read(localeControllerProvider.notifier);

      controller.setLocale(AppLocale.th);
      final thTranslations = container.read(translationsProvider);
      expect(thTranslations, isA<Translations>());

      controller.setLocale(AppLocale.en);
      final enTranslations = container.read(translationsProvider);
      expect(enTranslations, isA<Translations>());
    });
  });
}
