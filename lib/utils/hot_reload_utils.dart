import 'dart:developer' as developer;

/// Utilities for handling hot reload scenarios.
class HotReloadUtils {
  static final List<void Function()> _callbacks = [];
  static bool _initialized = false;

  /// Registers a callback to be executed on hot reload.
  static void onHotReload(void Function() callback) {
    _callbacks.add(callback);
    _initializeIfNeeded();
  }

  /// Removes a hot reload callback.
  static void removeHotReloadCallback(void Function() callback) {
    _callbacks.remove(callback);
  }

  /// Executes all registered hot reload callbacks.
  static void executeHotReloadCallbacks() {
    for (final callback in _callbacks) {
      try {
        callback();
      } catch (e) {
        print('Error in hot reload callback: $e');
      }
    }
  }

  /// Clears all hot reload callbacks.
  static void clearHotReloadCallbacks() {
    _callbacks.clear();
  }

  static void _initializeIfNeeded() {
    if (!_initialized) {
      _initialized = true;
      // Register with the developer tools for hot reload notifications
      developer.registerExtension('ext.flutter.hotReload',
          (method, parameters) async {
        executeHotReloadCallbacks();
        return developer.ServiceExtensionResponse.result('{}');
      });
    }
  }
}

/// Legacy function for backward compatibility.
void onHotReload(void Function() callback) {
  HotReloadUtils.onHotReload(callback);
}
