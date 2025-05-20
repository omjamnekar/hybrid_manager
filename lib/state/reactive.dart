class Reactive<T> {
  T _value;
  final List<void Function(T)> _listeners = [];

  Reactive(this._value);

  T get value => _value;
  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      _listeners.forEach((listener) => listener(_value));
    }
  }

  void listen(void Function(T) listener) {
    _listeners.add(listener);
  }

  void dispose() {
    _listeners.clear();
  }
}
