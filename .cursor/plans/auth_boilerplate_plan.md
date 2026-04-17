# Qaswa Jewellers — Auth Boilerplate Implementation Plan

## Architecture
Feature-First Clean Architecture + BLoC + get_it + Dio + GoRouter + FlutterSecureStorage

---

## Phase 1 — Dependencies

**File:** `pubspec.yaml`

Add the following packages:

| Package | Purpose |
|---|---|
| `flutter_bloc` | BLoC state management |
| `equatable` | Value equality for BLoC states/events |
| `get_it` | Dependency injection |
| `dio` | HTTP client |
| `flutter_secure_storage` | Token storage |
| `go_router` | Navigation/routing |

---

## Phase 2 — Core Infrastructure

Create all shared/cross-feature code under `lib/core/`.

### 2.1 — Error & Response
- [ ] `lib/core/error/api_response.dart`
  - `sealed class ApiResponse<T>`
  - `final class ApiSuccess<T> extends ApiResponse<T>`
  - `final class ApiError<T> extends ApiResponse<T>` with `message` and `statusCode`

### 2.2 — UseCase Base
- [ ] `lib/core/usecases/usecase.dart`
  - `abstract class UseCase<Type, Params>` with `Future<ApiResponse<Type>> call(Params params)`
  - `class NoParams {}`

### 2.3 — API Client
- [ ] `lib/core/api/api_client.dart`
  - Thin wrapper around `Dio`
  - Methods: `get()`, `post()`, `put()`, `delete()`
  - Returns raw `Response` — no parsing, no models

### 2.4 — Interceptors
- [ ] `lib/core/api/interceptors/logging_interceptor.dart`
  - Logs request method, URL, headers, body
  - Logs response status, body
  - Active in debug mode only (`kDebugMode`)
- [ ] `lib/core/api/interceptors/auth_interceptor.dart`
  - Reads `StorageKeys.accessToken` from `FlutterSecureStorage` on every request
  - Injects `Authorization: Bearer <token>` header if token exists
  - On 401 response: clears token from storage (redirect handled by GoRouter `refreshListenable`)

### 2.5 — Constants
- [ ] `lib/core/constants/api_constants.dart`
  - `baseUrl`, endpoint paths as `static const String`
- [ ] `lib/core/constants/storage_keys.dart`
  - `accessToken`, `refreshToken` keys

### 2.6 — Router
- [ ] `lib/core/router/app_routes.dart`
  - Route path constants: `/`, `/login`, `/home`
- [ ] `lib/core/router/app_router.dart`
  - Single `GoRouter` instance registered in get_it
  - Auth redirect guard: if no token → `/login`, if token → `/home`
  - `refreshListenable` wired to `AuthBloc` stream

### 2.7 — Dependency Injection
- [ ] `lib/core/di/core_injection.dart`
  - Registers: `FlutterSecureStorage`, `LoggingInterceptor`, `AuthInterceptor`, `Dio`, `ApiClient`
- [ ] `lib/core/di/auth_injection.dart`
  - Registers: `AuthRemoteDataSourceImpl`, `AuthRepositoryImpl`, `LoginUseCase`, `LogoutUseCase`, `GetCurrentUserUseCase`, `AuthBloc` (as `registerFactory`)
- [ ] `lib/core/di/injection.dart`
  - Master init: calls `_setupCore()` then `_setupAuth()`
  - Exports `final sl = GetIt.instance`

---

## Phase 3 — Auth Feature

All files under `lib/features/auth/`.

### 3.1 — Domain Layer

- [ ] `domain/entities/user.dart`
  - Fields: `id`, `name`, `email` (pure Dart, no JSON, no packages)

- [ ] `domain/repositories/auth_repository.dart`
  - Abstract interface:
    - `Future<ApiResponse<User>> login(String email, String password)`
    - `Future<ApiResponse<void>> logout()`
    - `Future<ApiResponse<User>> getCurrentUser()`

