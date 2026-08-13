import '../../domain/entities/property_display_mode.dart';
import '../../domain/repositories/property_display_preferences_repository.dart';
import '../datasources/property_display_preferences_local_data_source.dart';

class PropertyDisplayPreferencesRepositoryImpl
    implements PropertyDisplayPreferencesRepository {
  final PropertyDisplayPreferencesLocalDataSource _localDataSource;

  const PropertyDisplayPreferencesRepositoryImpl(this._localDataSource);

  @override
  PropertyDisplayMode getMode() => _localDataSource.getMode();

  @override
  Future<void> saveMode(PropertyDisplayMode mode) {
    return _localDataSource.saveMode(mode);
  }
}
