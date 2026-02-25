import 'package:riverpod3_2026/features/products/presentation/models/product_ui_item.dart';

class ProductDto {
  final int? id;
  final String? title;
  final String? description;
  final String? thumbnail;

  ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      thumbnail: json['thumbnail'] as String?,
    );
  }
}

extension ProductDtoX on ProductDto {
  ProductUiItem toUiItem() {
    return NormalProductUiItem(
      id: id.toString(),
      name: title ?? "",
      description: description ?? "",
      price: 0.0,
      imageUrl: thumbnail ?? "",
    );
  }
}
