class Provider<T> {
  final T Function() _create;
  late final T _instance;

  Provider(this._create) {
    _instance = _create();
  }

  T get instance => _instance;
}
