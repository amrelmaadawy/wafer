import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wafer/features/owner/properties/data/datasources/property_display_preferences_local_data_source.dart';
import 'package:wafer/features/owner/properties/data/repositories/property_display_preferences_repository_impl.dart';
import 'package:wafer/features/owner/properties/domain/entities/property_display_mode.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('uses comfortable mode when no preference is stored', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = PropertyDisplayPreferencesRepositoryImpl(
      PropertyDisplayPreferencesLocalDataSourceImpl(preferences),
    );

    expect(repository.getMode(), PropertyDisplayMode.comfortable);
  });

  test('persists and restores compact mode', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = PropertyDisplayPreferencesRepositoryImpl(
      PropertyDisplayPreferencesLocalDataSourceImpl(preferences),
    );

    await repository.saveMode(PropertyDisplayMode.compact);

    expect(repository.getMode(), PropertyDisplayMode.compact);
  });
}
