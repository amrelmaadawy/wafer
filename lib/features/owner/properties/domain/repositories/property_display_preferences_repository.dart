import '../entities/property_display_mode.dart';

abstract class PropertyDisplayPreferencesRepository {
  PropertyDisplayMode getMode();
  Future<void> saveMode(PropertyDisplayMode mode);
}
