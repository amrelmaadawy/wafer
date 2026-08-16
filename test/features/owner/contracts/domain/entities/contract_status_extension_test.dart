import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/constants/contract_status.dart';
import 'package:wafer/features/owner/contracts/domain/entities/contract_details_entity.dart';
import 'package:wafer/features/owner/contracts/domain/entities/contract_status_extension.dart';

void main() {
  group('ContractStatusExtension', () {
    const baseContract = ContractDetailsEntity(
      id: '1',
      contractNumber: 'CNT-001',
      contractType: 'residential',
      propertyId: '1',
      propertyName: 'Tower',
      unitId: '1',
      unitName: '101',
      renterId: '1',
      renterName: 'Renter',
      renterPhone: '123',
      startDate: '2026-01-01',
      endDate: '2027-01-01',
      totalRentValue: 50000,
      paymentCycle: 'yearly',
      paymentCount: 1,
      securityDeposit: 2000,
      status: ContractStatus.active,
      statusLabel: 'Active',
      statusBadge: 'active',
      isEjarLinked: true,
    );

    test('active contract is active and not editable', () {
      expect(baseContract.isActive, isTrue);
      expect(baseContract.isEditable, isFalse);
      expect(baseContract.canRequestRenewal, isFalse);
    });

    test('draft and pending contracts are editable', () {
      final draft = baseContract.copyWithStatus(ContractStatus.draft);
      expect(draft.isDraft, isTrue);
      expect(draft.isEditable, isTrue);

      final pending = baseContract.copyWithStatus(ContractStatus.pending);
      expect(pending.isPending, isTrue);
      expect(pending.isEditable, isTrue);
    });

    test('expiring and expired contracts allow renewal request', () {
      final expiring = baseContract.copyWithStatus(ContractStatus.expiring);
      expect(expiring.isExpiring, isTrue);
      expect(expiring.canRequestRenewal, isTrue);

      final expired = baseContract.copyWithStatus(ContractStatus.expired);
      expect(expired.isExpired, isTrue);
      expect(expired.canRequestRenewal, isTrue);
    });
  });
}

extension on ContractDetailsEntity {
  ContractDetailsEntity copyWithStatus(String newStatus) {
    return ContractDetailsEntity(
      id: id,
      contractNumber: contractNumber,
      contractType: contractType,
      propertyId: propertyId,
      propertyName: propertyName,
      unitId: unitId,
      unitName: unitName,
      renterId: renterId,
      renterName: renterName,
      renterPhone: renterPhone,
      startDate: startDate,
      endDate: endDate,
      totalRentValue: totalRentValue,
      paymentCycle: paymentCycle,
      paymentCount: paymentCount,
      securityDeposit: securityDeposit,
      status: newStatus,
      statusLabel: newStatus,
      statusBadge: newStatus,
      isEjarLinked: isEjarLinked,
    );
  }
}
