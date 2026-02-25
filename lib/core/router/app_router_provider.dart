import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod3_2026/features/auth/representation/controllers/auth_notifier_provider.dart';
import 'package:riverpod3_2026/features/auth/representation/screens/login_screen.dart';
import 'package:riverpod3_2026/core/presentation/main_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router_provider.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: "/splash",
    redirect: (context, state) {
      final path = state.uri.path;

      // 🛑 เคสที่ 1: ดักจับตอนที่ Auth ยังโหลดไม่เสร็จ (กำลังเช็ค Token)
      if (authState.isLoading) {
        // ถ้ายังไม่ได้อยู่หน้า splash ก็ให้ไปหน้า splash ซะ
        return path == '/splash' ? null : '/splash';
      }

      // ถ้าหลุดมาถึงตรงนี้ แปลว่า authState เป็น AsyncData แล้ว (โหลดเสร็จแล้ว)
      // เราก็มาเช็คว่ามี User หรือเป็น null
      final isAuth = authState.value != null;
      final isGoingToSplash = path == '/splash';

      final authRoutes = ["/login", "/register"];
      final isGoingAuthRoute = authRoutes.contains(path);

      // 🛑 เคสที่ 2: ยังไม่ล็อกอิน
      if (!isAuth) {
        // ถ้ากำลังไปหน้า Login อยู่แล้ว ก็ปล่อยผ่าน
        // แต่ถ้ากำลังพยายามเข้าหน้าอื่น (เช่น home หรือ splash) ให้เตะไปหน้า Login
        if (isGoingAuthRoute) return null;
        return '/login';
      }

      // 🛑 เคสที่ 3: ล็อกอินแล้ว
      if (isAuth) {
        // ถ้าพยายามจะเข้าหน้า Login หรือค้างอยู่หน้า Splash ให้เตะไปหน้า Home ทันที
        if (isGoingAuthRoute || isGoingToSplash) return '/home';
      }

      // ถ้าเงื่อนไขถูกต้องหมดแล้ว ก็ปล่อยให้ไปหน้าที่ต้องการได้เลย
      return null;
    },
    routes: [
      GoRoute(
        path: "/splash",
        builder: (context, state) {
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Splash"),
                  CircularProgressIndicator.adaptive(),
                ],
              ),
            ),
          );
        },
      ),
      GoRoute(path: "/login", builder: (context, state) => LogicScreen()),
      GoRoute(path: '/home', builder: (context, state) => const MainView()),
    ],
  );
}
