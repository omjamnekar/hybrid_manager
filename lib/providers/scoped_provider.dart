import 'package:hybrid_manager/providers/base_provider.dart';

class ScopedProvider<T> extends BaseProvider<T> {
  final T Function() _creator;
  T? _override;

  ScopedProvider(this._creator);

  void overrideWithValue(T value) {
    _override = value;
  }

  @override
  T create() => _override ?? _creator();
}
