import 'package:equatable/equatable.dart';

class WarehouseParentEntity extends Equatable {
  final int id;
  final String name;
  final String code;

  const WarehouseParentEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  @override
  List<Object?> get props => [id, name, code];
}

class WarehouseEntity extends Equatable {
  final int id;
  final String name;
  final String code;
  final WarehouseParentEntity? parent;
  final bool isMain;
  final bool isActive;
  final String statusLabel;
  final int itemsCount;
  final int movementsCount;
  final String? notes;
  final String createdAt;
  final String updatedAt;

  const WarehouseEntity({
    required this.id,
    required this.name,
    required this.code,
    this.parent,
    required this.isMain,
    required this.isActive,
    required this.statusLabel,
    required this.itemsCount,
    required this.movementsCount,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        parent,
        isMain,
        isActive,
        statusLabel,
        itemsCount,
        movementsCount,
        notes,
        createdAt,
        updatedAt,
      ];
}
