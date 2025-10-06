counter.listen((value) => print('New value: $value'));
counter.value++; // Triggers listener

# Changelog

This file documents notable changes to the `hybrid_manager` package.

---

## [0.0.4] - 2024-10-06

### Highlights

- Major refactor and feature expansion.
- Improved reactive state management (`Reactive<T>`), state notifiers, and provider system.
- Added functional hooks (`useState`, `useComputed`, `useEffect`).
- Introduced route management and enhanced dependency injection.
- Expanded documentation and provided comprehensive examples.
- Full test coverage and lint compliance.

### Added

- Streams, mapping, and disposal for `Reactive<T>`.
- Lifecycle management for `StateNotifier<T>`.
- Provider system: `Provider<T>`, `ScopedProvider<T>`, `ProviderFamily<T>`, `ReactiveProvider<T>`.
- Functional hooks for state and effects.
- RouteManager for navigation state.
- Dependency injection improvements.
- Hot reload utilities.
- Provider references (`ProviderRef<T>`).
- Type-safe APIs and error handling.
- Annotations for code generation.

### Changed

- Restructured codebase for maintainability.
- Improved API design and documentation.
- Updated README and CHANGELOG.

### Fixed

- Import and dependency issues.
- Lint errors and warnings.
- Test coverage and reliability.

### Removed

- Deprecated and incomplete stubs.

---

## [0.0.3] - 2024-09-01

### Added

- Initial provider and state notifier implementations.
- Basic reactive state management.

### Fixed

- Addressed import and setup issues.

---

## [0.0.2] - 2024-08-15

### Added

- Project structure and initial reactive value container.

---

## [0.0.1] - 2024-05-20

### Added

- Initial package setup.
- Basic reactive state and provider stubs.

---

## Roadmap & Notes

- CLI tooling and code generation support planned for future releases.
- For details, see the README and documentation.

---
