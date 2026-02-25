import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod3_2026/core/theme/theme_provider.dart';
import 'package:riverpod3_2026/features/auth/representation/controllers/auth_notifier_provider.dart';

class SettingsView extends HookConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Theme", style: theme.textTheme.titleMedium),
                  RadioGroup<ThemeMode>(
                    groupValue: themeMode.value,
                    onChanged: (value) {
                      if (value == null) return;
                      ref.read(themeModeProvider.notifier).setThemeMode(value);
                    },
                    child: Column(
                      children: [
                        RadioListTile(
                          value: ThemeMode.system,
                          title: const Text("System"),
                        ),
                        RadioListTile(
                          value: ThemeMode.light,
                          title: const Text("Light"),
                        ),
                        RadioListTile(
                          value: ThemeMode.dark,
                          title: const Text("Dark"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => ref.read(authProvider.notifier).logout(),
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
