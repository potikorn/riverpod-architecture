import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod3_2026/features/home/presentation/home_screen.dart';
import 'package:riverpod3_2026/features/settings/settings_screen.dart';

class MainView extends HookConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);

    final pages = [
      const HomeScreen(),
      const SettingsView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex.value,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.value,
        onTap: (index) => currentIndex.value = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
