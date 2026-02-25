import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod3_2026/core/presentation/controllers/locale_controller.dart';
import 'package:riverpod3_2026/features/auth/representation/controllers/login_controller_provider.dart';
import 'package:riverpod3_2026/features/auth/representation/models/login_form_state.dart';

class LogicScreen extends ConsumerWidget {
  const LogicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(loginControllerProvider);
    final formController = ref.read(loginControllerProvider.notifier);
    final t = ref.watch(translationsProvider);

    ref.listen(loginControllerProvider.select((s) => s.submitState), (
      prev,
      next,
    ) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.login.fail)));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: .all(24.0),
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: formState.username.initialValue,
                onChanged: formController.onUsernameChanged,
                decoration: InputDecoration(
                  labelText: t.login.username,
                  errorText: formState.usernameError?.translate(t),
                ),
              ),
              TextFormField(
                initialValue: formState.password.initialValue,
                onChanged: formController.onPasswordChanged,
                obscureText: !formState.isPasswordVisible, // ซ่อน/โชว์ รหัสผ่าน
                decoration: InputDecoration(
                  labelText: t.login.password,
                  errorText: formState.passwordError?.translate(t),
                  suffixIcon: IconButton(
                    icon: Icon(
                      formState.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: formController.togglePasswordVisibility,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: formState.submitState.isLoading
                    ? null
                    : formController.submit,
                child: formState.submitState.isLoading
                    ? const CircularProgressIndicator()
                    : Text(t.login.login_button),
              ),
              if (formState.isFormDirty)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    '⚠️ ฟอร์มมีการเปลี่ยนแปลงแต่ยังไม่ได้บันทึก',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
