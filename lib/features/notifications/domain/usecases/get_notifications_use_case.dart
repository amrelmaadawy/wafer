import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notifications_response_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsParams extends Equatable {
  final int page;
  final bool forceRefresh;

  const GetNotificationsParams({
    this.page = 1,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [page, forceRefresh];
}

class GetNotificationsUseCase implements UseCase<NotificationsResponseEntity, GetNotificationsParams> {
  final NotificationsRepository _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationsResponseEntity>> call(GetNotificationsParams params) {
    return _repository.getNotifications(
      page: params.page,
      forceRefresh: params.forceRefresh,
    );
  }
}
