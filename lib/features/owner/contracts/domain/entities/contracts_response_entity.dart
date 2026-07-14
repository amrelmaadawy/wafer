import 'package:equatable/equatable.dart';
import 'contract_item_entity.dart';
import 'contracts_pagination_meta_entity.dart';

class ContractsResponseEntity extends Equatable {
  final List<ContractItemEntity> contracts;
  final ContractsPaginationMetaEntity meta;

  const ContractsResponseEntity({
    required this.contracts,
    required this.meta,
  });

  @override
  List<Object?> get props => [contracts, meta];
}
