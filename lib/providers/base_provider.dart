/// Base class for all providers in the hybrid_manager system.
/// Provides a contract for creating instances of type T.
abstract class BaseProvider<T> {
  /// Creates an instance of type T.
  T create();

  /// Optional cleanup method that can be overridden by subclasses.
  void dispose() {}

  /// Gets a unique identifier for this provider.
  String get id => runtimeType.toString();
}
