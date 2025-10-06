import 'dart:async';
import 'reactive.dart' show VoidCallback;

/// Abstract base class for state notifiers.
/// Similar to Riverpod's StateNotifier but with enhanced functionality.
abstract class StateNotifier<T> {
  T _state;
  final List<void Function(T)> _listeners = [];
  final StreamController<T> _streamController = StreamController<T>.broadcast();
  bool _disposed = false;
  bool _mounted = true;

  /// Creates a new state notifier with the given initial state.
  StateNotifier(this._state);

  /// Gets the current state.
  T get state {
    _throwIfDisposed();
    return _state;
  }

  /// Gets whether this notifier is still mounted and active.
  bool get mounted => _mounted && !_disposed;

  /// Gets a stream of state changes.
  Stream<T> get stream {
    _throwIfDisposed();
    return _streamController.stream;
  }

  /// Updates the state and notifies all listeners.
  /// Only updates if the notifier is still mounted.
  @protected()
  set state(T newState) {
    _throwIfDisposed();
    if (!mounted) return;

    if (_state != newState) {
      final oldState = _state;
      _state = newState;
      _notifyListeners(newState, oldState);
    }
  }

  /// Adds a listener that will be called whenever the state changes.
  /// Returns a function that can be called to remove the listener.
  VoidCallback addListener(void Function(T) listener) {
    _throwIfDisposed();
    _listeners.add(listener);
    return () => removeListener(listener);
  }

  /// Removes a specific listener.
  void removeListener(void Function(T) listener) {
    _listeners.remove(listener);
  }

  /// Updates the state using a function.
  void updateState(T Function(T current) updater) {
    state = updater(state);
  }

  /// Called when the notifier is about to be disposed.
  /// Override this method to perform cleanup.
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _mounted = false;
      _listeners.clear();
      _streamController.close();
    }
  }

  void _notifyListeners(T newState, T oldState) {
    // Create a copy to avoid concurrent modification
    final listeners = List<void Function(T)>.from(_listeners);
    for (final listener in listeners) {
      try {
        listener(newState);
      } catch (e) {
        // Log error but continue with other listeners
        print('Error in state notifier listener: $e');
      }
    }
    _streamController.add(newState);
  }

  void _throwIfDisposed() {
    if (_disposed) {
      throw StateError('StateNotifier has been disposed');
    }
  }

  @override
  String toString() => 'StateNotifier<$T>($_state)';
}

/// Annotation to mark protected members.
class protected {
  const protected();
}
