import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/core/constants/legal_case_status.dart';
import 'package:wafer/features/owner/legal_cases/domain/entities/legal_case_item_entity.dart';
import 'package:wafer/features/owner/legal_cases/domain/entities/legal_case_status_extension.dart';

void main() {
  group('LegalCaseStatusExtension', () {
    test('open status enables edit and delete', () {
      const caseItem = LegalCaseItemEntity(id: 1, status: LegalCaseStatus.open);
      expect(caseItem.isOpen, isTrue);
      expect(caseItem.canEdit, isTrue);
      expect(caseItem.canDelete, isTrue);
      expect(caseItem.isFinalized, isFalse);
    });

    test('in_progress and hearing allow edit but not delete', () {
      const inProgressCase = LegalCaseItemEntity(id: 2, status: LegalCaseStatus.inProgress);
      expect(inProgressCase.isInProgress, isTrue);
      expect(inProgressCase.canEdit, isTrue);
      expect(inProgressCase.canDelete, isFalse);

      const hearingCase = LegalCaseItemEntity(id: 3, status: LegalCaseStatus.hearing);
      expect(hearingCase.isHearing, isTrue);
      expect(hearingCase.canEdit, isTrue);
      expect(hearingCase.canDelete, isFalse);
    });

    test('resolved and closed are finalized, disable edit and delete', () {
      const resolvedCase = LegalCaseItemEntity(id: 4, status: LegalCaseStatus.resolved);
      expect(resolvedCase.isResolved, isTrue);
      expect(resolvedCase.isFinalized, isTrue);
      expect(resolvedCase.canEdit, isFalse);
      expect(resolvedCase.canDelete, isFalse);

      const closedCase = LegalCaseItemEntity(id: 5, status: LegalCaseStatus.closed);
      expect(closedCase.isClosed, isTrue);
      expect(closedCase.isFinalized, isTrue);
      expect(closedCase.canEdit, isFalse);
      expect(closedCase.canDelete, isFalse);
    });
  });
}
