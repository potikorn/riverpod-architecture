import 'package:riverpod3_2026/features/auth/representation/controllers/auth_notifier_provider.dart';
import 'package:riverpod3_2026/features/auth/representation/models/login_form_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller_provider.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  LoginFormState build() {
    return const LoginFormState();
  }

  // User พิมพ์ Email
  void onUsernameChanged(String value) {
    state = state.copyWith(
      username: state.username.copyWith(value: value, isTouched: true),
    );
  }

  // User พิมพ์ Password
  void onPasswordChanged(String value) {
    state = state.copyWith(
      password: state.password.copyWith(value: value, isTouched: true),
    );
  }

  // สลับการมองเห็นรหัสผ่าน
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  Future<void> submit() async {
    state = state.copyWith(hasAttemptedSubmit: true);

    if (!state.isValid) {
      return; // ถ้าข้อมูลผิด ให้หยุดทำงานแค่นี้เลย (UI จะแดงเถือกเอง)
    }

    // 1. ปรับสถานะเป็น Loading (ปุ่มจะหมุนติ้วๆ)
    state = state.copyWith(submitState: const AsyncLoading());

    // 2. ใช้ guard() ดักจับ Error และยิง API
    final result = await AsyncValue.guard(() async {
      // เรียกใช้ AuthNotifier ตัวท็อปที่เราเคยสร้างไว้
      await ref
          .read(authProvider.notifier)
          .login(state.username.value, state.password.value);
    });

    // 3. อัปเดตผลลัพธ์ (ถ้า Error จะโชว์ SnackBar, ถ้าผ่าน GoRouter จะเตะย้ายหน้าเอง)
    state = state.copyWith(submitState: result);
  }
}
