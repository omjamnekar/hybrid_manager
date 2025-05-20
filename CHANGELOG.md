
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [0.0.1] - 2025-05-20

###  Added
-  `Reactive<T>` for observable-like behavior (similar to GetX's `Rx<T>`)
-  `MyStateNotifier<T>` for class-based state management (like Riverpod's `StateNotifier`)
-  `Provider<T>` for global state provisioning
-  `ScopedProvider<T>` for overriding providers locally
-  `watch()` and `read()` methods for functional-style state access
-  `ProviderScope` widget for scoped overrides and hot-reload friendliness
-  Basic `injector()` for dependency management

---

###   Code Examples

####  Reactive State Example

```dart
final counter = Reactive<int>(0);

counter.listen((value) => print('New value: $value'));

counter.value++; // Triggers listener
```

####  Class-Based State Notifier

```dart
class CounterNotifier extends MyStateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
}
```

Usage:

```dart
final counterProvider = createNotifier(() => CounterNotifier());

final counter = watch(counterProvider);
```

####  Scoped Override

```dart
ProviderScope(
  overrides: [
    counterProvider.overrideWithValue(CounterNotifier()..state = 999),
  ],
  child: MyApp(),
);
```

---

### Fixed
- N/A (initial release)

---

###  Known Limitations
- No CLI support yet (planned for a future version)
- Code generation (`@myProvider`) is not included in this version

---

## Coming Soon
-  CLI to generate providers and notifiers
-  Code generation support for annotated providers
-  Built-in testing utilities

---

## Versioning

We follow semantic versioning:

- MAJOR version when you make incompatible API changes
- MINOR version when you add functionality in a backward-compatible manner
- PATCH version when you make backward-compatible bug fixes

---
