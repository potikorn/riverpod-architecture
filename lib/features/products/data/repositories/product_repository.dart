import 'dart:async';

import 'package:dio/dio.dart';
import 'package:riverpod3_2026/core/network/dio_provider.dart';
import 'package:riverpod3_2026/features/products/data/dto/responses/product_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_repository.g.dart';

abstract class ProductRepository {
  FutureOr<ProductResponse> getProducts({int skip = 0, int limit = 10});
}

class ProductRepositoryImpl implements ProductRepository {
  final Dio dio;

  ProductRepositoryImpl({required this.dio});

  @override
  FutureOr<ProductResponse> getProducts({int skip = 0, int limit = 10}) async {
    try {
      final result = await dio.get("/products", queryParameters: {
        "skip": skip,
        "limit": limit,
      });
      return ProductResponse.fromJson(result.data);
    } catch (e) {
      rethrow;
    }
  }
}

@riverpod
ProductRepository productRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ProductRepositoryImpl(dio: dio);
}
