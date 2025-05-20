import 'package:hybrid_manager/providers/base_provider.dart';

class ProviderRef<T> {
  final BaseProvider<T> provider;

  ProviderRef(this.provider);

  T read() => provider.create();
}
