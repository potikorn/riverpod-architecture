import 'package:riverpod3_2026/features/products/data/dto/product_dto.dart';

class ProductResponse {
  final List<ProductDto>? products;

  ProductResponse({this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      products: json['products'] != null
          ? (json['products'] as List)
                .map(
                  (item) => ProductDto.fromJson(item as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }
}
