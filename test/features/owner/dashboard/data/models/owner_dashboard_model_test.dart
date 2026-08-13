import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/dashboard/data/models/owner_dashboard_model.dart';

void main() {
  group('OwnerDashboardModel', () {
    test('parses numeric strings and nested typed metrics safely', () {
      final model = OwnerDashboardModel.fromJson({
        'total_properties': '4',
        'total_units': 10.0,
        'total_revenue': '12500.50',
        'occupancy_rate': '70.5',
        'installment_stats': {
          'paid': '3',
          'partially_paid': 1,
          'unpaid': 2,
          'overdue': 1,
        },
        'maintenance_breakdown': {'new': '2', 'in_progress': 1, 'urgent': '1'},
      });

      expect(model.totalProperties, 4);
      expect(model.totalUnits, 10);
      expect(model.totalRevenue, 12500.5);
      expect(model.occupancyRate, 70.5);
      expect(model.installmentStats?.paid, 3);
      expect(model.maintenanceBreakdown?.urgent, 1);
    });

    test('ignores malformed collections instead of throwing', () {
      final model = OwnerDashboardModel.fromJson({
        'recent_receipts': 'invalid',
        'latest_overdue_installments': [null, 'invalid'],
      });

      expect(model.recentReceipts, isEmpty);
      expect(model.latestOverdueInstallments, isEmpty);
    });

    test('supports tenant alias in overdue installment contracts', () {
      final model = OwnerDashboardModel.fromJson({
        'latest_overdue_installments': [
          {
            'id': '7',
            'amount': '900',
            'contract': {
              'tenant': {'full_name': 'Tenant Name'},
              'unit': {'unit_number': 'B-2'},
            },
          },
        ],
      });

      final item = model.latestOverdueInstallments.single;
      expect(item.id, 7);
      expect(item.tenantName, 'Tenant Name');
      expect(item.unitName, 'B-2');
    });
  });
}
