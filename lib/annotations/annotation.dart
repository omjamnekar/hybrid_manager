/// Annotation to mark a class as a provider that should be auto-registered.
class AutoProvider {
  /// Whether this provider should be a singleton.
  final bool singleton;

  /// Optional name for named registration.
  final String? name;

  const AutoProvider({this.singleton = false, this.name});
}

/// Annotation to mark a provider as scoped.
class ScopedProviderAnnotation {
  const ScopedProviderAnnotation();
}

/// Annotation to mark a method as an injection point.
class Inject {
  /// Optional name for named injection.
  final String? name;

  const Inject({this.name});
}

/// Annotation to mark a class as injectable.
class Injectable {
  /// Whether this should be a singleton.
  final bool singleton;

  const Injectable({this.singleton = false});
}

/// Legacy annotation for backward compatibility.
@Deprecated('Use AutoProvider instead')
class YourProvider {
  const YourProvider();
}
