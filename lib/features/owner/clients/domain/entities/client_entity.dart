import 'package:equatable/equatable.dart';

class ClientEntity extends Equatable {
  final int id;
  final String name;
  final String? username;
  final String? email;
  final String? phone;
  final String? identityNumber;
  final String? identityExpiry;
  final String? gender;
  final String? genderLabel;
  final String? clientType;
  final String? clientTypeLabel;
  final String? tenantCode;
  final bool isTenantAdmin;
  final bool isActive;
  final String status;
  final String statusLabel;
  final String? jobRank;
  final List<dynamic> jobRankIds;
  final String? jobRankNames;
  final List<dynamic> roles;
  final int propertiesCount;
  final int contractsCount;
  final int? glAccountId;
  final String createdAt;
  final String updatedAt;

  const ClientEntity({
    required this.id,
    required this.name,
    this.username,
    this.email,
    this.phone,
    this.identityNumber,
    this.identityExpiry,
    this.gender,
    this.genderLabel,
    this.clientType,
    this.clientTypeLabel,
    this.tenantCode,
    required this.isTenantAdmin,
    required this.isActive,
    required this.status,
    required this.statusLabel,
    this.jobRank,
    this.jobRankIds = const [],
    this.jobRankNames,
    this.roles = const [],
    required this.propertiesCount,
    required this.contractsCount,
    this.glAccountId,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        username,
        email,
        phone,
        identityNumber,
        identityExpiry,
        gender,
        genderLabel,
        clientType,
        clientTypeLabel,
        tenantCode,
        isTenantAdmin,
        isActive,
        status,
        statusLabel,
        jobRank,
        jobRankIds,
        jobRankNames,
        roles,
        propertiesCount,
        contractsCount,
        glAccountId,
        createdAt,
        updatedAt,
      ];
}
