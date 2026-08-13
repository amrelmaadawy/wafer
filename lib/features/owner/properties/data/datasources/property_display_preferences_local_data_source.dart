import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/property_display_mode.dart';

abstract class PropertyDisplayPreferencesLocalDataSource {
  PropertyDisplayMode getMode();
  Future<void> saveMode(PropertyDisplayMode mode);
}

class PropertyDisplayPreferencesLocalDataSourceImpl
    implements PropertyDisplayPreferencesLocalDataSource {
  static const _modeKey = 'owner_properties_display_mode';

  final SharedPreferences _preferences;

  const PropertyDisplayPreferencesLocalDataSourceImpl(this._preferences);

  @override
  PropertyDisplayMode getMode() {
    return PropertyDisplayModeStorage.fromStorage(
      _preferences.getString(_modeKey),
    );
  }

  @override
  Future<void> saveMode(PropertyDisplayMode mode) async {
    await _preferences.setString(_modeKey, mode.storageValue);
  }
}
