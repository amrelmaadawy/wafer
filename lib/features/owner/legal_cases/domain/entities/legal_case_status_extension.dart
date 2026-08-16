import '../../../../../core/constants/legal_case_status.dart';
import 'legal_case_item_entity.dart';

extension LegalCaseStatusExtension on LegalCaseItemEntity {
  String get statusValue => status?.toLowerCase().trim() ?? '';

  bool get isOpen => statusValue == LegalCaseStatus.open;

  bool get isInProgress => statusValue == LegalCaseStatus.inProgress;

  bool get isHearing => statusValue == LegalCaseStatus.hearing;

  bool get isResolved => statusValue == LegalCaseStatus.resolved;

  bool get isClosed => statusValue == LegalCaseStatus.closed;

  bool get isFinalized => isClosed || isResolved;

  bool get canEdit => [
        LegalCaseStatus.open,
        LegalCaseStatus.inProgress,
        LegalCaseStatus.hearing,
      ].contains(statusValue);

  bool get canDelete => statusValue == LegalCaseStatus.open;
}
