import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/reports/data/models/activity_logs_report_model.dart';

void main() {
  test('parses numeric strings and confirmed activity fields', () {
    final model = ActivityLogsReportModel.fromJson({
      'summary': {
        'total_logs': '2',
        'creates': '1',
        'updates': 1,
        'deletes': null,
      },
      'items': [
        {
          'id': '9',
          'created_at': '2026-08-14',
          'user': {'id': '7', 'name': 'Owner', 'user_type': 'owner'},
          'type': 'property',
          'action': 'update',
          'message': 'Updated property',
          'description': 42,
          'ip_address': '127.0.0.1',
        },
      ],
      'pagination': {'current_page': '1', 'last_page': '2', 'total': '2'},
      'filter_options': {
        'types': ['property'],
        'actions': ['update'],
      },
    });

    expect(model.summary.totalLogs, 2);
    expect(model.items.single.id, 9);
    expect(model.items.single.user.id, 7);
    expect(model.items.single.description, '42');
    expect(model.pagination.lastPage, 2);
    expect(model.types, ['property']);
    expect(model.actions, ['update']);
  });

  test('ignores malformed activity items and filter values safely', () {
    final model = ActivityLogsReportModel.fromJson({
      'items': [null, 'bad', 3, {}],
      'filter_options': {
        'types': [null, '', 'contract'],
        'actions': 'invalid',
      },
    });

    expect(model.items, hasLength(1));
    expect(model.items.single.id, 0);
    expect(model.types, ['contract']);
    expect(model.actions, isEmpty);
  });
}
