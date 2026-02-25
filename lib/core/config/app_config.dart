import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_config.g.dart';

enum AppFlavor { dev, prod }

class AppConfig {
  final AppFlavor appFlavor;
  final String baseUrl;
  final String apiKey;

  const AppConfig({
    required this.appFlavor,
    required this.baseUrl,
    required this.apiKey,
  });
}

@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) {
  throw UnimplementedError(
    'must override with AppConfig before running main app',
  );
}
