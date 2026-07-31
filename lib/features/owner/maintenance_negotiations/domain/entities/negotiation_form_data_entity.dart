import 'package:equatable/equatable.dart';

class NegotiationFormDataEntity extends Equatable {
  final NegotiationUserEntity? owner;
  final NegotiationEntity? currentNegotiation;
  final NegotiationDefaultsEntity? defaults;
  final NegotiationValidationEntity? validation;

  const NegotiationFormDataEntity({
    this.owner,
    this.currentNegotiation,
    this.defaults,
    this.validation,
  });

  @override
  List<Object?> get props => [owner, currentNegotiation, defaults, validation];
}

class NegotiationUserEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? tenantCode;
  final String? userType;

  const NegotiationUserEntity({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.tenantCode,
    this.userType,
  });

  @override
  List<Object?> get props => [id, name, email, phone, tenantCode, userType];
}

class NegotiationEntity extends Equatable {
  final int id;
  final NegotiationUserEntity? owner;
  final num approvalLimit;
  final bool isActive;
  final NegotiationUserEntity? createdBy;
  final NegotiationUserEntity? updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NegotiationEntity({
    required this.id,
    this.owner,
    required this.approvalLimit,
    required this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        owner,
        approvalLimit,
        isActive,
        createdBy,
        updatedBy,
        createdAt,
        updatedAt,
      ];
}

class NegotiationDefaultsEntity extends Equatable {
  final int ownerId;
  final num approvalLimit;
  final bool isActive;

  const NegotiationDefaultsEntity({
    required this.ownerId,
    required this.approvalLimit,
    required this.isActive,
  });

  @override
  List<Object?> get props => [ownerId, approvalLimit, isActive];
}

class NegotiationValidationEntity extends Equatable {
  final List<String> requiredFields;
  final num? approvalLimitMin;

  const NegotiationValidationEntity({
    required this.requiredFields,
    this.approvalLimitMin,
  });

  @override
  List<Object?> get props => [requiredFields, approvalLimitMin];
}
