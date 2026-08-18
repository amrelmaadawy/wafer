import 'package:equatable/equatable.dart';

class TasksFilterParams extends Equatable {
  final int page;
  final int perPage;
  final String? search;
  final String? status;
  final String? priority;
  final String? category;
  final int? assigneeId;
  final int? propertyId;
  final int? deedId;
  final int? branchId;
  final String? linkedTo;
  final String? dueDate;
  final String? sortBy;
  final String? sortOrder;

  const TasksFilterParams({
    this.page = 1,
    this.perPage = 15,
    this.search,
    this.status,
    this.priority,
    this.category,
    this.assigneeId,
    this.propertyId,
    this.deedId,
    this.branchId,
    this.linkedTo,
    this.dueDate,
    this.sortBy,
    this.sortOrder,
  });

  TasksFilterParams copyWith({
    int? page,
    int? perPage,
    String? search,
    String? status,
    String? priority,
    String? category,
    int? assigneeId,
    int? propertyId,
    int? deedId,
    int? branchId,
    String? linkedTo,
    String? dueDate,
    String? sortBy,
    String? sortOrder,
    bool clearSearch = false,
    bool clearStatus = false,
    bool clearPriority = false,
    bool clearCategory = false,
    bool clearAssignee = false,
    bool clearProperty = false,
    bool clearDeed = false,
    bool clearBranch = false,
    bool clearLinkedTo = false,
    bool clearDueDate = false,
    bool clearSort = false,
  }) {
    return TasksFilterParams(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      search: clearSearch ? null : (search ?? this.search),
      status: clearStatus ? null : (status ?? this.status),
      priority: clearPriority ? null : (priority ?? this.priority),
      category: clearCategory ? null : (category ?? this.category),
      assigneeId: clearAssignee ? null : (assigneeId ?? this.assigneeId),
      propertyId: clearProperty ? null : (propertyId ?? this.propertyId),
      deedId: clearDeed ? null : (deedId ?? this.deedId),
      branchId: clearBranch ? null : (branchId ?? this.branchId),
      linkedTo: clearLinkedTo ? null : (linkedTo ?? this.linkedTo),
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      sortBy: clearSort ? null : (sortBy ?? this.sortBy),
      sortOrder: clearSort ? null : (sortOrder ?? this.sortOrder),
    );
  }

  bool get hasAdvancedFilters =>
      (priority != null && priority!.isNotEmpty) ||
      (category != null && category!.isNotEmpty) ||
      assigneeId != null ||
      propertyId != null ||
      deedId != null ||
      branchId != null ||
      (linkedTo != null && linkedTo!.isNotEmpty) ||
      (dueDate != null && dueDate!.isNotEmpty);

  int get activeFiltersCount {
    int count = 0;
    if (status != null && status!.isNotEmpty) count++;
    if (priority != null && priority!.isNotEmpty) count++;
    if (category != null && category!.isNotEmpty) count++;
    if (assigneeId != null) count++;
    if (propertyId != null) count++;
    if (deedId != null) count++;
    if (branchId != null) count++;
    if (linkedTo != null && linkedTo!.isNotEmpty) count++;
    if (dueDate != null && dueDate!.isNotEmpty) count++;
    return count;
  }

  bool get isSortActive => sortBy != null && sortBy!.isNotEmpty;

  Map<String, dynamic> toQueryMap() {
    final map = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (search != null && search!.trim().isNotEmpty) {
      map['search'] = search!.trim();
    }
    if (status != null && status!.isNotEmpty) {
      map['status'] = status;
    }
    if (priority != null && priority!.isNotEmpty) {
      map['priority'] = priority;
    }
    if (category != null && category!.isNotEmpty) {
      map['category'] = category;
    }
    if (assigneeId != null) {
      map['assignee_id'] = assigneeId;
    }
    if (propertyId != null) {
      map['property_id'] = propertyId;
    }
    if (deedId != null) {
      map['deed_id'] = deedId;
    }
    if (branchId != null) {
      map['branch_id'] = branchId;
    }
    if (linkedTo != null && linkedTo!.isNotEmpty) {
      map['linked_to'] = linkedTo;
    }
    if (dueDate != null && dueDate!.isNotEmpty) {
      map['due_date'] = dueDate;
    }
    if (sortBy != null && sortBy!.isNotEmpty) {
      map['sort_by'] = sortBy;
    }
    if (sortOrder != null && sortOrder!.isNotEmpty) {
      map['sort_order'] = sortOrder;
    }
    return map;
  }

  @override
  List<Object?> get props => [
    page,
    perPage,
    search,
    status,
    priority,
    category,
    assigneeId,
    propertyId,
    deedId,
    branchId,
    linkedTo,
    dueDate,
    sortBy,
    sortOrder,
  ];
}
