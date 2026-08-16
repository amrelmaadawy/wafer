import 'package:equatable/equatable.dart';

class BusinessRuleViolation extends Equatable {
  final String code;
  final String messageKey;
  final Map<String, String>? namedArgs;

  const BusinessRuleViolation({
    required this.code,
    required this.messageKey,
    this.namedArgs,
  });

  @override
  List<Object?> get props => [code, messageKey, namedArgs];

  @override
  String toString() => 'BusinessRuleViolation(code: $code, messageKey: $messageKey)';
}
