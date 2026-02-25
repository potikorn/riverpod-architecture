import 'package:riverpod3_2026/core/presentation/models/field_state.dart';
import 'package:riverpod3_2026/i18n/strings.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

enum LoginFieldError { invalidUsername, passwordTooShort }

extension LoginFieldErrorL10n on LoginFieldError {
  // โยนตัวแปลภาษา (t) เข้ามาให้มันเลือกคำตอบ
  String translate(Translations t) {
    return switch (this) {
      LoginFieldError.invalidUsername => t.common.required_field(
        field: t.login.username,
      ),
      LoginFieldError.passwordTooShort => t.login.password_min_length,
    };
  }
}

class LoginFormState {
  final FieldState<String> username;
  final FieldState<String> password;

  final bool isPasswordVisible; // จัดการตาปิด/ตาเปิดของรหัสผ่าน
  final bool hasAttemptedSubmit;

  final AsyncValue<void> submitState; // สถานะตอนกดปุ่ม Login (Loading/Error)

  const LoginFormState({
    this.username = const FieldState(value: '', initialValue: ''),
    this.password = const FieldState(value: '', initialValue: ''),
    this.isPasswordVisible = false,
    this.hasAttemptedSubmit = false,
    this.submitState = const AsyncData(null), // เริ่มต้นมาคือว่างเปล่า
  });

  // 🧠 Logic ตรวจสอบความถูกต้อง (UI จะได้ไม่ต้องเขียน if-else)
  bool get _isUserNameValid => username.value.isNotEmpty;
  bool get _isPasswordValid => password.value.length >= 6;
  bool get isValid => _isUserNameValid && _isPasswordValid;
  bool get isFormDirty => username.isDirty || password.isDirty;

  LoginFieldError? get usernameError {
    if (_isUserNameValid) return null;
    if (username.isTouched || hasAttemptedSubmit) {
      return LoginFieldError.invalidUsername;
    }
    return null; // เพิ่งเปิดหน้าจอมา อย่าเพิ่งด่า User!
  }

  LoginFieldError? get passwordError {
    if (_isPasswordValid) return null;
    if (password.isTouched || hasAttemptedSubmit) {
      return LoginFieldError.passwordTooShort;
    }
    return null;
  }

  // ฟังก์ชัน copyWith เอาไว้สร้าง State ใหม่เวลาพิมพ์ตัวอักษร
  LoginFormState copyWith({
    FieldState<String>? username,
    FieldState<String>? password,
    bool? isPasswordVisible,
    bool? hasAttemptedSubmit,
    AsyncValue<void>? submitState,
  }) {
    return LoginFormState(
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      hasAttemptedSubmit: hasAttemptedSubmit ?? this.hasAttemptedSubmit,
      submitState: submitState ?? this.submitState,
    );
  }
}
