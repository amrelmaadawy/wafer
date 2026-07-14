import 'package:equatable/equatable.dart';
import '../../domain/entities/contract_item_entity.dart';
import '../../domain/entities/contracts_pagination_meta_entity.dart';

abstract class OwnerContractsState extends Equatable {
  const OwnerContractsState();

  @override
  List<Object?> get props => [];
}

class OwnerContractsInitial extends OwnerContractsState {
  const OwnerContractsInitial();
}

class OwnerContractsLoading extends OwnerContractsState {
  final String activeStatus;

  const OwnerContractsLoading({this.activeStatus = 'all'});

  @override
  List<Object?> get props => [activeStatus];
}

class OwnerContractsLoaded extends OwnerContractsState {
  final List<ContractItemEntity> contracts;
  final ContractsPaginationMetaEntity meta;
  final String activeStatus;
  final bool isFetchingMore;

  const OwnerContractsLoaded({
    required this.contracts,
    required this.meta,
    this.activeStatus = 'all',
    this.isFetchingMore = false,
  });

  OwnerContractsLoaded copyWith({
    List<ContractItemEntity>? contracts,
    ContractsPaginationMetaEntity? meta,
    String? activeStatus,
    bool? isFetchingMore,
  }) {
    return OwnerContractsLoaded(
      contracts: contracts ?? this.contracts,
      meta: meta ?? this.meta,
      activeStatus: activeStatus ?? this.activeStatus,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }

  @override
  List<Object?> get props => [contracts, meta, activeStatus, isFetchingMore];
}

class OwnerContractsEmpty extends OwnerContractsState {
  final String activeStatus;

  const OwnerContractsEmpty({this.activeStatus = 'all'});

  @override
  List<Object?> get props => [activeStatus];
}

class OwnerContractsError extends OwnerContractsState {
  final String message;
  final String activeStatus;

  const OwnerContractsError(this.message, {this.activeStatus = 'all'});

  @override
  List<Object?> get props => [message, activeStatus];
}
