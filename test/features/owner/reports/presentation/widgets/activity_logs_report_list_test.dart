import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/reports/domain/entities/activity_logs_item_entity.dart';
import 'package:wafer/features/owner/reports/domain/entities/activity_logs_user_entity.dart';
import 'package:wafer/features/owner/reports/presentation/widgets/activity_logs_report_list.dart';

const _item = ActivityLogsItemEntity(
  id: 1,
  createdAt: '2026-08-14',
  user: ActivityLogsUserEntity(id: 1, name: 'Owner', userType: 'owner'),
  type: 'property',
  action: 'update',
  message: 'Updated',
  ipAddress: '127.0.0.1',
);

void main() {
  testWidgets('uses responsive activity-card columns', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: Size(1200, 900)),
          child: Scaffold(
            body: ActivityLogsReportList(items: [_item, _item, _item]),
          ),
        ),
      ),
    );

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 3);
  });
}
