import '../core/reactive.dart';

/// Hook-style API for creating reactive state.
/// This provides a React-like interface for state management.
Reactive<T> useReactiveState<T>(T initialValue) {
  return Reactive<T>(initialValue);
}

/// Creates a reducer-style state manager.
Reactive<T> useReducer<T, A>(
    T initialState, T Function(T state, A action) reducer) {
  final state = Reactive<T>(initialState);

  void dispatch(A action) {
    state.value = reducer(state.value, action);
  }

  // Attach dispatch function to the reactive state
  (state as dynamic).dispatch = dispatch;

  return state;
}

/// Creates a memoized value that only recomputes when dependencies change.
Reactive<R> useMemo<R>(R Function() computation, List<Reactive> dependencies) {
  final memo = Reactive<R>(computation());

  for (final dependency in dependencies) {
    dependency.listen((_) {
      memo.value = computation();
    });
  }

  return memo;
}
