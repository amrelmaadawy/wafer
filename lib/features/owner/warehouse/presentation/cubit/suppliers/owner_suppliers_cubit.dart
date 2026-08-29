import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/suppliers/get_owner_suppliers_usecase.dart';
import '../../../domain/entities/suppliers/supplier_entity.dart';
import 'owner_suppliers_state.dart';

class OwnerSuppliersCubit extends Cubit<OwnerSuppliersState> {
  final GetOwnerSuppliersUseCase getOwnerSuppliersUseCase;

  OwnerSuppliersCubit({
    required this.getOwnerSuppliersUseCase,
  }) : super(OwnerSuppliersInitial());

  Future<void> fetchSuppliers({bool isRefresh = false}) async {
    if (isRefresh) {
      emit(OwnerSuppliersInitial());
    }

    if (state is OwnerSuppliersLoading || state is OwnerSuppliersPaginationLoading) return;

    int page = 1;
    List<SupplierEntity> currentSuppliers = [];

    if (state is OwnerSuppliersLoaded && !isRefresh) {
      final currentState = state as OwnerSuppliersLoaded;
      if (currentState.hasReachedMax) return;
      page = currentState.currentPage + 1;
      currentSuppliers = currentState.suppliers;
      emit(OwnerSuppliersPaginationLoading(currentSuppliers));
    } else {
      emit(OwnerSuppliersLoading());
    }

    final result = await getOwnerSuppliersUseCase(page);

    if (!isClosed) {
      result.fold(
        (failure) {
          if (currentSuppliers.isNotEmpty) {
            // Revert to previous loaded state if pagination fails
            emit(OwnerSuppliersLoaded(
              suppliers: currentSuppliers,
              hasReachedMax: false,
              currentPage: page - 1,
            ));
          } else {
            emit(OwnerSuppliersError(message: failure.message));
          }
        },
        (paginatedData) {
          final isMax = paginatedData.currentPage >= paginatedData.lastPage;
          final allSuppliers = List<SupplierEntity>.from(currentSuppliers)..addAll(paginatedData.suppliers);
          emit(OwnerSuppliersLoaded(
            suppliers: allSuppliers,
            hasReachedMax: isMax,
            currentPage: paginatedData.currentPage,
          ));
        },
      );
    }
  }
}
