import '../../domain/entities/finance_account_entity.dart';

class FinanceAccountModel extends FinanceAccountEntity {
  const FinanceAccountModel({
    required super.id,
    super.parentId,
    required super.code,
    required super.nameAr,
    required super.nameEn,
    required super.type,
    super.systemCode,
    required super.isPostable,
    required super.level,
    super.descriptionAr,
    required super.isActive,
  });

  factory FinanceAccountModel.fromJson(Map<String, dynamic> json) {
    return FinanceAccountModel(
      id: json['id'] ?? 0,
      parentId: json['parent_id'],
      code: json['code'] ?? '',
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      type: json['type'] ?? '',
      systemCode: json['system_code'],
      isPostable: json['is_postable'] ?? false,
      level: json['level'] ?? 1,
      descriptionAr: json['description_ar'],
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'code': code,
      'name_ar': nameAr,
      'name_en': nameEn,
      'type': type,
      'system_code': systemCode,
      'is_postable': isPostable,
      'level': level,
      'description_ar': descriptionAr,
      'is_active': isActive,
    };
  }
}
