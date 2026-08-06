import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_negotiation_use_case.dart';
import 'create_negotiation_state.dart';

class CreateNegotiationCubit extends Cubit<CreateNegotiationState> {
  final CreateNegotiationUseCase createNegotiationUseCase;

  CreateNegotiationCubit({required this.createNegotiationUseCase})
    : super(CreateNegotiationInitial());

  Future<void> createNegotiation({
    required num approvalLimit,
    required bool isActive,
  }) async {
    emit(CreateNegotiationLoading());

    final result = await createNegotiationUseCase(
      CreateNegotiationParams(approvalLimit: approvalLimit, isActive: isActive),
    );

    result.fold(
      (failure) => emit(CreateNegotiationFailure(failure.message)),
      (_) => emit(CreateNegotiationSuccess()),
    );
  }
}
