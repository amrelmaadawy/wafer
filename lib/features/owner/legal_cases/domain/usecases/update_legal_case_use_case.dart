import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/legal_case_item_entity.dart';
import '../repositories/legal_cases_repository.dart';

class UpdateLegalCaseParams extends Equatable {
  final int id;
  final String? caseNumber;
  final int? branchId;
  final int? propertyId;
  final int? unitId;
  final int? contractId;
  final int? invoiceId;
  final String? court;
  final String? circuit;
  final String? plaintiff;
  final String? defendant;
  final String? lawyer;
  final String? lawyerPhone;
  final String? lawyerOffice;
  final String? caseType;
  final double? amount;
  final String? hearingDate;
  final String? status;
  final String? notes;

  const UpdateLegalCaseParams({
    required this.id,
    this.caseNumber,
    this.branchId,
    this.propertyId,
    this.unitId,
    this.contractId,
    this.invoiceId,
    this.court,
    this.circuit,
    this.plaintiff,
    this.defendant,
    this.lawyer,
    this.lawyerPhone,
    this.lawyerOffice,
    this.caseType,
    this.amount,
    this.hearingDate,
    this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (caseNumber != null) data['case_number'] = caseNumber;
    if (branchId != null) data['branch_id'] = branchId;
    if (propertyId != null) data['property_id'] = propertyId;
    if (unitId != null) data['unit_id'] = unitId;
    if (contractId != null) data['contract_id'] = contractId;
    if (invoiceId != null) data['invoice_id'] = invoiceId;
    if (court != null) data['court'] = court;
    if (circuit != null) data['circuit'] = circuit;
    if (plaintiff != null) data['plaintiff'] = plaintiff;
    if (defendant != null) data['defendant'] = defendant;
    if (lawyer != null) data['lawyer'] = lawyer;
    if (lawyerPhone != null) data['lawyer_phone'] = lawyerPhone;
    if (lawyerOffice != null) data['lawyer_office'] = lawyerOffice;
    if (caseType != null) data['case_type'] = caseType;
    if (amount != null) data['amount'] = amount;
    if (hearingDate != null) data['hearing_date'] = hearingDate;
    if (status != null) data['status'] = status;
    if (notes != null) data['notes'] = notes;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        caseNumber,
        branchId,
        propertyId,
        unitId,
        contractId,
        invoiceId,
        court,
        circuit,
        plaintiff,
        defendant,
        lawyer,
        lawyerPhone,
        lawyerOffice,
        caseType,
        amount,
        hearingDate,
        status,
        notes,
      ];
}

class UpdateLegalCaseUseCase
    implements UseCase<LegalCaseItemEntity, UpdateLegalCaseParams> {
  final LegalCasesRepository repository;

  UpdateLegalCaseUseCase(this.repository);

  @override
  Future<Either<Failure, LegalCaseItemEntity>> call(
      UpdateLegalCaseParams params) async {
    return await repository.updateLegalCase(params);
  }
}
