import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/finance_account_entity.dart';
import '../repositories/finance_repository.dart';

class CreateFinanceAccountParams extends Equatable {
  final int? parentId;
  final String code;
  final String nameAr;
  final String nameEn;
  final String type;
  final bool isPostable;
  final bool isActive;
  final String? descriptionAr;

  const CreateFinanceAccountParams({
    this.parentId,
    required this.code,
    required this.nameAr,
    required this.nameEn,
    required this.type,
    required this.isPostable,
    required this.isActive,
    this.descriptionAr,
  });

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      'code': code,
      'name_ar': nameAr,
      'name_en': nameEn,
      'type': type,
      'is_postable': isPostable,
      'is_active': isActive,
      if (descriptionAr != null && descriptionAr!.isNotEmpty)
        'description_ar': descriptionAr,
    };
  }

  @override
  List<Object?> get props => [
        parentId,
        code,
        nameAr,
        nameEn,
        type,
        isPostable,
        isActive,
        descriptionAr,
      ];
}

class CreateFinanceAccountUseCase {
  final FinanceRepository repository;

  CreateFinanceAccountUseCase(this.repository);

  Future<Either<Failure, FinanceAccountEntity>> call(CreateFinanceAccountParams params) async {
    return await repository.createAccount(params);
  }
}
