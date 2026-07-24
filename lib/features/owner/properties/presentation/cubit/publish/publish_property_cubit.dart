import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/publish_property_use_case.dart';
import 'publish_property_state.dart';

class PublishPropertyCubit extends Cubit<PublishPropertyState> {
  final PublishPropertyUseCase _publishPropertyUseCase;

  PublishPropertyCubit(this._publishPropertyUseCase)
      : super(const PublishPropertyInitial());

  Future<void> publishProperty(int propertyId) async {
    emit(const PublishPropertyLoading());
    final result = await _publishPropertyUseCase(propertyId);
    result.fold(
      (failure) => emit(PublishPropertyError(failure.message)),
      (property) => emit(PublishPropertySuccess(property)),
    );
  }
}
