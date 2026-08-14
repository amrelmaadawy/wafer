import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/reports/data/models/units_status_report_model.dart';

void main() {
  group('UnitsStatusReportModel', () {
    test('parses numeric strings and typed unit references', () {
      final model = UnitsStatusReportModel.fromJson({
        'summary': {'total': '4', 'vacant': 1, 'rented': '2', 'maintenance': 1},
        'items': [
          {
            'id': '8',
            'unit_number': 12,
            'name': 'Unit 12',
            'code': 'U-12',
            'property': {'id': '3', 'name': 'Tower', 'code': 'P-3'},
            'floor_number': '5',
            'status': 'vacant',
            'status_label': 'Vacant',
          },
        ],
        'pagination': {
          'current_page': 1,
          'last_page': 1,
          'per_page': 15,
          'total': 1,
          'from': 1,
          'to': 1,
        },
        'filter_options': {
          'statuses': [
            {'value': 'vacant', 'label': 'Vacant'},
          ],
          'properties': [
            {'id': '3', 'name': 'Tower', 'code': 'P-3'},
          ],
        },
      });

      expect(model.summary.total, 4);
      expect(model.items.single.id, 8);
      expect(model.items.single.property.id, 3);
      expect(model.items.single.floorNumber, 5);
      expect(model.filterOptions.properties.single.id, 3);
    });

    test('ignores malformed list entries safely', () {
      final model = UnitsStatusReportModel.fromJson({
        'items': ['invalid', null],
        'filter_options': {
          'statuses': [false],
          'properties': ['invalid'],
        },
      });

      expect(model.items, isEmpty);
      expect(model.filterOptions.statuses, isEmpty);
      expect(model.filterOptions.properties, isEmpty);
    });

    test('uses safe defaults for malformed nested objects', () {
      final model = UnitsStatusReportModel.fromJson({
        'summary': 'invalid',
        'pagination': false,
        'filter_options': null,
      });

      expect(model.summary.total, 0);
      expect(model.pagination.total, 0);
      expect(model.items, isEmpty);
    });
  });
}
