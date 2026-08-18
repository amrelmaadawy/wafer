import '../../domain/entities/maintenance_item_entity.dart';
import '../../domain/entities/maintenance_query_filter_entity.dart';

class MaintenanceFilterEvaluator {
  static List<MaintenanceItemEntity> evaluate({
    required List<MaintenanceItemEntity> items,
    required MaintenanceQueryFilterEntity filter,
  }) {
    List<MaintenanceItemEntity> filtered = List.from(items);

    // Search query
    if (filter.search != null && filter.search!.trim().isNotEmpty) {
      final query = filter.search!.trim().toLowerCase();
      filtered = filtered.where((item) {
        final req = item.requestNumber?.toLowerCase() ?? '';
        final title = item.title?.toLowerCase() ?? '';
        final desc = item.description?.toLowerCase() ?? '';
        final client = item.client?.name?.toLowerCase() ?? '';
        final prop = item.property?.name?.toLowerCase() ?? '';
        return req.contains(query) ||
            title.contains(query) ||
            desc.contains(query) ||
            client.contains(query) ||
            prop.contains(query);
      }).toList();
    }

    // Category / Type filter
    if (filter.typeId != null) {
      filtered = filtered
          .where((i) => i.types?.any((t) => t.id == filter.typeId) ?? false)
          .toList();
    } else if (filter.typeName != null &&
        filter.typeName!.isNotEmpty &&
        filter.typeName != 'all') {
      final tLower = filter.typeName!.toLowerCase();
      filtered = filtered.where((i) {
        return (i.types?.any(
                  (t) =>
                      (t.name?.toLowerCase().contains(tLower) ?? false) ||
                      (t.nameAr?.toLowerCase().contains(tLower) ?? false),
                ) ??
                false) ||
            (i.customType?.toLowerCase().contains(tLower) ?? false);
      }).toList();
    }

    // Status filter
    if (filter.status != null &&
        filter.status!.isNotEmpty &&
        filter.status != 'all') {
      final sLower = filter.status!.toLowerCase();
      filtered = filtered
          .where((i) => i.status?.toLowerCase() == sLower)
          .toList();
    }

    // Priority filter
    if (filter.priority != null && filter.priority!.isNotEmpty) {
      final pLower = filter.priority!.toLowerCase();
      filtered = filtered
          .where((i) => i.priority?.toLowerCase() == pLower)
          .toList();
    }

    // Cost bearer filter
    if (filter.costBearer != null &&
        filter.costBearer!.isNotEmpty &&
        filter.costBearer != 'all') {
      final cbLower = filter.costBearer!.toLowerCase();
      filtered = filtered
          .where((i) => i.costBearer?.toLowerCase() == cbLower)
          .toList();
    }

    // Property filter
    if (filter.propertyId != null) {
      filtered = filtered
          .where((i) => i.property?.id == filter.propertyId)
          .toList();
    } else if (filter.propertyName != null &&
        filter.propertyName!.isNotEmpty) {
      final propLower = filter.propertyName!.toLowerCase();
      filtered = filtered
          .where(
            (i) => i.property?.name?.toLowerCase().contains(propLower) ?? false,
          )
          .toList();
    }

    // Unit filter
    if (filter.unitId != null) {
      filtered = filtered.where((i) => i.unit?.id == filter.unitId).toList();
    }

    // Technician filter
    if (filter.technicianId != null) {
      filtered = filtered
          .where(
            (i) =>
                i.assignments?.any(
                  (a) => a.technician?.id == filter.technicianId,
                ) ??
                false,
          )
          .toList();
    } else if (filter.technicianName != null &&
        filter.technicianName!.isNotEmpty) {
      final techLower = filter.technicianName!.toLowerCase();
      filtered = filtered.where((i) {
        return i.assignments?.any(
              (a) =>
                  a.technician?.name?.toLowerCase().contains(techLower) ??
                  false,
            ) ??
            false;
      }).toList();
    }

    // Date filter
    if (filter.date != null && filter.date!.isNotEmpty) {
      final d = filter.date!;
      filtered = filtered
          .where(
            (i) =>
                (i.dates?.requestedDate?.startsWith(d) ?? false) ||
                (i.dates?.createdAt?.startsWith(d) ?? false),
          )
          .toList();
    }

    // Sorting
    if (filter.sortBy != null) {
      filtered.sort((a, b) {
        int cmp = 0;
        switch (filter.sortBy!) {
          case MaintenanceSortField.date:
            final dateA = a.dates?.createdAt ?? '';
            final dateB = b.dates?.createdAt ?? '';
            cmp = dateA.compareTo(dateB);
            break;
          case MaintenanceSortField.priority:
            final priA = a.priority ?? '';
            final priB = b.priority ?? '';
            cmp = priA.compareTo(priB);
            break;
          case MaintenanceSortField.requestNumber:
            final reqA = a.requestNumber ?? '';
            final reqB = b.requestNumber ?? '';
            cmp = reqA.compareTo(reqB);
            break;
        }
        return filter.sortAscending ? cmp : -cmp;
      });
    }

    return filtered;
  }
}
