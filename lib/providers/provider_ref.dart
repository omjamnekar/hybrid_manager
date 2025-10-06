import 'base_provider.dart';
import '../core/reactive.dart';

/// A reference to a provider that provides methods to read and watch values.
/// Similar to Riverpod's ProviderRef but adapted for hybrid_manager.
class ProviderRef<T> {
  final BaseProvider<T> provider;
  Reactive<T>? _reactive;

  /// Creates a provider reference.
  ProviderRef(this.provider);

  /// Reads the current value from the provider.
  T read() => provider.create();

  /// Gets a reactive wrapper around the provider value.
  /// This allows watching for changes if the provider supports it.
  Reactive<T> watch() {
    return _reactive ??= Reactive<T>(provider.create());
  }

  /// Refreshes the reactive value if one exists.
  void refresh() {
    if (_reactive != null) {
      _reactive!.value = provider.create();
    }
  }

  /// Disposes the reactive wrapper if it exists.
  void dispose() {
    _reactive?.dispose();
    _reactive = null;
    provider.dispose();
  }
}
