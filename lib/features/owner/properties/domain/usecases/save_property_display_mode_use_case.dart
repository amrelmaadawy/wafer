import '../entities/property_display_mode.dart';
import '../repositories/property_display_preferences_repository.dart';

class SavePropertyDisplayModeUseCase {
  final PropertyDisplayPreferencesRepository _repository;

  const SavePropertyDisplayModeUseCase(this._repository);

  Future<void> call(PropertyDisplayMode mode) => _repository.saveMode(mode);
}
