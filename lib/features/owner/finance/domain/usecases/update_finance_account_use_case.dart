import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/error/failures.dart';
import '../entities/finance_account_entity.dart';
import '../repositories/finance_repository.dart';

class UpdateFinanceAccountUseCase {
  final FinanceRepository repository;

  UpdateFinanceAccountUseCase(this.repository);

  Future<Either<Failure, FinanceAccountEntity>> call(
    UpdateFinanceAccountParams params,
  ) async {
    return await repository.updateAccount(params);
  }
}

class UpdateFinanceAccountParams extends Equatable {
  final int id;
  final String? code;
  final String? nameAr;
  final String? nameEn;
  final String? type;
  final bool? isPostable;
  final bool? isActive;
  final String? descriptionAr;
  final int? parentId;

  const UpdateFinanceAccountParams({
    required this.id,
    this.code,
    this.nameAr,
    this.nameEn,
    this.type,
    this.isPostable,
    this.isActive,
    this.descriptionAr,
    this.parentId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (code != null) data['code'] = code;
    if (nameAr != null) data['name_ar'] = nameAr;
    if (nameEn != null) data['name_en'] = nameEn;
    if (type != null) data['type'] = type;
    if (isPostable != null) data['is_postable'] = isPostable;
    if (isActive != null) data['is_active'] = isActive;
    if (descriptionAr != null) data['description_ar'] = descriptionAr;
    if (parentId != null) data['parent_id'] = parentId;
    return data;
  }

  @override
  List<Object?> get props => [
        id,
        code,
        nameAr,
        nameEn,
        type,
        isPostable,
        isActive,
        descriptionAr,
        parentId,
      ];
}
