import 'base_provider.dart';
import 'scoped_provider.dart';
import 'provider_ref.dart';
import '../core/reactive.dart';

/// A standard provider that creates instances using a factory function.
/// This is the most common type of provider in the hybrid_manager system.
class Provider<T> extends BaseProvider<T> {
  final T Function() _creator;
  final bool _singleton;
  T? _instance;

  /// Creates a provider with a factory function.
  /// If [singleton] is true, the created instance will be cached.
  Provider(this._creator, {bool singleton = false}) : _singleton = singleton;

  /// Creates a provider that always returns the given value.
  Provider.value(T value)
      : _creator = (() => value),
        _singleton = true,
        _instance = value;

  @override
  T create() {
    if (_singleton) {
      return _instance ??= _creator();
    }
    return _creator();
  }

  @override
  void dispose() {
    _instance = null;
    super.dispose();
  }

  /// Creates a scoped version of this provider.
  ScopedProvider<T> scoped() {
    return ScopedProvider<T>(_creator, singleton: _singleton);
  }

  /// Creates a provider reference for this provider.
  ProviderRef<T> ref() {
    return ProviderRef<T>(this);
  }
}

/// A family of providers that can be parameterized.
/// Similar to Riverpod's provider families.
class ProviderFamily<T, P> {
  final T Function(P) _creator;
  final Map<P, Provider<T>> _providers = {};
  final bool _singleton;

  /// Creates a provider family with a parameterized factory function.
  ProviderFamily(this._creator, {bool singleton = false})
      : _singleton = singleton;

  /// Gets a provider for the given parameter.
  Provider<T> call(P parameter) {
    return _providers.putIfAbsent(
      parameter,
      () => Provider<T>(() => _creator(parameter), singleton: _singleton),
    );
  }

  /// Disposes all providers in this family.
  void dispose() {
    for (final provider in _providers.values) {
      provider.dispose();
    }
    _providers.clear();
  }
}

/// A reactive provider that automatically updates when dependencies change.
class ReactiveProvider<T> extends BaseProvider<T> {
  final T Function() _creator;
  final Reactive<T> _reactive;
  final List<Reactive> _dependencies;

  /// Creates a reactive provider that watches the given dependencies.
  ReactiveProvider(this._creator, {List<Reactive> dependencies = const []})
      : _dependencies = List.from(dependencies),
        _reactive = Reactive<T>(_creator()) {
    _setupDependencyListeners();
  }

  @override
  T create() => _reactive.value;

  /// Gets the reactive value directly.
  Reactive<T> get reactive => _reactive;

  void _setupDependencyListeners() {
    for (final dependency in _dependencies) {
      dependency.listen((_) {
        try {
          _reactive.value = _creator();
        } catch (e) {
          print('Error updating reactive provider: $e');
        }
      });
    }
  }

  @override
  void dispose() {
    _reactive.dispose();
    super.dispose();
  }
}
