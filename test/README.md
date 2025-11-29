# Testing in Depi

This directory contains all the test files for the Depi Flutter application.

## Test Structure

- `test/unit/` - Contains unit tests for business logic, models, and services
- `test/widget/` - Contains widget tests for UI components and screens
- `test/test_helpers.dart` - Common test utilities and helper functions

## Running Tests

To run all tests:

```bash
flutter test
```

To run only unit tests:

```bash
flutter test test/unit/
```

To run only widget tests:

```bash
flutter test test/widget/
```

To run a specific test file:

```bash
flutter test test/unit/example_test.dart
```

## Writing Tests

### Unit Tests
- Place all unit tests in the `test/unit/` directory
- Name test files with `_test.dart` suffix
- Group related tests using `group()`
- Use descriptive test names with `test()`

### Widget Tests
- Place all widget tests in the `test/widget/` directory
- Name test files with `_test.dart` suffix
- Use `testWidgets()` for widget tests
- Use `pumpWidget()` to render widgets in tests
- Use `find.byType()` or `find.text()` to find widgets

## Dependencies

- `flutter_test` - Core testing package (included with Flutter)
- `mocktail` - For creating mocks and stubs (add to `dev_dependencies` in `pubspec.yaml`)
