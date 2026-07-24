import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/properties_pagination_meta_entity.dart';
import '../entities/properties_query_filter_entity.dart';
import '../entities/properties_stats_entity.dart';
import '../entities/property_details_entity.dart';
import '../entities/property_form_data_entity.dart';
import '../entities/property_list_item_entity.dart';

abstract class PropertiesRepository {
  /// Fetch list of properties with filter query, pagination page, and stats banner
  Future<
      Either<
          Failure,
          ({
            List<PropertyListItemEntity> items,
            PropertiesPaginationMetaEntity meta,
            PropertiesStatsEntity stats,
          })>> getProperties({
    PropertiesQueryFilterEntity? filter,
  });

  /// Fetch form data (types, options, dropdown values)
  Future<Either<Failure, PropertyFormOptionsEntity>> getFormOptions();

  /// Fetch full property form metadata (steps, options, defaults, endpoints)
  Future<Either<Failure, PropertyFormDataEntity>> getPropertyFormData();

  /// Fetch full property details by ID
  Future<Either<Failure, PropertyDetailsEntity>> getPropertyDetails(int propertyId);

  /// Create draft property (returns draft property ID)
  Future<Either<Failure, int>> createDraftProperty(Map<String, dynamic> body);

  /// Auto save a step of the property wizard
  Future<Either<Failure, void>> autoSavePropertyStep({
    required int propertyId,
    required String step,
    required Map<String, dynamic> data,
  });

  /// Auto save deed step
  Future<Either<Failure, PropertyDetailsEntity>> autoSaveDeedStep(int propertyId, int deedId, int branchId);

  /// Auto save type step
  Future<Either<Failure, PropertyDetailsEntity>> autoSaveTypeStep(int propertyId, String propertyType);



  /// Sync property owners (percentage must equal 100%)
  Future<Either<Failure, void>> syncOwners(
    int propertyId,
    List<Map<String, dynamic>> owners,
  );

  /// Upload temp image file (returns temp file path)
  Future<Either<Failure, String>> uploadTempFile(String filePath);

  /// Add uploaded image path to draft property
  Future<Either<Failure, void>> addUploadedImagePath(
    int propertyId,
    String imagePath,
  );

  /// Publish property
  Future<Either<Failure, void>> publishProperty(int propertyId);

  /// Clone property (returns new property ID)
  Future<Either<Failure, int>> cloneProperty(int propertyId);

  /// Make representative
  Future<Either<Failure, void>> makeRepresentative(int propertyId, Map<String, dynamic> body);

  /// Remove representative
  Future<Either<Failure, void>> removeRepresentative(int propertyId);

  /// Delete property
  Future<Either<Failure, void>> deleteProperty(int propertyId);

  /// Patch / edit property
  Future<Either<Failure, void>> patchProperty(int propertyId, Map<String, dynamic> data);
}
