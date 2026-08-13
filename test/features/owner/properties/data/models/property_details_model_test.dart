import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/properties/data/models/property_details_model.dart';

void main() {
  group('PropertyDetailsModel', () {
    test('fromJson should handle missing status_label and property_type gracefully (return null)', () {
      final json = {
        'id': 1,
        'name': 'Test Property',
        'code': 'P-001',
        'status': 'draft',
      };

      final model = PropertyDetailsModel.fromJson(json);

      expect(model.statusLabel, isNull);
      expect(model.propertyType, isNull);
      expect(model.status, 'draft');
    });

    test('fromJson should parse status_label and property_type when present', () {
      final json = {
        'id': 1,
        'name': 'Test Property',
        'code': 'P-001',
        'status_label': 'منشور',
        'property_type': 'فيلا',
      };

      final model = PropertyDetailsModel.fromJson(json);

      expect(model.statusLabel, 'منشور');
      expect(model.propertyType, 'فيلا');
    });
  });
}
