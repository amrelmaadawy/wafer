import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wafer/features/owner/contracts/domain/entities/contract_status_filter.dart';
import 'package:wafer/features/owner/contracts/domain/entities/contracts_pagination_meta_entity.dart';
import 'package:wafer/features/owner/contracts/domain/entities/contracts_response_entity.dart';
import 'package:wafer/features/owner/contracts/domain/usecases/get_owner_contracts_use_case.dart';
import 'package:wafer/features/owner/contracts/presentation/cubit/list/owner_contracts_cubit.dart';
import 'package:wafer/features/owner/contracts/presentation/cubit/list/owner_contracts_state.dart';

class _MockGetContracts extends Mock implements GetOwnerContractsUseCase {}

void main() {
  late _MockGetContracts getContracts;

  setUpAll(() {
    registerFallbackValue(const GetOwnerContractsParams());
  });

  setUp(() {
    getContracts = _MockGetContracts();
    when(() => getContracts(any())).thenAnswer(
      (_) async => const Right(
        ContractsResponseEntity(
          contracts: [],
          meta: ContractsPaginationMetaEntity(
            currentPage: 1,
            lastPage: 1,
            perPage: 15,
            total: 0,
          ),
        ),
      ),
    );
  });

  blocTest<OwnerContractsCubit, OwnerContractsState>(
    'uses typed active status when changing the filter',
    build: () => OwnerContractsCubit(getContracts),
    act: (cubit) => cubit.changeStatusFilter(ContractStatusFilter.active),
    expect: () => [
      const OwnerContractsLoading(activeStatus: ContractStatusFilter.active),
      const OwnerContractsEmpty(activeStatus: ContractStatusFilter.active),
    ],
    verify: (_) {
      verify(
        () => getContracts(
          any(
            that: isA<GetOwnerContractsParams>().having(
              (params) => params.status,
              'status',
              ContractStatusFilter.active,
            ),
          ),
        ),
      ).called(1);
    },
  );
}
