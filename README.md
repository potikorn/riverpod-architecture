# Flutter Riverpod Lean Architecture

This project follows a **Feature-First** architecture with a focus on a **Lean Workflow**. We avoid the boilerplate of strict Clean Architecture (like having separate Domain layers, UseCases, or complex Mappers for every single API call) while maintaining pragmatic, clean, and testable code.

## Tech Stack
- **State Management & DI**: [Riverpod](https://riverpod.dev/) (with code generation)
- **Routing**: [go_router](https://pub.dev/packages/go_router)
- **Networking**: [dio](https://pub.dev/packages/dio)
- **JSON Serialization**: [json_serializable](https://pub.dev/packages/json_serializable) & [json_annotation](https://pub.dev/packages/json_annotation)
- **Local Storage**: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **Localization**: [slang](https://pub.dev/packages/slang)

## Project Structure

```
lib/
├── core/                      # 🛠️ Global app configurations & utilities
│   ├── config/                # Environment, AppConfig
│   ├── network/               # Dio setup, interceptors (dio_provider)
│   ├── presentation/          # Global UI components (e.g., App widget)
│   ├── router/                # GoRouter setup & guards
│   ├── storage/               # SharedPreferences setup
│   └── theme/                 # Global styles, colors, fonts
│
├── features/                  # 🚀 Feature-First modules
│   ├── auth/                  
│   ├── home/                  
│   └── products/              
│       ├── data/              # 📦 Data Layer (API, Repositories, DTOs)
│       │   ├── dto/           # Data Transfer Objects (API responses/requests)
│       │   └── repositories/  # Repository interfaces & implementations
│       │
│       └── presentation/      # 🎨 Presentation Layer (UI & State)
│           ├── controllers/   # Riverpod Notifiers (Business Logic)
│           ├── models/        # View models / UI states
│           └── screens/       # Flutter UI Widgets
│
└── i18n/                      # 🌍 Localization files (slang)
```

## Lean Development Guidelines

We focus on pragmatism. Do not over-engineer.

### 1. The Data & Domain Layer (Repositories & Use Cases)
- **JSON Serialization**: Always use `@JsonSerializable()` for your DTOs to generate `fromJson` and `toJson` methods automatically. This prevents manual mapping errors.
- **Default to Simple (No Use Cases)**: For straightforward CRUD operations or direct API fetches, Controllers (Notifiers) should interact with Repositories directly. Skip creating Use Cases to avoid unnecessary boilerplate.
- **When to add Use Cases**: If a specific user action involves **highly complex business logic**, orchestrates calls between multiple repositories, or requires heavy data transformation before hitting the UI, you may introduce a `domain/usecases/` folder inside the feature.
- **Merge Interface & Implementation**: To reduce file hopping, place the `abstract class Repository`, the `RepositoryImpl`, and its `@riverpod` provider in the **same file**.
- **DTOs vs Domain Models**: If the API response exactly matches what the UI needs, use the DTO directly. Only map DTOs to Domain models if the API structure is messy and UI needs a clean format.

**Example** (`product_dto.dart`):
```dart
import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  final int? id;
  final String? title;

  ProductDto({this.id, this.title});

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
```

**Example** (`product_repository.dart`):
```dart
abstract class ProductRepository {
  FutureOr<ProductResponse> getProducts({int skip = 0, int limit = 10});
}

class ProductRepositoryImpl implements ProductRepository {
  final Dio dio;
  ProductRepositoryImpl({required this.dio});

  @override
  FutureOr<ProductResponse> getProducts({int skip = 0, int limit = 10}) async {
    final result = await dio.get("/products");
    return ProductResponse.fromJson(result.data);
  }
}

@riverpod
ProductRepository productRepository(Ref ref) {
  return ProductRepositoryImpl(dio: ref.watch(dioProvider));
}
```

### 2. The Presentation Layer (Controllers & UI)
- **UI State with Sealed Classes**: To make the UI predictable and catch bugs early, define your UI states as a `sealed class`. This creates a finite set of states (e.g., `Initial`, `Loading`, `Success`, `Error`) that the UI must exhaustively handle using Dart 3's `switch` statements.
- **Riverpod Code Gen**: Always use `@riverpod` or `@Riverpod(keepAlive: true)` for providers. Avoid manual provider declarations.
- **Async Data**: Use Riverpod's generated AsyncNotifiers or FutureProviders to handle data fetching. The UI should just map `.when(data:, error:, loading:)`. If you need a more complex state that goes beyond simple data fetching, build a custom sealed class.
- **UI Logic**: Keep widgets dumb. Complex logic, state mutations, and API triggers belong in the Controller.
- **Action Methods**: Controllers should expose simple methods for the UI to call, e.g., `ref.read(authControllerProvider.notifier).login(email, password)`.

**Example of UI State (`product_ui_state.dart`)**:
```dart
sealed class ProductUiState {}
class ProductInitial extends ProductUiState {}
class ProductLoading extends ProductUiState {}
class ProductSuccess extends ProductUiState {
  final List<Product> products;
  ProductSuccess(this.products);
}
class ProductError extends ProductUiState {
  final String message;
  ProductError(this.message);
}
```

By using a `sealed class`, the UI can easily and predictably render based on the state using Dart 3 switch expressions:
```dart
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(productControllerProvider);
  
  return switch (state) {
    ProductInitial() => const Text('Ready to fetch'),
    ProductLoading() => const CircularProgressIndicator(),
    ProductSuccess(:final products) => ListView.builder(...),
    ProductError(:final message) => Text('Error: $message'),
  };
}
```

### 3. Routing
- Use `go_router` with declarative routing.
- Inject Riverpod's `ref` into the Router provider if you need to listen to auth state changes to redirect the user (e.g., kicking to login screen if token expires).

### 4. Code Generation Commands
Since we rely heavily on code generation (Riverpod, Slang, json_serializable), always run:

```bash
# Generate once
dart run build_runner build -d

# Watch for changes (recommended during development)
dart run build_runner watch -d
```

### 5. Adding a New Feature
1. Create a new folder in `lib/features/your_feature`.
2. Add `data/` if it fetches from an API. Create the API models (DTOs) and Repository.
3. *(Optional)* Add `domain/usecases/` **only if** the feature contains complex business logic that orchestrates multiple repositories.
4. Add `presentation/`. Create your `screens/` and `controllers/`.
5. Register the new screen in `core/router/app_router_provider.dart`.

### 6. Running Different Environments (Flavors)
This project uses native flavors (`dev`, `prod`) combined with different entry points (`main_dev.dart`, `main.dart`) to manage environment-specific configurations (like API Base URLs and App IDs).

**Command Line**
To run the app via terminal, specify both the target file (`-t`) and the flavor (`--flavor`):

```bash
# Run Development Environment (Debug Mode)
flutter run --flavor dev -t lib/main_dev.dart

# Run Production Environment (Release Mode)
flutter run --flavor prod -t lib/main.dart --release
```

**VS Code**
If you are using VS Code, you can use the predefined launch configurations in the "Run and Debug" panel (or `.vscode/launch.json`). This allows you to launch `Development` or `Production` with a single click.