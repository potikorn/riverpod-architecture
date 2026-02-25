// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HomeNotifier)
final homeProvider = HomeNotifierProvider._();

final class HomeNotifierProvider
    extends $AsyncNotifierProvider<HomeNotifier, List<ProductUiItem>> {
  HomeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeNotifierHash();

  @$internal
  @override
  HomeNotifier create() => HomeNotifier();
}

String _$homeNotifierHash() => r'00b1b8728089a2b2cdbfac66b22cd09f3915c34a';

abstract class _$HomeNotifier extends $AsyncNotifier<List<ProductUiItem>> {
  FutureOr<List<ProductUiItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ProductUiItem>>, List<ProductUiItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ProductUiItem>>, List<ProductUiItem>>,
              AsyncValue<List<ProductUiItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
