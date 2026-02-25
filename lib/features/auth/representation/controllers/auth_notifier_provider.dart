import 'package:riverpod3_2026/core/storage/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier_provider.g.dart';

class User {
  final String id;
  final String name;
  final String token;
  User({required this.id, required this.name, required this.token});
}

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<User?> build() async {
    final storage = ref.read(sharedPrefsProvider);
    await Future.delayed(const Duration(milliseconds: 2000));
    final token = storage.getString("token");

    if (token == null) {
      return null; // ไม่มี Token = ยังไม่ล็อกอิน (State จะกลายเป็น AsyncData(null))
    }

    // TODO: โหลดข้อมูล user จาก token ที่เก็บไว้
    // ตัวอย่าง: final user = await _api.getUserFromToken(token);
    // return user;

    return User(id: "0", name: "John Doe", token: token);
  }

  Future<void> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (username != "john" || password != "123456") {
      throw Exception("Invalid username or password");
    }
    final storage = ref.read(sharedPrefsProvider);
    storage.setString("token", "token");
    state = AsyncData(User(id: "0", name: "John Doe", token: "token"));
  }

  Future<void> logout() async {
    final storage = ref.read(sharedPrefsProvider);
    storage.remove("token");
    state = const AsyncData(null);
  }
}
