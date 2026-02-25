import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod3_2026/core/network/dio_provider.dart';
import 'package:riverpod3_2026/features/products/data/dto/responses/product_response.dart';
import 'package:riverpod3_2026/features/products/data/repositories/product_repository.dart';
import 'package:test/test.dart';

class MockDioHttpClient extends Mock implements Dio {}

void main() {
  late ProviderContainer container;
  late Dio mockDio;

  setUp(() {
    mockDio = MockDioHttpClient();
    container = ProviderContainer(
      overrides: [dioProvider.overrideWithValue(mockDio)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('should fetch products successfully', () async {
    // arrange
    when(() => mockDio.get(
          any(that: contains("/products")),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response(
        data: {
          "products": [
            {"id": 1, "title": "Product 1", "description": "Description 1"},
          ],
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    // act
    final productRepository = container.read(productRepositoryProvider);
    final productResponse = await productRepository.getProducts();

    // assert
    expect(productRepository, isA<ProductRepository>());
    expect(
      productResponse,
      isA<ProductResponse>()
          .having((p) => p.products, 'products', isNotNull)
          .having((p) => p.products?.length, 'products length', equals(1)),
    );
  });
}
