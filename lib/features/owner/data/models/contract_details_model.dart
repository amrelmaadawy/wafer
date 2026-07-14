import '../../domain/entities/contract_details_entity.dart';

class ContractDetailsModel extends ContractDetailsEntity {
  const ContractDetailsModel({
    required super.id,
    required super.contractNumber,
    required super.contractType,
    required super.propertyId,
    required super.propertyName,
    required super.unitId,
    required super.unitName,
    required super.renterId,
    required super.renterName,
    required super.renterPhone,
    required super.startDate,
    required super.endDate,
    required super.totalRentValue,
    required super.paymentCycle,
    required super.paymentCount,
    required super.securityDeposit,
    required super.status,
    required super.statusLabel,
    required super.statusBadge,
    required super.isEjarLinked,
  });

  factory ContractDetailsModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> target = json;

    if (json['data'] is Map<String, dynamic>) {
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap['contracts'] is Map<String, dynamic>) {
        final contractsMap = dataMap['contracts'] as Map<String, dynamic>;
        if (contractsMap['data'] is List && (contractsMap['data'] as List).isNotEmpty) {
          final firstItem = (contractsMap['data'] as List).first;
          if (firstItem is Map<String, dynamic>) target = firstItem;
        } else {
          target = contractsMap;
        }
      } else if (dataMap['contract'] is Map<String, dynamic>) {
        target = dataMap['contract'] as Map<String, dynamic>;
      } else if (dataMap['id'] != null || dataMap['contract_number'] != null) {
        target = dataMap;
      }
    } else if (json['contracts'] is Map<String, dynamic>) {
      final contractsMap = json['contracts'] as Map<String, dynamic>;
      if (contractsMap['data'] is List && (contractsMap['data'] as List).isNotEmpty) {
        final firstItem = (contractsMap['data'] as List).first;
        if (firstItem is Map<String, dynamic>) target = firstItem;
      }
    } else if (json['contract'] is Map<String, dynamic>) {
      target = json['contract'] as Map<String, dynamic>;
    }

    final id = (target['id'] ?? '').toString();
    final contractNumber = (target['contract_number'] ?? target['code'] ?? 'CNT-$id').toString();
    final contractType = (target['contract_type'] ?? 'residential').toString();

    // Property parsing
    String propId = '';
    String propName = 'عقار';
    if (target['property'] is Map<String, dynamic>) {
      final pMap = target['property'] as Map<String, dynamic>;
      propId = (pMap['id'] ?? '').toString();
      propName = (pMap['name'] ?? pMap['title'] ?? 'عقار').toString();
    } else if (target['property_name'] != null) {
      propName = target['property_name'].toString();
    }

    // Unit parsing
    String uId = '';
    String uName = 'وحدة';
    if (target['unit'] is Map<String, dynamic>) {
      final uMap = target['unit'] as Map<String, dynamic>;
      uId = (uMap['id'] ?? '').toString();
      uName = (uMap['name'] ?? uMap['unit_number'] ?? 'وحدة').toString();
    } else if (target['unit_name'] != null) {
      uName = target['unit_name'].toString();
    }

    // Renter/Tenant parsing
    String rId = '';
    String rName = 'مستأجر';
    String rPhone = '';
    if (target['renter'] is Map<String, dynamic>) {
      final rMap = target['renter'] as Map<String, dynamic>;
      rId = (rMap['id'] ?? '').toString();
      rName = (rMap['name'] ?? rMap['full_name'] ?? 'مستأجر').toString();
      rPhone = (rMap['phone'] ?? rMap['mobile'] ?? '').toString();
    } else if (target['tenant'] is Map<String, dynamic>) {
      final rMap = target['tenant'] as Map<String, dynamic>;
      rId = (rMap['id'] ?? '').toString();
      rName = (rMap['name'] ?? rMap['full_name'] ?? 'مستأجر').toString();
      rPhone = (rMap['phone'] ?? rMap['mobile'] ?? '').toString();
    }

    final startDate = (target['start_date'] ?? target['from_date'] ?? '').toString();
    final endDate = (target['end_date'] ?? target['to_date'] ?? '').toString();

    // Financial
    double totalRentValue = 0.0;
    String paymentCycle = 'monthly';
    int paymentCount = 1;
    double securityDeposit = 0.0;
    if (target['financial'] is Map<String, dynamic>) {
      final fMap = target['financial'] as Map<String, dynamic>;
      totalRentValue = double.tryParse((fMap['total_rent_value'] ?? fMap['rent_amount'] ?? 0).toString()) ?? 0.0;
      paymentCycle = (fMap['payment_cycle'] ?? 'monthly').toString();
      paymentCount = int.tryParse((fMap['payment_count'] ?? 1).toString()) ?? 1;
      securityDeposit = double.tryParse((fMap['security_deposit'] ?? 0).toString()) ?? 0.0;
    } else {
      totalRentValue = double.tryParse((target['total_rent_value'] ?? target['rent_amount'] ?? 0).toString()) ?? 0.0;
    }

    final status = (target['status'] ?? 'active').toString();
    final statusLabel = (target['status_label'] ?? status).toString();
    final statusBadge = (target['status_badge'] ?? '').toString();
    final isEjarLinked = target['is_ejar_linked'] == true || target['is_ejar_linked'] == 1 || target['is_ejar_linked'] == 'true';

    return ContractDetailsModel(
      id: id,
      contractNumber: contractNumber,
      contractType: contractType,
      propertyId: propId,
      propertyName: propName,
      unitId: uId,
      unitName: uName,
      renterId: rId,
      renterName: rName,
      renterPhone: rPhone,
      startDate: startDate,
      endDate: endDate,
      totalRentValue: totalRentValue,
      paymentCycle: paymentCycle,
      paymentCount: paymentCount,
      securityDeposit: securityDeposit,
      status: status,
      statusLabel: statusLabel,
      statusBadge: statusBadge,
      isEjarLinked: isEjarLinked,
    );
  }
}
