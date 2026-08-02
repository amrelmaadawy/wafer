import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../entities/legal_case_item_entity.dart';
import '../repositories/legal_cases_repository.dart';

class CreateLegalCaseParams extends Equatable {
  final String caseNumber;
  final int branchId;
  final int? propertyId;
  final int? unitId;
  final int? contractId;
  final int? invoiceId;
  final String court;
  final String circuit;
  final String plaintiff;
  final String defendant;
  final String lawyer;
  final String? lawyerPhone;
  final String? lawyerOffice;
  final String caseType;
  final double amount;
  final String hearingDate;
  final String status;
  final String? notes;

  const CreateLegalCaseParams({
    required this.caseNumber,
    required this.branchId,
    this.propertyId,
    this.unitId,
    this.contractId,
    this.invoiceId,
    required this.court,
    required this.circuit,
    required this.plaintiff,
    required this.defendant,
    required this.lawyer,
    this.lawyerPhone,
    this.lawyerOffice,
    required this.caseType,
    required this.amount,
    required this.hearingDate,
    required this.status,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'case_number': caseNumber,
      'branch_id': branchId,
      if (propertyId != null) 'property_id': propertyId,
      if (unitId != null) 'unit_id': unitId,
      if (contractId != null) 'contract_id': contractId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      'court': court,
      'circuit': circuit,
      'plaintiff': plaintiff,
      'defendant': defendant,
      'lawyer': lawyer,
      if (lawyerPhone != null) 'lawyer_phone': lawyerPhone,
      if (lawyerOffice != null) 'lawyer_office': lawyerOffice,
      'case_type': caseType,
      'amount': amount,
      'hearing_date': hearingDate,
      'status': status,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
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

class CreateLegalCaseUseCase {
  final LegalCasesRepository repository;

  CreateLegalCaseUseCase(this.repository);

  Future<Either<Failure, LegalCaseItemEntity>> call(
    CreateLegalCaseParams params,
  ) async {
    return await repository.createLegalCase(params);
  }
}
