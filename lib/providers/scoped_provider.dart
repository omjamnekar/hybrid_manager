import 'base_provider.dart';

/// A provider that can be scoped and overridden within specific contexts.
/// Useful for testing and dependency injection scenarios.
class ScopedProvider<T> extends BaseProvider<T> {
  final T Function() _creator;
  T? _override;
  T? _instance;
  final bool _singleton;

  /// Creates a scoped provider with a creator function.
  /// If [singleton] is true, the created instance will be cached.
  ScopedProvider(this._creator, {bool singleton = false})
      : _singleton = singleton;

  /// Creates a scoped provider that always returns the given value.
  ScopedProvider.value(T value)
      : _creator = (() => value),
        _singleton = true,
        _override = value;

  /// Overrides the provider with a specific value.
  void overrideWithValue(T value) {
    _override = value;
    _instance = null; // Clear cached instance
  }

  /// Overrides the provider with a new creator function.
  void overrideWithProvider(ScopedProvider<T> provider) {
    _override = null;
    _instance = null;
    overrideWithValue(provider.create());
  }

  /// Clears any override, returning to the original creator function.
  void clearOverride() {
    _override = null;
    _instance = null;
  }

  @override
  T create() {
    if (_override != null) {
      return _override!;
    }

    if (_singleton) {
      return _instance ??= _creator();
    }

    return _creator();
  }

  @override
  void dispose() {
    _instance = null;
    _override = null;
    super.dispose();
  }

  /// Gets whether this provider has an active override.
  bool get hasOverride => _override != null;
}
