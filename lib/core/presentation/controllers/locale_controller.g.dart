// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocaleController)
final localeControllerProvider = LocaleControllerProvider._();

final class LocaleControllerProvider
    extends $NotifierProvider<LocaleController, AppLocale> {
  LocaleControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeControllerHash();

  @$internal
  @override
  LocaleController create() => LocaleController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLocale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLocale>(value),
    );
  }
}

String _$localeControllerHash() => r'f14fb9b46941c17a3b862d2aad6f9d47e7f4dca8';

abstract class _$LocaleController extends $Notifier<AppLocale> {
  AppLocale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppLocale, AppLocale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLocale, AppLocale>,
              AppLocale,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(translations)
final translationsProvider = TranslationsProvider._();

final class TranslationsProvider
    extends $FunctionalProvider<Translations, Translations, Translations>
    with $Provider<Translations> {
  TranslationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'translationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$translationsHash();

  @$internal
  @override
  $ProviderElement<Translations> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Translations create(Ref ref) {
    return translations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Translations value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Translations>(value),
    );
  }
}

String _$translationsHash() => r'a890c9286342e8b00a8a699a938b03adc27bd998';
