import 'package:equatable/equatable.dart';
import 'deed_entity.dart';
import 'deeds_pagination_meta_entity.dart';

class DeedsResponseEntity extends Equatable {
  final List<DeedEntity> items;
  final DeedsPaginationMetaEntity meta;

  const DeedsResponseEntity({
    required this.items,
    required this.meta,
  });

  @override
  List<Object?> get props => [items, meta];
}
