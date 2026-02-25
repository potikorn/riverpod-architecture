import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod3_2026/features/products/presentation/models/product_ui_item.dart';

part 'product_dto.g.dart';

@JsonSerializable()
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

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
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
