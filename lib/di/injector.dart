import '../providers/base_provider.dart';

/// A simple dependency injection container.
/// Provides type-safe registration and retrieval of instances.
class Injector {
  static final Map<Type, dynamic> _instances = <Type, dynamic>{};
  static final Map<Type, BaseProvider> _providers = <Type, BaseProvider>{};
  static final Map<String, dynamic> _namedInstances = <String, dynamic>{};

  /// Registers an instance for the given type.
  static void put<T>(T instance, {String? name}) {
    if (name != null) {
      _namedInstances['${T.toString()}_$name'] = instance;
    } else {
      _instances[T] = instance;
    }
  }

  /// Registers a provider for the given type.
  static void putProvider<T>(BaseProvider<T> provider) {
    _providers[T] = provider;
  }

  /// Gets an instance of the given type.
  /// Throws [StateError] if the type is not registered.
  static T get<T>({String? name}) {
    if (name != null) {
      final key = '${T.toString()}_$name';
      final instance = _namedInstances[key];
      if (instance == null) {
        throw StateError(
            'No instance registered for type $T with name "$name"');
      }
      return instance as T;
    }

    // Try to get from instances first
    final instance = _instances[T];
    if (instance != null) {
      return instance as T;
    }

    // Try to create from provider
    final provider = _providers[T] as BaseProvider<T>?;
    if (provider != null) {
      final created = provider.create();
      _instances[T] = created; // Cache the instance
      return created;
    }

    throw StateError('No instance or provider registered for type $T');
  }

  /// Gets an instance if it exists, otherwise returns null.
  static T? tryGet<T>({String? name}) {
    try {
      return get<T>(name: name);
    } catch (e) {
      return null;
    }
  }

  /// Checks if a type is registered.
  static bool isRegistered<T>({String? name}) {
    if (name != null) {
      return _namedInstances.containsKey('${T.toString()}_$name');
    }
    return _instances.containsKey(T) || _providers.containsKey(T);
  }

  /// Removes an instance or provider for the given type.
  static void remove<T>({String? name}) {
    if (name != null) {
      _namedInstances.remove('${T.toString()}_$name');
    } else {
      _instances.remove(T);
      final provider = _providers.remove(T);
      provider?.dispose();
    }
  }

  /// Clears all registered instances and providers.
  static void reset() {
    // Dispose all providers
    for (final provider in _providers.values) {
      provider.dispose();
    }
    _instances.clear();
    _providers.clear();
    _namedInstances.clear();
  }

  /// Gets all registered types.
  static List<Type> get registeredTypes {
    final types = <Type>{};
    types.addAll(_instances.keys);
    types.addAll(_providers.keys);
    return types.toList();
  }
}
