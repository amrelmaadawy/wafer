import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/tasks_repository.dart';

class DeleteTaskUseCase {
  final TasksRepository repository;

  DeleteTaskUseCase({required this.repository});

  Future<Either<Failure, void>> call({required int id}) async {
    return await repository.deleteTask(id);
  }
}
