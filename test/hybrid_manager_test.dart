import 'package:flutter_test/flutter_test.dart';
import '../lib/hybrid_manager.dart';

void main() {
  group('Reactive Tests', () {
    test('should create reactive value with initial value', () {
      final reactive = Reactive<int>(42);
      expect(reactive.value, equals(42));
    });

    test('should notify listeners when value changes', () {
      final reactive = Reactive<int>(0);
      int? notifiedValue;

      reactive.listen((value) {
        notifiedValue = value;
      });

      reactive.value = 10;
      expect(notifiedValue, equals(10));
    });

    test('should not notify listeners when value does not change', () {
      final reactive = Reactive<int>(5);
      int callCount = 0;

      reactive.listen((value) {
        callCount++;
      });

      reactive.value = 5; // Same value
      expect(callCount, equals(0));
    });

    test('should dispose properly', () {
      final reactive = Reactive<int>(0);
      reactive.dispose();

      expect(() => reactive.value, throwsStateError);
    });

    test('should map to another reactive value', () {
      final source = Reactive<int>(5);
      final mapped = source.map<String>((value) => 'Value: $value');

      expect(mapped.value, equals('Value: 5'));

      source.value = 10;
      expect(mapped.value, equals('Value: 10'));
    });
  });

  group('StateNotifier Tests', () {
    test('should create state notifier with initial state', () {
      final notifier = _TestStateNotifier(0);
      expect(notifier.state, equals(0));
    });

    test('should notify listeners on state change', () {
      final notifier = _TestStateNotifier(0);
      int? notifiedState;

      notifier.addListener((state) {
        notifiedState = state;
      });

      notifier.increment();
      expect(notifiedState, equals(1));
    });

    test('should dispose properly', () {
      final notifier = _TestStateNotifier(0);
      notifier.dispose();

      expect(notifier.mounted, isFalse);
    });
  });

  group('Provider Tests', () {
    test('should create instance from provider', () {
      final provider = Provider<String>(() => 'Hello World');
      expect(provider.create(), equals('Hello World'));
    });

    test('should cache singleton instances', () {
      final provider =
          Provider<_TestClass>(() => _TestClass(), singleton: true);

      final instance1 = provider.create();
      final instance2 = provider.create();

      expect(identical(instance1, instance2), isTrue);
    });

    test('should create new instances for non-singleton providers', () {
      final provider =
          Provider<_TestClass>(() => _TestClass(), singleton: false);

      final instance1 = provider.create();
      final instance2 = provider.create();

      expect(identical(instance1, instance2), isFalse);
    });
  });

  group('ScopedProvider Tests', () {
    test('should use override value when set', () {
      final provider = ScopedProvider<String>(() => 'original');
      provider.overrideWithValue('overridden');

      expect(provider.create(), equals('overridden'));
    });

    test('should return to original value after clearing override', () {
      final provider = ScopedProvider<String>(() => 'original');
      provider.overrideWithValue('overridden');
      provider.clearOverride();

      expect(provider.create(), equals('original'));
    });
  });

  group('Injector Tests', () {
    setUp(() {
      Injector.reset();
    });

    test('should register and retrieve instances', () {
      const testValue = 'test';
      Injector.put<String>(testValue);

      expect(Injector.get<String>(), equals(testValue));
    });

    test('should register and retrieve named instances', () {
      const testValue = 'named test';
      Injector.put<String>(testValue, name: 'test');

      expect(Injector.get<String>(name: 'test'), equals(testValue));
    });

    test('should throw error for unregistered types', () {
      expect(() => Injector.get<int>(), throwsStateError);
    });

    test('should check registration status', () {
      Injector.put<String>('test');

      expect(Injector.isRegistered<String>(), isTrue);
      expect(Injector.isRegistered<int>(), isFalse);
    });
  });

  group('RouteManager Tests', () {
    setUp(() {
      // Fully reset route manager state between tests
      RouteManager.instance.reset();
    });

    test('should navigate to new route', () {
      final routeManager = RouteManager.instance;

      routeManager.navigateTo('/test', name: 'test');

      expect(routeManager.current.path, equals('/test'));
      expect(routeManager.current.name, equals('test'));
    });

    test('should maintain navigation history', () {
      final routeManager = RouteManager.instance;

      // Starting at home (/), navigate to page1, then page2
      // History should contain: [/, /page1] (current is /page2)
      routeManager.navigateTo('/page1', name: 'page1');
      routeManager.navigateTo('/page2', name: 'page2');

      expect(routeManager.history.length, equals(2)); // home + page1
      expect(routeManager.canGoBack, isTrue);
    });

    test('should go back to previous route', () {
      final routeManager = RouteManager.instance;

      routeManager.navigateTo('/page1', name: 'page1');
      routeManager.navigateTo('/page2', name: 'page2');

      final didGoBack = routeManager.goBack();

      expect(didGoBack, isTrue);
      expect(routeManager.current.path, equals('/page1'));
    });
  });
}

class _TestStateNotifier extends StateNotifier<int> {
  _TestStateNotifier(super.initialState);

  void increment() {
    state = state + 1;
  }
}

class _TestClass {}
