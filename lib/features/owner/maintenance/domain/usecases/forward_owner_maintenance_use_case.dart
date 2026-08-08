import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../repositories/owner_maintenance_repository.dart';

class ForwardOwnerMaintenanceUseCase {
  final OwnerMaintenanceRepository _repository;

  ForwardOwnerMaintenanceUseCase(this._repository);

  Future<Either<Failure, void>> call(ForwardOwnerMaintenanceParams params) async {
    return await _repository.forwardMaintenanceRequest(params);
  }
}

class ForwardOwnerMaintenanceParams extends Equatable {
  final int id;
  final String? notes;

  const ForwardOwnerMaintenanceParams({
    required this.id,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (notes != null && notes!.isNotEmpty) {
      data['notes'] = notes;
    }
    return data;
  }

  @override
  List<Object?> get props => [id, notes];
}
