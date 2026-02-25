import 'package:riverpod3_2026/features/products/data/dto/product_dto.dart';
import 'package:riverpod3_2026/features/products/data/repositories/product_repository.dart';
import 'package:riverpod3_2026/features/products/presentation/models/product_ui_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_notifier_provider.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  int _page = 1;
  bool _hasMore = true;

  @override
  FutureOr<List<ProductUiItem>> build() async {
    _page = 1;
    _hasMore = true;
    return _fetchProducts(_page);
  }

  Future<List<ProductUiItem>> _fetchProducts(int page) async {
    final repository = ref.read(productRepositoryProvider);
    final dtos = await repository.getProducts(skip: (page - 1) * 10, limit: 10);
    if (page == 5) {
      return [];
    }
    return dtos.products?.map((dto) => dto.toUiItem()).toList() ?? [];
  }

  Future<void> loadMore() async {
    final currentList = state.value ?? [];

    if (!_hasMore || (currentList.isNotEmpty && currentList.last is LoadingMoreItem)) {
      return;
    }

    state = AsyncData([...currentList, LoadingMoreItem()]);

    try {
      // 2. ยิง API ขอข้อมูลหน้าถัดไป
      final newItems = await _fetchProducts(_page + 1);

      _page++; // ขยับหน้า
      _hasMore = newItems.isNotEmpty; // ถ้า API ส่งมาว่างเปล่า แปลว่าของหมดแล้ว

      // 3. เอา LoadingMoreItem ออก และเอาของใหม่มาต่อท้ายแทน
      state = AsyncData([
        ...currentList, // ของเก่า (เอา LoadingMoreItem ออกไปแล้ว)
        ...newItems,    // ของใหม่
      ]);

    } catch (e) {
      // 4. ถ้า API พัง เปลี่ยนวงกลมหมุนๆ เป็นไอเทมแจ้งเตือน Error
      state = AsyncData([
        ...currentList,
        ErrorMoreItem('โหลดข้อมูลไม่สำเร็จ แตะเพื่อลองใหม่'),
      ]);
    }
  }
}