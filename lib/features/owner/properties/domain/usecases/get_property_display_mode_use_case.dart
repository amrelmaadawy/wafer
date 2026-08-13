import '../entities/property_display_mode.dart';
import '../repositories/property_display_preferences_repository.dart';

class GetPropertyDisplayModeUseCase {
  final PropertyDisplayPreferencesRepository _repository;

  const GetPropertyDisplayModeUseCase(this._repository);

  PropertyDisplayMode call() => _repository.getMode();
}
