import 'package:equatable/equatable.dart';

class UpdateWarehouseItemParams extends Equatable {
  final int id;
  final num? minQuantity;
  final num? sellingPrice;
  final String? description;

  const UpdateWarehouseItemParams({
    required this.id,
    this.minQuantity,
    this.sellingPrice,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        minQuantity,
        sellingPrice,
        description,
      ];
}
