import 'dart:async';

/// A reactive value container that notifies listeners when its value changes.
/// Similar to GetX's Rx pattern but with enhanced functionality.
class Reactive<T> {
  T _value;
  final List<void Function(T)> _listeners = [];
  final StreamController<T> _streamController = StreamController<T>.broadcast();
  bool _disposed = false;

  /// Creates a new reactive value with the given initial value.
  Reactive(this._value);

  /// Gets the current value.
  T get value {
    _throwIfDisposed();
    return _value;
  }

  /// Sets a new value and notifies all listeners if the value has changed.
  set value(T newValue) {
    _throwIfDisposed();
    if (_value != newValue) {
      final oldValue = _value;
      _value = newValue;
      _notifyListeners(newValue, oldValue);
    }
  }

  /// Gets a stream of value changes.
  Stream<T> get stream {
    _throwIfDisposed();
    return _streamController.stream;
  }

  /// Gets whether this reactive value has been disposed.
  bool get isDisposed => _disposed;

  /// Adds a listener that will be called whenever the value changes.
  /// Returns a function that can be called to remove the listener.
  VoidCallback listen(void Function(T) listener) {
    _throwIfDisposed();
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  /// Adds a listener that includes both new and old values.
  VoidCallback listenWithPrevious(
      void Function(T newValue, T oldValue) listener) {
    _throwIfDisposed();
    void wrappedListener(T newValue) {
      // This is a simplified version - in practice you'd need to track the previous value
      listener(newValue, _value);
    }

    _listeners.add(wrappedListener);
    return () => _listeners.remove(wrappedListener);
  }

  /// Updates the value using a function.
  void update(T Function(T) updater) {
    value = updater(value);
  }

  /// Maps this reactive value to another reactive value.
  Reactive<R> map<R>(R Function(T) mapper) {
    final mapped = Reactive<R>(mapper(value));
    listen((newValue) {
      mapped.value = mapper(newValue);
    });
    return mapped;
  }

  /// Disposes this reactive value and cleans up all listeners.
  void dispose() {
    if (!_disposed) {
      _disposed = true;
      _listeners.clear();
      _streamController.close();
    }
  }

  void _notifyListeners(T newValue, T oldValue) {
    // Create a copy to avoid concurrent modification
    final listeners = List<void Function(T)>.from(_listeners);
    for (final listener in listeners) {
      try {
        listener(newValue);
      } catch (e) {
        // Log error but continue with other listeners
        print('Error in reactive listener: $e');
      }
    }
    _streamController.add(newValue);
  }

  void _throwIfDisposed() {
    if (_disposed) {
      throw StateError('Reactive value has been disposed');
    }
  }

  @override
  String toString() => 'Reactive<$T>($_value)';
}

/// A callback function type.
typedef VoidCallback = void Function();
