import '../../domain/entities/finance_account_type.dart';
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

  factory FinanceAccountModel.fromJson(dynamic json) {
    if (json == null || json is! Map) {
      throw const FormatException('Invalid or missing account data');
    }

    final id = _parseInt(json['id']);
    if (id == null || id == 0) {
      throw const FormatException('Missing or invalid required field: id');
    }

    return FinanceAccountModel(
      id: id,
      parentId: _parseInt(json['parent_id']),
      code: json['code']?.toString() ?? '',
      nameAr: json['name_ar']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      type: FinanceAccountType.fromString(json['type']?.toString()),
      systemCode: json['system_code']?.toString(),
      isPostable: _parseBool(json['is_postable']),
      level: _parseInt(json['level']) ?? 1,
      descriptionAr: json['description_ar']?.toString(),
      isActive: _parseBool(json['is_active']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'code': code,
      'name_ar': nameAr,
      'name_en': nameEn,
      'type': type.value,
      'system_code': systemCode,
      'is_postable': isPostable,
      'level': level,
      'description_ar': descriptionAr,
      'is_active': isActive,
    };
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return false;
  }
}
