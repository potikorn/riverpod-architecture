sealed class ProductUiItem {}

class NormalProductUiItem extends ProductUiItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  NormalProductUiItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });
}

class LoadingMoreItem extends ProductUiItem {}

class ErrorMoreItem extends ProductUiItem {
  final String error;
  ErrorMoreItem(this.error);
}
