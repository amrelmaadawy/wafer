import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        path: Routes.home,
        builder: (context, state) => const Scaffold(body: Center(child: Text('Home Screen'))), // TODO: Replace with HomeScreen
      ),
      // Add more routes here
    ],
    // TODO: Add redirect logic for Auth Guard
  );
}
