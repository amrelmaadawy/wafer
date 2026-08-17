import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/notifications/domain/entities/notification_item_entity.dart';
import 'package:wafer/features/notifications/presentation/widgets/notification_card.dart';

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6)),
    ),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('renders title, body, and priority badge', (tester) async {
    const notif = NotificationItemEntity(
      id: '1',
      title: 'Water Leak',
      body: 'Unit 102 reported water leak in bathroom',
      type: 'maintenance',
      priority: 'high',
      createdAt: '2026-08-17T10:00:00Z',
    );

    await tester.pumpWidget(
      _wrapWithApp(
        NotificationCard(
          notification: notif,
          onTap: () {},
        ),
      ),
    );

    expect(find.text('Water Leak'), findsOneWidget);
    expect(find.text('Unit 102 reported water leak in bathroom'), findsOneWidget);
  });
}
