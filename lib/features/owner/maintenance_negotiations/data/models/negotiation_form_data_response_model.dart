import '../../domain/entities/negotiation_form_data_entity.dart';

class NegotiationFormDataResponseModel {
  final bool success;
  final String message;
  final NegotiationFormDataModel data;

  NegotiationFormDataResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NegotiationFormDataResponseModel.fromJson(Map<String, dynamic> json) {
    return NegotiationFormDataResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: NegotiationFormDataModel.fromJson(json['data'] ?? {}),
    );
  }
}

class NegotiationFormDataModel extends NegotiationFormDataEntity {
  const NegotiationFormDataModel({
    super.owner,
    super.currentNegotiation,
    super.defaults,
    super.validation,
  });

  factory NegotiationFormDataModel.fromJson(Map<String, dynamic> json) {
    return NegotiationFormDataModel(
      owner: json['owner'] != null
          ? NegotiationUserModel.fromJson(json['owner'])
          : null,
      currentNegotiation: json['current_negotiation'] != null
          ? NegotiationModel.fromJson(json['current_negotiation'])
          : null,
      defaults: json['defaults'] != null
          ? NegotiationDefaultsModel.fromJson(json['defaults'])
          : null,
      validation: json['validation'] != null
          ? NegotiationValidationModel.fromJson(json['validation'])
          : null,
    );
  }
}

class NegotiationUserModel extends NegotiationUserEntity {
  const NegotiationUserModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    super.tenantCode,
    super.userType,
  });

  factory NegotiationUserModel.fromJson(Map<String, dynamic> json) {
    return NegotiationUserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      tenantCode: json['tenant_code']?.toString(),
      userType: json['user_type']?.toString(),
    );
  }
}

class NegotiationModel extends NegotiationEntity {
  const NegotiationModel({
    required super.id,
    super.owner,
    required super.approvalLimit,
    required super.isActive,
    super.createdBy,
    super.updatedBy,
    super.createdAt,
    super.updatedAt,
  });

  factory NegotiationModel.fromJson(Map<String, dynamic> json) {
    return NegotiationModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      owner: json['owner'] != null
          ? NegotiationUserModel.fromJson(json['owner'])
          : null,
      approvalLimit: json['approval_limit'] is num
          ? json['approval_limit']
          : num.tryParse(json['approval_limit']?.toString() ?? '0') ?? 0,
      isActive:
          json['is_active'] == true ||
          json['is_active'] == 1 ||
          json['is_active'] == '1',
      createdBy: json['created_by'] != null
          ? NegotiationUserModel.fromJson(json['created_by'])
          : null,
      updatedBy: json['updated_by'] != null
          ? NegotiationUserModel.fromJson(json['updated_by'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class NegotiationDefaultsModel extends NegotiationDefaultsEntity {
  const NegotiationDefaultsModel({
    required super.ownerId,
    required super.approvalLimit,
    required super.isActive,
  });

  factory NegotiationDefaultsModel.fromJson(Map<String, dynamic> json) {
    return NegotiationDefaultsModel(
      ownerId: json['owner_id'] is int
          ? json['owner_id']
          : int.tryParse(json['owner_id']?.toString() ?? '0') ?? 0,
      approvalLimit: json['approval_limit'] is num
          ? json['approval_limit']
          : num.tryParse(json['approval_limit']?.toString() ?? '0') ?? 0,
      isActive:
          json['is_active'] == true ||
          json['is_active'] == 1 ||
          json['is_active'] == '1',
    );
  }
}

class NegotiationValidationModel extends NegotiationValidationEntity {
  const NegotiationValidationModel({
    required super.requiredFields,
    super.approvalLimitMin,
  });

  factory NegotiationValidationModel.fromJson(Map<String, dynamic> json) {
    final requiredList =
        (json['required'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    num? minVal;
    if (json['approval_limit'] != null && json['approval_limit'] is Map) {
      final approvalLimitMap = json['approval_limit'] as Map;
      if (approvalLimitMap['min'] != null) {
        minVal = approvalLimitMap['min'] is num
            ? approvalLimitMap['min']
            : num.tryParse(approvalLimitMap['min'].toString());
      }
    }

    return NegotiationValidationModel(
      requiredFields: requiredList,
      approvalLimitMin: minVal,
    );
  }
}
