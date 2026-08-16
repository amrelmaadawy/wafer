import '../../domain/entities/unit_full_details_entity.dart';
import '../../../maintenance/data/models/maintenance_item_model.dart';
import 'media_item_model.dart';
import 'unit_contracts_parser.dart';

part 'unit_full_details_model_parser.dart';

class UnitTenantModel extends UnitTenantEntity {
  const UnitTenantModel({
    required super.id,
    required super.name,
    super.phone,
    super.email,
  });

  factory UnitTenantModel.fromJson(Map<String, dynamic> json) {
    return UnitTenantModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
    );
  }
}

class UnitFullDetailsModel extends UnitFullDetailsEntity {
  const UnitFullDetailsModel({
    required super.id,
    super.propertyId,
    super.propertyName,
    super.name,
    required super.unitNumber,
    super.code,
    super.type,
    super.typeLabel,
    required super.status,
    super.statusLabel,
    super.usageType,
    super.purpose,
    super.purposeLabel,
    super.floorType,
    super.floor,
    super.area,
    super.length,
    super.width,
    super.height,
    super.facadeLength,
    super.direction,
    super.isFurnished,
    super.finishingType,
    super.description,
    super.meters = const UnitMetersEntity(),
    super.amenities = const [],
    super.images = const [],
    super.videos = const [],
    super.attachments = const [],
    super.documents = const [],
    super.media = const MediaDetailsModel(),
    super.maintenanceRequests = const [],
    super.roomsCount,
    super.bathroomsCount,
    super.hallsCount,
    super.kitchensCount,
    super.entrancesCount,
    required super.rentPrice,
    super.monthlyPrice,
    super.perTwoPaymentsPrice,
    super.quarterlyPrice,
    super.currentContract,
    super.currentTenant,
    super.contractsHistory,
  });

  factory UnitFullDetailsModel.fromJson(Map<String, dynamic> json) =>
      parseUnitFullDetails(json);
}
