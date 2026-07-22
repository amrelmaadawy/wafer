import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/properties_repository.dart';

class UploadTempFileUseCase {
  final PropertiesRepository _repository;

  UploadTempFileUseCase(this._repository);

  Future<Either<Failure, String>> call(String filePath) {
    return _repository.uploadTempFile(filePath);
  }
}
