import 'package:equatable/equatable.dart';

enum SearchResultType {
  property,
  contract,
  payment,
  receipt,
  maintenance,
  task,
  legalCase
}

class SearchResultEntity extends Equatable {
  final int id;
  final SearchResultType type;
  final String title;
  final String? subtitle;
  final Map<String, dynamic> extra;

  const SearchResultEntity({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.extra = const {},
  });

  @override
  List<Object?> get props => [id, type, title, subtitle, extra];
}
