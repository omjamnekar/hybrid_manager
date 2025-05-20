class Injector {
  static final _instances = <Type, dynamic>{};

  static void put<T>(T instance) {
    _instances[T] = instance;
  }

  static T get<T>() {
    return _instances[T] as T;
  }

  static void reset() {
    _instances.clear();
  }
}
