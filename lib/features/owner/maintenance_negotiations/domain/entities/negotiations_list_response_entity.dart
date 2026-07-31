import 'package:equatable/equatable.dart';
import 'negotiation_form_data_entity.dart';
import 'negotiation_pagination_entity.dart';

class NegotiationsListResponseEntity extends Equatable {
  final List<NegotiationEntity> negotiations;
  final NegotiationPaginationEntity pagination;

  const NegotiationsListResponseEntity({
    required this.negotiations,
    required this.pagination,
  });

  @override
  List<Object?> get props => [negotiations, pagination];
}
