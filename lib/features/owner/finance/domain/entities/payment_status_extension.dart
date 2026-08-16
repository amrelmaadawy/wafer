import '../../../../../core/constants/payment_status.dart';
import 'payment_entity.dart';

extension PaymentStatusExtension on PaymentEntity {
  String get statusValue => status.toLowerCase().trim();

  bool get isDraft => statusValue == PaymentStatus.draft;

  bool get isPending => statusValue == PaymentStatus.pending;

  bool get isApproved => statusValue == PaymentStatus.approved;

  bool get isPaid => statusValue == PaymentStatus.paid;

  bool get isReconciled => statusValue == PaymentStatus.reconciled;

  bool get isReversed => statusValue == PaymentStatus.reversed;

  bool get isFinalized => isPaid || isReconciled || isReversed;

  bool get canEdit => [
        PaymentStatus.draft,
        PaymentStatus.pending,
      ].contains(statusValue);

  bool get canDelete => [
        PaymentStatus.draft,
        PaymentStatus.pending,
      ].contains(statusValue);

  bool get canCancel => [
        PaymentStatus.draft,
        PaymentStatus.pending,
        PaymentStatus.approved,
      ].contains(statusValue);

  bool get canReverse => isPaid;
}
