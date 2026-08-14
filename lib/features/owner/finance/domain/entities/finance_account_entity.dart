import 'package:equatable/equatable.dart';
import 'finance_account_type.dart';

class FinanceAccountEntity extends Equatable {
  final int id;
  final int? parentId;
  final String code;
  final String nameAr;
  final String nameEn;
  final FinanceAccountType type;
  final String? systemCode;
  final bool isPostable;
  final int level;
  final String? descriptionAr;
  final bool isActive;

  const FinanceAccountEntity({
    required this.id,
    this.parentId,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.type,
    this.systemCode,
    required this.isPostable,
    required this.level,
    this.descriptionAr,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
        id,
        parentId,
        code,
        nameAr,
        nameEn,
        type,
        systemCode,
        isPostable,
        level,
        descriptionAr,
        isActive,
      ];
}
