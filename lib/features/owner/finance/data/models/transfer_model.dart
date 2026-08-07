import '../../domain/entities/transfer_entity.dart';

class TransferModel extends TransferEntity {
  const TransferModel({
    required super.id,
    required super.transferNumber,
    required super.transferDate,
    required super.amount,
    super.fromAccount,
    super.toAccount,
    super.referenceNumber,
    required super.status,
    super.notes,
    super.createdAt,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['id'] as int,
      transferNumber: json['transfer_number'] as String,
      transferDate: json['transfer_date'] as String,
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      fromAccount: json['from_account'] != null
          ? TransferAccountModel.fromJson(json['from_account'])
          : null,
      toAccount: json['to_account'] != null
          ? TransferAccountModel.fromJson(json['to_account'])
          : null,
      referenceNumber: json['reference_number'] as String?,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}

class TransferAccountModel extends TransferAccountEntity {
  const TransferAccountModel({
    required super.id,
    required super.code,
    required super.nameAr,
    required super.nameEn,
    required super.type,
  });

  factory TransferAccountModel.fromJson(Map<String, dynamic> json) {
    return TransferAccountModel(
      id: json['id'] as int,
      code: json['code'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      type: json['type'] as String,
    );
  }
}
