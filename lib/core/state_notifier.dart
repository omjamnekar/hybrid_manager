abstract class StateNotifier<T> {
  T _state;
  final List<void Function(T)> _listeners = [];

  StateNotifier(this._state);

  T get state => _state;
  set state(T newState) {
    _state = newState;
    for (final listener in _listeners) {
      listener(_state);
    }
  }

  void addListener(void Function(T) listener) {
    _listeners.add(listener);
  }
}
