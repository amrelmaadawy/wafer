import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/reports/data/models/employee_tasks_report_model.dart';

void main() {
  group('EmployeeTasksReportModel', () {
    test('parses numeric strings into typed workload values', () {
      final model = EmployeeTasksReportModel.fromJson({
        'summary': {
          'total_employees': '2',
          'total_completed': '8',
          'total_pending': 3,
          'total_overdue': '1',
        },
        'items': [
          {
            'id': '7',
            'name': 'Team member',
            'email': 123,
            'phone': '0500000000',
            'completed_tasks': '5',
            'pending_tasks': 2,
            'overdue_tasks': '1',
          },
        ],
        'pagination': {
          'current_page': '1',
          'last_page': 1,
          'per_page': 15,
          'total': '1',
        },
      });

      expect(model.summary.totalEmployees, 2);
      expect(model.summary.totalCompleted, 8);
      expect(model.items.single.id, 7);
      expect(model.items.single.email, '123');
      expect(model.items.single.completedTasks, 5);
      expect(model.pagination.total, 1);
    });

    test('ignores malformed items safely', () {
      final model = EmployeeTasksReportModel.fromJson({
        'items': ['invalid', null, false],
      });

      expect(model.items, isEmpty);
    });

    test('uses safe defaults for malformed nested objects', () {
      final model = EmployeeTasksReportModel.fromJson({
        'summary': 'invalid',
        'pagination': false,
      });

      expect(model.summary.totalEmployees, 0);
      expect(model.pagination.total, 0);
    });
  });
}
