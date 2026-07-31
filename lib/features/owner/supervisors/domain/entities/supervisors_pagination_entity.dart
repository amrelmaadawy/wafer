import 'package:equatable/equatable.dart';

class SupervisorsPaginationEntity extends Equatable {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int? from;
  final int? to;

  const SupervisorsPaginationEntity({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    this.from,
    this.to,
  });

  @override
  List<Object?> get props => [currentPage, lastPage, perPage, total, from, to];
}
