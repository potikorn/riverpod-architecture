import 'package:dio/dio.dart';
import 'package:riverpod3_2026/core/config/app_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final appConfig = ref.read(appConfigProvider);
  final dioOptions = BaseOptions(
    baseUrl: appConfig.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );
  final dio = Dio(dioOptions);
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add any global headers here
        return handler.next(options);
      },
    ),
  );
  if (appConfig.appFlavor == AppFlavor.dev) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
  return dio;
}
