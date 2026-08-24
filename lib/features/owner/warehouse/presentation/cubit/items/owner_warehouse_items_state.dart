import 'package:equatable/equatable.dart';

import '../../../domain/entities/warehouse_item_entity.dart';

abstract class OwnerWarehouseItemsState extends Equatable {
  final List<WarehouseItemEntity> items;
  final bool hasReachedMax;
  final int currentPage;

  const OwnerWarehouseItemsState({
    required this.items,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [items, hasReachedMax, currentPage];
}

class OwnerWarehouseItemsInitial extends OwnerWarehouseItemsState {
  const OwnerWarehouseItemsInitial() : super(items: const []);
}

class OwnerWarehouseItemsLoading extends OwnerWarehouseItemsState {
  const OwnerWarehouseItemsLoading({
    required super.items,
    super.hasReachedMax,
    super.currentPage,
  });
}

class OwnerWarehouseItemsLoaded extends OwnerWarehouseItemsState {
  const OwnerWarehouseItemsLoaded({
    required super.items,
    required super.hasReachedMax,
    required super.currentPage,
  });
}

class OwnerWarehouseItemsError extends OwnerWarehouseItemsState {
  final String message;

  const OwnerWarehouseItemsError({
    required this.message,
    required super.items,
    super.hasReachedMax,
    super.currentPage,
  });

  @override
  List<Object?> get props => [message, items, hasReachedMax, currentPage];
}
