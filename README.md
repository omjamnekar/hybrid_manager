# ⚡ Hybrid Manager

A powerful yet lightweight state management solution for Flutter that combines the best of GetX and Riverpod patterns. Use reactive programming, class-based state notifiers, dependency injection, and hot-reload-friendly APIs — all in one clean package.

[![Pub Version](https://img.shields.io/pub/v/hybrid_manager)](https://pub.dev/packages/hybrid_manager)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## ✨ Features

- 🔁 **Reactive Values**: `Reactive<T>` for reactive state management (inspired by GetX's Rx)
- 🧠 **State Notifiers**: `StateNotifier<T>` for class-based state logic (inspired by Riverpod)
- 🌱 **Provider System**: `Provider<T>` and `ScopedProvider<T>` for dependency injection
- 💡 **Functional Hooks**: `useState`, `useComputed`, `useEffect` for functional programming
- 🔄 **Hot-reload Friendly**: Maintains state during development
- 🚀 **Route Management**: Built-in reactive route management
- 🧪 **Type Safe**: Full TypeScript-level type safety
- 📦 **Lightweight**: Minimal dependencies, maximum performance

---

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  hybrid_manager: ^0.0.4
```

Then run:

```bash
flutter pub get
```

---

## � Quick Start

### Reactive Values

```dart
import 'package:hybrid_manager/hybrid_manager.dart';

// Create a reactive value
final counter = Reactive<int>(0);

// Listen to changes
counter.listen((value) => print('Counter: $value'));

// Update the value
counter.value++; // prints: Counter: 1

// Use in widgets (pseudo-code)
Widget build(BuildContext context) {
  return Text('${counter.value}');
}
```

### State Notifiers

```dart
class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void increment() {
    state = state + 1;
  }

  void decrement() {
    if (state > 0) {
      state = state - 1;
    }
  }

  void reset() {
    state = 0;
  }
}

// Usage
final counterNotifier = CounterNotifier();
counterNotifier.addListener((state) => print('State: $state'));
counterNotifier.increment(); // prints: State: 1
```

### Providers & Dependency Injection

```dart
// Create providers
final apiProvider = Provider<ApiService>(() => ApiService());
final userProvider = Provider<UserService>(() => UserService(apiProvider.create()));

// Register with injector
Injector.putProvider<ApiService>(apiProvider);
Injector.putProvider<UserService>(userProvider);

// Use anywhere in your app
final userService = Injector.get<UserService>();
```

### Scoped Providers

```dart
final configProvider = ScopedProvider<Config>(() => Config.production());

// Override for testing
configProvider.overrideWithValue(Config.testing());

// Use the overridden value
final config = configProvider.create(); // Returns Config.testing()
```

### Functional Hooks

```dart
// State hook
final count = useState(0);
count.value++; // Reactive updates

// Computed values
final doubled = useComputed(() => count.value * 2, dependencies: [count]);

// Effects
useEffect(() {
  print('Count changed to: ${count.value}');
}, dependencies: [count]);
```

### Route Management

```dart
final routeManager = RouteManager.instance;

// Navigate
routeManager.navigateTo('/profile', name: 'profile');

// Listen to route changes
routeManager.currentRoute.listen((route) {
  print('Current route: ${route.path}');
});

// Go back
if (routeManager.canGoBack) {
  routeManager.goBack();
}
```

---

## 📚 Advanced Usage

### Provider Families

```dart
final userProvider = ProviderFamily<User, String>((userId) {
  return UserRepository().getUser(userId);
});

// Usage
final user1Provider = userProvider('user1');
final user2Provider = userProvider('user2');
```

### Reactive Providers

```dart
final weatherReactive = Reactive<String>('sunny');
final temperatureReactive = Reactive<int>(25);

final weatherProvider = ReactiveProvider<String>(
  () => '${weatherReactive.value} and ${temperatureReactive.value}°C',
  dependencies: [weatherReactive, temperatureReactive],
);

// Automatically updates when dependencies change
weatherReactive.value = 'cloudy'; // Provider updates automatically
```

### Hot Reload Support

```dart
HotReloadUtils.onHotReload(() {
  // Reset state or perform cleanup
  Injector.reset();
  print('Hot reload detected!');
});
```

---

## 🧪 Testing

Hybrid Manager is designed with testing in mind:

```dart
void main() {
  group('Counter Tests', () {
    late CounterNotifier counter;

    setUp(() {
      counter = CounterNotifier();
    });

    tearDown(() {
      counter.dispose();
    });

    test('should increment counter', () {
      counter.increment();
      expect(counter.state, equals(1));
    });

    test('should notify listeners', () {
      int? notifiedValue;
      counter.addListener((value) => notifiedValue = value);

      counter.increment();
      expect(notifiedValue, equals(1));
    });
  });
}
```

---

## 🎯 Architecture Patterns

### MVVM with Hybrid Manager

```dart
// Model
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}

// ViewModel
class UserViewModel extends StateNotifier<User?> {
  UserViewModel() : super(null);

  void loadUser(String id) async {
    try {
      final user = await UserRepository().getUser(id);
      state = user;
    } catch (e) {
      // Handle error
    }
  }
}

// View (Widget)
class UserProfileWidget extends StatelessWidget {
  final UserViewModel viewModel;

  UserProfileWidget({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: viewModel.stream,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) return CircularProgressIndicator();

        return Column(
          children: [
            Text(user.name),
            Text(user.email),
          ],
        );
      },
    );
  }
}
```

---

## 🔧 Best Practices

1. **Use StateNotifier for Complex Logic**: When you have complex state transitions, use `StateNotifier`
2. **Use Reactive for Simple State**: For simple values that need reactivity, use `Reactive<T>`
3. **Scope Your Providers**: Use `ScopedProvider` for different app contexts (testing, development, production)
4. **Dispose Resources**: Always dispose of state notifiers and reactive values when done
5. **Test Your State**: Use the provided testing utilities to ensure your state management works correctly

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by [GetX](https://pub.dev/packages/get) for reactive programming
- Inspired by [Riverpod](https://pub.dev/packages/riverpod) for provider patterns
- Built with ❤️ for the Flutter community

---

## 📞 Support

If you like this package, please give it a ⭐ on [GitHub](https://github.com/omjamnekar/hybrid_manager) and 👍 on [pub.dev](https://pub.dev/packages/hybrid_manager)!

For issues and feature requests, please use the [GitHub issue tracker](https://github.com/omjamnekar/hybrid_manager/issues).
class CounterNotifier extends MyStateNotifier<int> {
CounterNotifier() : super(0);

void increment() => state++;
}

````

Register it:

```dart
final counterProvider = createNotifier(() => CounterNotifier());
````

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

## Coming Soon

- Built-in testing utilities
- CLI to scaffold providers/notifiers
- Code generation annotations like `@yourProvider`

---

## License

MIT License

---

## Author

omJamnekar
[GitHub](https://github.com/omjamnekar)

---

## 🙌 Contributions

Feel free to open issues or pull requests! Help improve this package and make Flutter state management more enjoyable.
