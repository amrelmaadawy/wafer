import 'package:equatable/equatable.dart';
import 'search_result_entity.dart';

class SearchResultsGroupedEntity extends Equatable {
  final List<SearchResultEntity> properties;
  final List<SearchResultEntity> contracts;
  final List<SearchResultEntity> payments;
  final List<SearchResultEntity> receipts;
  final List<SearchResultEntity> maintenance;
  final List<SearchResultEntity> tasks;
  final List<SearchResultEntity> legalCases;

  const SearchResultsGroupedEntity({
    this.properties = const [],
    this.contracts = const [],
    this.payments = const [],
    this.receipts = const [],
    this.maintenance = const [],
    this.tasks = const [],
    this.legalCases = const [],
  });

  bool get isEmpty =>
      properties.isEmpty &&
      contracts.isEmpty &&
      payments.isEmpty &&
      receipts.isEmpty &&
      maintenance.isEmpty &&
      tasks.isEmpty &&
      legalCases.isEmpty;

  int get totalCount =>
      properties.length +
      contracts.length +
      payments.length +
      receipts.length +
      maintenance.length +
      tasks.length +
      legalCases.length;

  @override
  List<Object?> get props => [
        properties,
        contracts,
        payments,
        receipts,
        maintenance,
        tasks,
        legalCases,
      ];
}
