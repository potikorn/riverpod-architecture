import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod3_2026/features/home/presentation/controllers/home_notifier_provider.dart';
import 'package:riverpod3_2026/features/products/data/dto/product_dto.dart';
import 'package:riverpod3_2026/features/products/data/dto/responses/product_response.dart';
import 'package:riverpod3_2026/features/products/data/repositories/product_repository.dart';
import 'package:riverpod3_2026/features/products/presentation/models/product_ui_item.dart';
import 'package:test/test.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProviderContainer container;
  late ProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    container = ProviderContainer(
      overrides: [
        productRepositoryProvider.overrideWithValue(mockProductRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initializes: loading -> data(empty list)', () async {
    // arrange
    when(
      () => mockProductRepository.getProducts(),
    ).thenAnswer((_) async => ProductResponse(products: []));

    // act
    final initial = container.read(homeProvider);

    final result = await container.read(homeProvider.future);

    // assert
    expect(initial, isA<AsyncLoading<List<ProductUiItem>>>());
    expect(result, isEmpty);

    final stateAfter = container.read(homeProvider);
    expect(
      stateAfter,
      isA<AsyncData<List<ProductUiItem>>>().having(
        (s) => s.value,
        'value',
        isEmpty,
      ),
    );

    verify(() => mockProductRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });

  test('returns products when repository returns non-empty list', () async {
    // arrange
    final products = [
      ProductDto(id: 1, title: 'P1', description: 'D1', thumbnail: 'T1'),
    ];

    when(
      () => mockProductRepository.getProducts(),
    ).thenAnswer((_) async => ProductResponse(products: products));

    // act
    final result = await container.read(homeProvider.future);

    // assert
    expect(result, hasLength(1));
    expect(
      result.first,
      isA<NormalProductUiItem>()
          .having((p) => p.name, 'name', equals('P1'))
          .having((p) => p.description, "description", equals('D1')),
    );

    verify(() => mockProductRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });

  test('maps null products to empty list', () async {
    // arrange
    when(
      () => mockProductRepository.getProducts(),
    ).thenAnswer((_) async => ProductResponse(products: null));

    // act
    final result = await container.read(homeProvider.future);

    // assert
    expect(result, isEmpty);

    verify(() => mockProductRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockProductRepository);
  });

  test('captures error when repository throws', () async {
    // arrange
    when(
      () => mockProductRepository.getProducts(),
    ).thenAnswer((_) async => throw Exception('fail'));

    final states = <AsyncValue<List<ProductUiItem>>>[];
    final sub = container.listen<AsyncValue<List<ProductUiItem>>>(
      homeProvider,
      (prev, next) => states.add(next),
      fireImmediately: true,
    );

    // act
    container.read(homeProvider);

    // wait for error to be captured
    await Future.delayed(const Duration(milliseconds: 100));

    // assert
    expect(states, isNotEmpty);
    expect(states.first, isA<AsyncLoading<List<ProductUiItem>>>());

    // AsyncNotifier captures error in AsyncLoading state during initial load
    final lastState = states.last;
    expect(lastState, isA<AsyncLoading<List<ProductUiItem>>>());
    expect(lastState.hasError, isTrue);
    expect(lastState.error, isA<Exception>());

    verify(() => mockProductRepository.getProducts()).called(1);
    verifyNoMoreInteractions(mockProductRepository);
    sub.close();
  });
}
