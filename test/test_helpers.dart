import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Common test helpers and utilities

// Helper function to initialize test environment
void setupTestEnvironment() {
  // Setup any required test environment here
  TestWidgetsFlutterBinding.ensureInitialized();
}

// Helper function to create a testable widget
Widget createTestableWidget(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

// Example mock class for testing
class MockNavigatorObserver extends NavigatorObserver {
  final _pushedRoutes = <Route<dynamic>>[];
  final _poppedRoutes = <Route<dynamic>>[];

  List<Route<dynamic>> get pushedRoutes => List.unmodifiable(_pushedRoutes);
  List<Route<dynamic>> get poppedRoutes => List.unmodifiable(_poppedRoutes);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _pushedRoutes.add(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _poppedRoutes.add(route);
  }
}
