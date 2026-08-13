import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/properties/domain/entities/properties_query_filter_entity.dart';

void main() {
  group('PropertiesQueryFilterEntity', () {
    test('toQueryParams should not include sortBy and sortAscending', () {
      const filter = PropertiesQueryFilterEntity(
        sortBy: 'name',
        sortAscending: true,
        status: 'published',
        propertyType: 'villa',
      );

      final params = filter.toQueryParams();

      expect(params.containsKey('sort_by'), isFalse);
      expect(params.containsKey('sort_ascending'), isFalse);
      expect(params['status'], 'published');
      expect(params['property_type'], 'villa');
    });

    test('toQueryParams should only include non-null fields', () {
      const filter = PropertiesQueryFilterEntity(
        status: 'published',
      );

      final params = filter.toQueryParams();

      expect(params.keys.length, 4);
      expect(params['status'], 'published');
      expect(params['page'], 1);
      expect(params['per_page'], 15);
      expect(params['include_tree'], true);
      expect(params.containsKey('property_type'), isFalse);
    });
  });
}
