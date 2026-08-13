import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/features/owner/properties/domain/entities/properties_pagination_meta_entity.dart';
import 'package:wafer/features/owner/properties/domain/entities/properties_query_filter_entity.dart';
import 'package:wafer/features/owner/properties/domain/entities/properties_stats_entity.dart';
import 'package:wafer/features/owner/properties/domain/entities/property_list_item_entity.dart';
import 'package:wafer/features/owner/properties/domain/usecases/get_properties_list_use_case.dart';
import 'package:wafer/features/owner/properties/presentation/cubit/list/properties_list_cubit.dart';

class _MockGetProperties extends Mock implements GetPropertiesListUseCase {}

void main() {
  const meta = PropertiesPaginationMetaEntity(
    currentPage: 1,
    lastPage: 1,
    perPage: 15,
    total: 1,
  );
  const stats = PropertiesStatsEntity(
    totalProperties: 1,
    landsCount: 0,
    buildingsCount: 1,
    residentialCount: 1,
    commercialCount: 0,
    mixedCount: 0,
    totalUnits: 1,
    totalDeeds: 1,
  );
  const item = PropertyListItemEntity(
    id: 1,
    name: 'Property',
    code: 'P-1',
    status: 'published',
    statusLabel: 'Published',
    propertyType: 'building',
    unitsCount: 1,
    availableUnits: 1,
    rentedUnits: 0,
    occupancyRate: 0,
  );

  setUpAll(() {
    registerFallbackValue(const PropertiesQueryFilterEntity());
  });

  test('advanced server filter triggers a fresh request', () async {
    final getProperties = _MockGetProperties();
    when(() => getProperties(filter: any(named: 'filter'))).thenAnswer(
      (_) async => const Right((items: [item], meta: meta, stats: stats)),
    );
    final cubit = PropertiesListCubit(getProperties);

    await cubit.getProperties();
    const filter = PropertiesQueryFilterEntity(
      propertyType: 'building',
      branchId: 4,
    );
    await cubit.applyAdvancedFilter(filter);

    verify(
      () => getProperties(
        filter: any(
          named: 'filter',
          that: isA<PropertiesQueryFilterEntity>()
              .having((value) => value.propertyType, 'propertyType', 'building')
              .having((value) => value.branchId, 'branchId', 4),
        ),
      ),
    ).called(1);
    await cubit.close();
  });
}
