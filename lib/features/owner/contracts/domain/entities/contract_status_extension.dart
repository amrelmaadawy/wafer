import '../../../../../core/constants/contract_status.dart';
import 'contract_details_entity.dart';

extension ContractStatusExtension on ContractDetailsEntity {
  String get statusValue => status.toLowerCase().trim();

  bool get isDraft => statusValue == ContractStatus.draft;

  bool get isPending => statusValue == ContractStatus.pending;

  bool get isActive => statusValue == ContractStatus.active;

  bool get isExpiring => statusValue == ContractStatus.expiring;

  bool get isExpired => statusValue == ContractStatus.expired;

  bool get isTerminated => statusValue == ContractStatus.terminated;

  bool get canRequestRenewal => isExpiring || isExpired;

  bool get isEditable => isDraft || isPending;
}
