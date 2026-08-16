import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wafer/core/routing/routes.dart';
import 'package:wafer/core/theme/theme_context.dart';
import '../../domain/entities/search_result_entity.dart';

class SearchResultItem extends StatelessWidget {
  final SearchResultEntity result;

  const SearchResultItem({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateTo(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.appSurfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appBorderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getBackgroundColor(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIcon(),
                color: _getIconColor(context),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: TextStyle(
                      color: context.appOnSurfaceColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (result.subtitle != null && result.subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      result.subtitle!,
                      style: TextStyle(
                        color: context.appSecondaryTextColor,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.appSecondaryTextColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context) {
    final id = result.id.toString();
    switch (result.type) {
      case SearchResultType.property:
        context.push(Routes.ownerPropertyDetailsPath(id));
        break;
      case SearchResultType.contract:
        context.push(Routes.ownerContractDetailsPath(id));
        break;
      case SearchResultType.maintenance:
        context.push(Routes.ownerMaintenanceDetailsPath(id));
        break;
      case SearchResultType.task:
        context.push(Routes.ownerTaskDetailsPath(id));
        break;
      case SearchResultType.legalCase:
        context.push(Routes.ownerLegalCaseDetailsPath(id));
        break;
      case SearchResultType.payment:
        // Currently there is no payment details page directly, so we push to payments list
        context.push(Routes.ownerFinancePayments);
        break;
      case SearchResultType.receipt:
        // Currently there is no receipt details page directly, so we push to receipts list
        context.push(Routes.ownerFinanceReceipts);
        break;
    }
  }

  IconData _getIcon() {
    switch (result.type) {
      case SearchResultType.property:
        return Icons.business;
      case SearchResultType.contract:
        return Icons.description;
      case SearchResultType.payment:
        return Icons.payment;
      case SearchResultType.receipt:
        return Icons.receipt;
      case SearchResultType.maintenance:
        return Icons.build;
      case SearchResultType.task:
        return Icons.check_circle_outline;
      case SearchResultType.legalCase:
        return Icons.gavel;
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    return _getIconColor(context).withValues(alpha: 0.1);
  }

  Color _getIconColor(BuildContext context) {
    switch (result.type) {
      case SearchResultType.property:
        return Colors.blue;
      case SearchResultType.contract:
        return Colors.purple;
      case SearchResultType.payment:
        return Colors.red;
      case SearchResultType.receipt:
        return Colors.green;
      case SearchResultType.maintenance:
        return Colors.orange;
      case SearchResultType.task:
        return Colors.teal;
      case SearchResultType.legalCase:
        return Colors.brown;
    }
  }
}
