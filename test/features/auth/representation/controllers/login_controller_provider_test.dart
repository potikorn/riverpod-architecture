import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod3_2026/features/auth/representation/controllers/auth_notifier_provider.dart';
import 'package:riverpod3_2026/features/auth/representation/controllers/login_controller_provider.dart';

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier({this.shouldThrow = false});

  final bool shouldThrow;
  int loginCallCount = 0;
  String? lastUsername;
  String? lastPassword;

  @override
  FutureOr<User?> build() {
    return null;
  }

  @override
  Future<void> login(String username, String password) async {
    loginCallCount += 1;
    lastUsername = username;
    lastPassword = password;

    if (shouldThrow) {
      throw Exception('login failed');
    }
  }
}

void main() {
  group('LoginController', () {
    late ProviderContainer container;
    late LoginController controller;
    late _FakeAuthNotifier fakeAuth;

    setUp(() {
      fakeAuth = _FakeAuthNotifier();
      container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
        ],
      );
      controller = container.read(loginControllerProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('onUsernameChanged updates value and marks touched', () {
      controller.onUsernameChanged('test');

      expect(controller.state.username.value, 'test');
      expect(controller.state.username.isTouched, true);
    });

    test('onPasswordChanged updates value and marks touched', () {
      controller.onPasswordChanged('test');

      expect(controller.state.password.value, 'test');
      expect(controller.state.password.isTouched, true);
    });

    test('togglePasswordVisibility toggles boolean', () {
      expect(controller.state.isPasswordVisible, false);
      controller.togglePasswordVisibility();
      expect(controller.state.isPasswordVisible, true);
      controller.togglePasswordVisibility();
      expect(controller.state.isPasswordVisible, false);
    });

    test('submit marks hasAttemptedSubmit and does not call login if invalid',
        () async {
      expect(controller.state.isValid, false);

      await controller.submit();

      expect(controller.state.hasAttemptedSubmit, true);
      expect(controller.state.submitState, isA<AsyncData>());
      expect(controller.state.submitState.hasError, false);
      expect(controller.state.submitState.isLoading, false);
      expect(fakeAuth.loginCallCount, 0);
    });

    test('submit sets loading then calls authProvider.login and ends with data',
        () async {
      controller.onUsernameChanged('john');
      controller.onPasswordChanged('123456');
      expect(controller.state.isValid, true);

      final future = controller.submit();
      expect(controller.state.submitState, const AsyncLoading<void>());
      await future;

      expect(fakeAuth.loginCallCount, 1);
      expect(fakeAuth.lastUsername, 'john');
      expect(fakeAuth.lastPassword, '123456');
      expect(controller.state.submitState, isA<AsyncData>());
      expect(controller.state.submitState.hasError, false);
      expect(controller.state.submitState.isLoading, false);
    });

    test('submit ends with error when authProvider.login throws', () async {
      fakeAuth = _FakeAuthNotifier(shouldThrow: true);
      container.dispose();
      container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
        ],
      );
      controller = container.read(loginControllerProvider.notifier);

      controller.onUsernameChanged('john');
      controller.onPasswordChanged('123456');
      expect(controller.state.isValid, true);

      final future = controller.submit();
      expect(controller.state.submitState, const AsyncLoading<void>());
      await future;

      expect(fakeAuth.loginCallCount, 1);
      expect(controller.state.submitState.hasError, true);
    });
  });
}
