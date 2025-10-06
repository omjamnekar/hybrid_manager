import '../core/reactive.dart';
import '../providers/base_provider.dart';

/// A simple route information holder.
class RouteInfo {
  final String path;
  final String name;
  final Map<String, dynamic> parameters;
  final Map<String, dynamic> queryParameters;

  const RouteInfo({
    required this.path,
    required this.name,
    this.parameters = const {},
    this.queryParameters = const {},
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RouteInfo && other.path == path && other.name == name;
  }

  @override
  int get hashCode => path.hashCode ^ name.hashCode;

  @override
  String toString() => 'RouteInfo(path: $path, name: $name)';
}

/// A reactive route manager for handling navigation state.
class RouteManager {
  static RouteManager? _instance;

  final Reactive<RouteInfo> _currentRoute = Reactive<RouteInfo>(
    const RouteInfo(path: '/', name: 'home'),
  );

  final List<RouteInfo> _history = [];
  final int _maxHistorySize;

  RouteManager._({int maxHistorySize = 50}) : _maxHistorySize = maxHistorySize;

  /// Gets the singleton instance of RouteManager.
  static RouteManager get instance {
    return _instance ??= RouteManager._();
  }

  /// Gets the current route as a reactive value.
  Reactive<RouteInfo> get currentRoute => _currentRoute;

  /// Gets the current route information.
  RouteInfo get current => _currentRoute.value;

  /// Gets the navigation history.
  List<RouteInfo> get history => List.unmodifiable(_history);

  /// Navigates to a new route.
  void navigateTo(
    String path, {
    String? name,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? queryParameters,
    bool addToHistory = true,
  }) {
    final route = RouteInfo(
      path: path,
      name: name ?? path,
      parameters: parameters ?? {},
      queryParameters: queryParameters ?? {},
    );

    if (addToHistory) {
      _addToHistory(_currentRoute.value);
    }

    _currentRoute.value = route;
  }

  /// Navigates back to the previous route.
  bool goBack() {
    if (_history.isNotEmpty) {
      final previousRoute = _history.removeLast();
      _currentRoute.value = previousRoute;
      return true;
    }
    return false;
  }

  /// Replaces the current route without adding to history.
  void replace(
    String path, {
    String? name,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? queryParameters,
  }) {
    navigateTo(
      path,
      name: name,
      parameters: parameters,
      queryParameters: queryParameters,
      addToHistory: false,
    );
  }

  /// Clears the navigation history.
  void clearHistory() {
    _history.clear();
  }

  /// Fully resets the route manager to initial state (for testing).
  void reset() {
    clearHistory();
    _currentRoute.value = const RouteInfo(path: '/', name: 'home');
  }

  /// Checks if navigation can go back.
  bool get canGoBack => _history.isNotEmpty;

  void _addToHistory(RouteInfo route) {
    _history.add(route);

    // Limit history size
    if (_history.length > _maxHistorySize) {
      _history.removeAt(0);
    }
  }

  /// Disposes the route manager.
  void dispose() {
    _currentRoute.dispose();
    _history.clear();
    _instance = null;
  }
}

/// A provider for the route manager.
class RouteManagerProvider extends BaseProvider<RouteManager> {
  @override
  RouteManager create() => RouteManager.instance;
}
