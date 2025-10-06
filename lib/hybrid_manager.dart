library hybrid_manager;

// Core reactive system
export 'core/reactive.dart';
export 'core/state_notifier.dart';
export 'core/functional_state.dart' hide useState;

// Provider system
export 'providers/base_provider.dart';
export 'providers/scoped_provider.dart';
export 'providers/provider_ref.dart';
export 'providers/provider.dart';

// Dependency injection
export 'di/injector.dart';

// Hooks
export 'hooks/use_state.dart';

// Utilities
export 'utils/hot_reload_utils.dart';
export 'router/route_manager.dart';

// Annotations
export 'annotations/annotation.dart' hide ScopedProviderAnnotation;