- [ ] `domain/usecases/login_usecase.dart`
  - `LoginParams` class with `email`, `password`
  - Implements `UseCase<User, LoginParams>`
  - Calls `repository.login()`

- [ ] `domain/usecases/logout_usecase.dart`
  - Implements `UseCase<void, NoParams>`
  - Calls `repository.logout()`

- [ ] `domain/usecases/get_current_user_usecase.dart`
  - Implements `UseCase<User, NoParams>`
  - Calls `repository.getCurrentUser()`

### 3.2 — Data Layer

- [ ] `data/models/user_model.dart`
  - Fields matching API response
  - `factory UserModel.fromJson(Map<String, dynamic> json)`
  - `User toEntity()` method

- [ ] `data/models/login_response_model.dart`
  - Wraps `accessToken` (String) + `user` (UserModel) from API login response
  - `factory LoginResponseModel.fromJson(...)`

- [ ] `data/datasources/auth_remote_data_source.dart`
  - Abstract interface:
    - `Future<LoginResponseModel> login(String email, String password)`
    - `Future<void> logout()`
    - `Future<UserModel> getCurrentUser()`

- [ ] `data/datasources/auth_remote_data_source_impl.dart`
  - Uses `ApiClient`
  - Calls endpoints from `ApiConstants`
  - Parses JSON into models
  - Does **not** catch exceptions — lets them propagate to repository

- [ ] `data/repositories/auth_repository_impl.dart`
  - Implements `AuthRepository`
  - **All try/catch lives here**
  - On success: calls `.toEntity()`, returns `ApiSuccess`
  - On `DioException`: returns `ApiError` with message + statusCode
  - On login success: saves token via `FlutterSecureStorage`
  - On logout: deletes token from `FlutterSecureStorage`

### 3.3 — Presentation Layer

- [ ] `presentation/bloc/auth_event.dart`
  - `sealed class AuthEvent`
  - `AuthLoginRequested` — email, password
  - `AuthLogoutRequested`
  - `AuthStatusChecked` — for splash screen check

- [ ] `presentation/bloc/auth_state.dart`
  - `sealed class AuthState`
  - `AuthInitial`, `AuthLoading`, `AuthAuthenticated(User)`, `AuthUnauthenticated`, `AuthError(String)`

- [ ] `presentation/bloc/auth_bloc.dart`
  - Handles all 3 events
  - On `AuthStatusChecked`: reads token from storage → emit Authenticated or Unauthenticated
  - Uses `LoginUseCase`, `LogoutUseCase`, `GetCurrentUserUseCase`

- [ ] `presentation/pages/splash_page.dart`
  - Dispatches `AuthStatusChecked` on init
  - Shows loading indicator while checking auth state
  - GoRouter `refreshListenable` handles redirect automatically

- [ ] `presentation/pages/login_page.dart`
  - Provides `AuthBloc` via `BlocProvider(create: (_) => sl<AuthBloc>())`
  - Listens to state: navigates on `AuthAuthenticated`, shows error on `AuthError`

- [ ] `presentation/widgets/login_form.dart`
  - Email + password fields with basic validation
  - Submit dispatches `AuthLoginRequested`
  - Disabled during `AuthLoading` state

---

## Phase 4 — Entry Point

- [ ] `lib/main.dart`
  - Calls `WidgetsFlutterBinding.ensureInitialized()`
  - Calls `await setupDI()`
  - Runs `MyApp` with `sl<GoRouter>()` passed to `MaterialApp.router`

---

## Implementation Order

```
1. pubspec.yaml  (add deps, run flutter pub get)
2. core/error/api_response.dart
3. core/usecases/usecase.dart
4. core/constants/*
5. core/api/api_client.dart + interceptors
6. features/auth/domain/* (entities → repository interface → usecases)
7. features/auth/data/* (models → datasource → repository impl)
8. features/auth/presentation/bloc/*
9. core/router/*
10. core/di/* (bottom-up: core → auth → master injection)
11. features/auth/presentation/pages + widgets
12. main.dart
```

> Always implement Domain before Data before Presentation. Domain has no dependencies so it compiles first.
