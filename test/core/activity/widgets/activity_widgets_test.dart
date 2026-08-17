import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/activity/entities/activity_log_entity.dart';
import 'package:wafer/core/activity/widgets/activity_log_item_widget.dart';
import 'package:wafer/core/activity/widgets/activity_timeline_widget.dart';

Widget _wrapWithApp(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6)),
    ),
    home: Scaffold(body: child),
  );
}

void main() {
  group('ActivityLogItemWidget', () {
    testWidgets('renders action title, notes and metadata', (tester) async {
      final log = ActivityLogEntity.inferred(
        id: '1',
        action: 'created',
        notes: 'Maintenance request opened',
        createdAt: '2026-08-17 10:30',
        newStatus: 'new',
        performedByName: 'John Doe',
      );

      await tester.pumpWidget(
        _wrapWithApp(
          ActivityLogItemWidget(log: log),
        ),
      );

      expect(find.text('Maintenance request opened'), findsOneWidget);
      expect(find.text('2026-08-17 10:30'), findsOneWidget);
      expect(find.byType(ActivityLogItemWidget), findsOneWidget);
    });
  });

  group('ActivityTimelineWidget', () {
    testWidgets('renders empty state when activities list is empty', (tester) async {
      await tester.pumpWidget(
        _wrapWithApp(
          const ActivityTimelineWidget(
            activities: [],
            emptyTitle: 'No Activities',
          ),
        ),
      );

      expect(find.text('No Activities'), findsOneWidget);
    });

    testWidgets('renders items when activities list is not empty', (tester) async {
      final activities = [
        ActivityLogEntity.inferred(
          id: '1',
          action: 'created',
          notes: 'Contract draft created',
        ),
        ActivityLogEntity.inferred(
          id: '2',
          action: 'approved',
          notes: 'Contract signed by owner',
        ),
      ];

      await tester.pumpWidget(
        _wrapWithApp(
          ActivityTimelineWidget(activities: activities),
        ),
      );

      expect(find.text('Contract draft created'), findsOneWidget);
      expect(find.text('Contract signed by owner'), findsOneWidget);
      expect(find.byType(ActivityLogItemWidget), findsNWidgets(2));
    });
  });
}
