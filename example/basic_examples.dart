import 'package:hybrid_manager/core/functional_state.dart';

import '../lib/hybrid_manager.dart';

/// Example demonstrating basic reactive state management
void reactiveExample() {
  print('=== Reactive Example ===');

  // Create a reactive value
  final counter = Reactive<int>(0);

  // Listen to changes
  final removeListener = counter.listen((value) {
    print('Counter changed to: $value');
  });

  // Update values
  counter.value = 5; // prints: Counter changed to: 5
  counter.value = 10; // prints: Counter changed to: 10

  // Map to another reactive value
  final doubled = counter.map<int>((value) => value * 2);
  doubled.listen((value) => print('Doubled: $value'));

  counter.value = 15; // prints: Counter changed to: 15, Doubled: 30

  // Clean up
  removeListener();
  counter.dispose();
  doubled.dispose();
}

/// Example demonstrating StateNotifier usage
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

void stateNotifierExample() {
  print('\n=== State Notifier Example ===');

  final counter = CounterNotifier();

  // Listen to state changes
  counter.addListener((state) {
    print('Counter state: $state');
  });

  // Perform operations
  counter.increment(); // prints: Counter state: 1
  counter.increment(); // prints: Counter state: 2
  counter.decrement(); // prints: Counter state: 1
  counter.reset(); // prints: Counter state: 0

  counter.dispose();
}

/// Example demonstrating provider system
class ApiService {
  String get baseUrl => 'https://api.example.com';

  Future<String> fetchData() async {
    await Future.delayed(Duration(milliseconds: 100));
    return 'API Data from $baseUrl';
  }
}

class UserService {
  final ApiService apiService;

  UserService(this.apiService);

  Future<String> getUserData() async {
    return await apiService.fetchData();
  }
}

void providerExample() {
  print('\n=== Provider Example ===');

  // Create providers
  final apiProvider = Provider<ApiService>(() => ApiService());
  final userProvider =
      Provider<UserService>(() => UserService(apiProvider.create()));

  // Register with injector
  Injector.putProvider<ApiService>(apiProvider);
  Injector.putProvider<UserService>(userProvider);

  // Use the services
  final userService = Injector.get<UserService>();
  print('User service created with API: ${userService.apiService.baseUrl}');

  // Test scoped provider
  final configProvider = ScopedProvider<String>(() => 'production');
  print('Original config: ${configProvider.create()}');

  configProvider.overrideWithValue('testing');
  print('Overridden config: ${configProvider.create()}');

  configProvider.clearOverride();
  print('Reset config: ${configProvider.create()}');

  // Clean up
  Injector.reset();
}

/// Example demonstrating functional hooks
void functionalExample() {
  print('\n=== Functional Hooks Example ===');

  // useState hook (from functional_state.dart)
  final count = useState<int>(0);
  print('Initial count: ${count.value}');

  count.value = 5;
  print('Updated count: ${count.value}');

  // useComputed hook
  final doubled = useComputed(() => count.value * 2, dependencies: [count]);
  print('Computed doubled: ${doubled.value}');

  count.value = 10;
  print(
      'After count update - Count: ${count.value}, Doubled: ${doubled.value}');

  // useEffect hook
  useEffect(() {
    print('Effect triggered! Count is now: ${count.value}');
  }, dependencies: [count]);

  count.value = 15; // Triggers effect

  // Clean up
  count.dispose();
  doubled.dispose();
}

/// Example demonstrating route management
void routeExample() {
  print('\n=== Route Management Example ===');

  final routeManager = RouteManager.instance;

  // Listen to route changes
  routeManager.currentRoute.listen((route) {
    print('Current route: ${route.path} (${route.name})');
  });

  // Navigate to different routes
  routeManager.navigateTo('/home', name: 'Home');
  routeManager
      .navigateTo('/profile', name: 'Profile', parameters: {'userId': '123'});
  routeManager.navigateTo('/settings', name: 'Settings');

  print('Can go back: ${routeManager.canGoBack}');
  print('History length: ${routeManager.history.length}');

  // Go back
  routeManager.goBack();
  print('After going back: ${routeManager.current.name}');

  routeManager.dispose();
}

/// Main example runner
void main() {
  print('🚀 Hybrid Manager Examples\n');

  reactiveExample();
  stateNotifierExample();
  providerExample();
  functionalExample();
  routeExample();

  print('\n✅ All examples completed!');
}
