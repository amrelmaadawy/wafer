import 'package:flutter_test/flutter_test.dart';
import 'package:wafer/features/owner/properties/domain/entities/property_display_mode.dart';
import 'package:wafer/features/owner/properties/domain/repositories/property_display_preferences_repository.dart';
import 'package:wafer/features/owner/properties/domain/usecases/get_property_display_mode_use_case.dart';
import 'package:wafer/features/owner/properties/domain/usecases/save_property_display_mode_use_case.dart';
import 'package:wafer/features/owner/properties/presentation/cubit/display/property_display_cubit.dart';

class _FakeRepository implements PropertyDisplayPreferencesRepository {
  PropertyDisplayMode mode;

  _FakeRepository(this.mode);

  @override
  PropertyDisplayMode getMode() => mode;

  @override
  Future<void> saveMode(PropertyDisplayMode mode) async {
    this.mode = mode;
  }
}

void main() {
  test('restores mode and saves changes', () async {
    final repository = _FakeRepository(PropertyDisplayMode.compact);
    final cubit = PropertyDisplayCubit(
      GetPropertyDisplayModeUseCase(repository),
      SavePropertyDisplayModeUseCase(repository),
    );

    expect(cubit.state.mode, PropertyDisplayMode.compact);

    await cubit.changeMode(PropertyDisplayMode.comfortable);

    expect(cubit.state.mode, PropertyDisplayMode.comfortable);
    expect(repository.mode, PropertyDisplayMode.comfortable);
    await cubit.close();
  });
}
