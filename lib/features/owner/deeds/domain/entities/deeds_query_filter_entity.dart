import 'package:equatable/equatable.dart';

class DeedsQueryFilterEntity extends Equatable {
  final int page;
  final int perPage;
  final String? search;
  final int? branchId;

  const DeedsQueryFilterEntity({
    this.page = 1,
    this.perPage = 20,
    this.search,
    this.branchId,
  });

  DeedsQueryFilterEntity copyWith({
    int? page,
    int? perPage,
    String? Function()? search,
    int? Function()? branchId,
  }) {
    return DeedsQueryFilterEntity(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: search != null ? search() : this.search,
      branchId: branchId != null ? branchId() : this.branchId,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    
    if (search != null && search!.isNotEmpty) {
      map['search'] = search;
    }
    
    if (branchId != null) {
      map['branch_id'] = branchId;
    }

    return map;
  }

  @override
  List<Object?> get props => [page, perPage, search, branchId];
}
