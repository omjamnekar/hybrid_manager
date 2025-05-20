
# ⚡ Hybrid_manager

A powerful yet lightweight state management solution for Flutter that combines the best of GetX and Riverpod. Use class-based or functional state handling, scoped overrides, and hot-reload-friendly APIs — all in one clean package.

---

## ✨ Features

- 🔁 `Reactive<T>` for reactive state (like GetX's Rx)
- 🧠 `MyStateNotifier<T>` for class-based state logic (like Riverpod's StateNotifier)
- 🌱 `Provider<T>` and `ScopedProvider<T>` for dependency injection and state scoping
- 💡 `watch()` and `read()` for clean, functional state access
- 🔄 Hot-reload friendly design
- 🧪 Optional code generation for advanced performance
- 🛠 CLI tooling support (coming soon)

---

## 🚀 Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  your_package_name: ^0.0.1
```

Then run:

```bash
flutter pub get
```

---

## 🛠 Usage

### Functional Reactive State

```dart
final counter = Reactive<int>(0);

counter.listen((value) => print('New value: $value'));

counter.value++; // prints: New value: 1
```

### Class-based Notifier

```dart
class CounterNotifier extends MyStateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() => state++;
}
```

Register it:

```dart
final counterProvider = createNotifier(() => CounterNotifier());
```

Use it:

```dart
final counter = watch(counterProvider);
```

### Scoped Overrides

```dart
ProviderScope(
  overrides: [
    counterProvider.overrideWithValue(CounterNotifier()..state = 999),
  ],
  child: MyApp(),
);
```

---

## 🔮 Coming Soon

- 🧪 Built-in testing utilities
- 🛠 CLI to scaffold providers/notifiers
- 📦 Code generation annotations like `@yourProvider`

---

## 📄 License

MIT License

---

## 👨‍💻 Author
omJamnekar
[GitHub](https://github.com/yourusername)

---

## 🙌 Contributions

Feel free to open issues or pull requests! Help improve this package and make Flutter state management more enjoyable.
