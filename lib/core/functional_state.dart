import 'reactive.dart';

/// Creates a stateful value that can be used in functional contexts.
/// This is a simplified version - in a full implementation, this would
/// integrate with a widget system to manage the lifecycle.
Reactive<T> useState<T>(T initialValue) {
  return Reactive<T>(initialValue);
}

/// Creates a computed value that automatically updates when dependencies change.
Reactive<R> useComputed<R>(R Function() computation,
    {List<Reactive>? dependencies}) {
  final computed = Reactive<R>(computation());

  if (dependencies != null) {
    for (final dependency in dependencies) {
      dependency.listen((_) {
        try {
          computed.value = computation();
        } catch (e) {
          print('Error in computed value: $e');
        }
      });
    }
  }

  return computed;
}

/// Creates an effect that runs when dependencies change.
void useEffect(void Function() effect, {List<Reactive>? dependencies}) {
  // Run effect immediately
  effect();

  // Set up listeners for dependencies
  if (dependencies != null) {
    for (final dependency in dependencies) {
      dependency.listen((_) {
        try {
          effect();
        } catch (e) {
          print('Error in effect: $e');
        }
      });
    }
  }
}
