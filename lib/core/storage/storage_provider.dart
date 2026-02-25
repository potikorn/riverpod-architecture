import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPrefs(Ref ref) {
  throw UnimplementedError('อย่าลืม override sharedPrefsProvider ใน main.dart นะ!');
}
