import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/finance_overview_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/routing/routes.dart';

class FinanceResourcesGridWidget extends StatelessWidget {
  final FinanceOverviewEntity overview;

  const FinanceResourcesGridWidget({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    // Convert resources map to a list to iterate over
    final resourcesList = overview.resources.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          LocaleKeys.owner_finance_resources_title.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 76,
          ),
          itemCount: resourcesList.length,
          itemBuilder: (context, index) {
            final resource = resourcesList[index];
            return _ResourceCard(
              resource: resource,
              pendingCount: _getPendingCount(resource.key, overview.summary),
            );
          },
        ),
      ],
    );
  }

  int _getPendingCount(String key, FinanceSummaryEntity summary) {
    switch (key) {
      case 'receipts':
        return summary.pendingReceipts;
      case 'payments':
        return summary.pendingPayments;
      case 'transfers':
        return summary.pendingTransfers;
      default:
        return 0;
    }
  }
}

class _ResourceCard extends StatelessWidget {
  final FinanceResourceEntity resource;
  final int pendingCount;

  const _ResourceCard({required this.resource, required this.pendingCount});

  IconData _getIconForResource(String key) {
    switch (key) {
      case 'accounts':
        return Icons.account_balance_rounded;
      case 'receipts':
        return Icons.receipt_long_rounded;
      case 'payments':
        return Icons.payment_rounded;
      case 'transfers':
        return Icons.swap_horiz_rounded;
      case 'journal-entries':
        return Icons.book_rounded;
      default:
        return Icons.folder_rounded;
    }
  }

  String _getLocalizedTitle(String key) {
    switch (key) {
      case 'accounts':
        return LocaleKeys.owner_finance_chart_of_accounts.tr();
      case 'receipts':
        return LocaleKeys.owner_finance_receipt_vouchers.tr();
      case 'payments':
        return LocaleKeys.owner_finance_payment_vouchers.tr();
      case 'transfers':
        return LocaleKeys.owner_finance_internal_transfers.tr();
      case 'journal-entries':
        return LocaleKeys.owner_finance_journal_entries.tr();
      default:
        return resource.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    final isSupported = [
      'accounts',
      'receipts',
      'payments',
      'transfers',
      'journal-entries'
    ].contains(resource.key);

    return Material(
      color: AppColors.surfaceLight,
      borderRadius: AppRadius.circularXxl,
      child: InkWell(
        onTap: isSupported
            ? () {
                if (resource.key == 'accounts') {
                  context.push(Routes.ownerFinanceAccounts);
                } else if (resource.key == 'receipts') {
                  context.push(Routes.ownerFinanceReceipts);
                } else if (resource.key == 'payments') {
                  context.push(Routes.ownerFinancePayments);
                } else if (resource.key == 'transfers') {
                  context.push(Routes.ownerFinanceTransfers);
                } else if (resource.key == 'journal-entries') {
                  context.push(Routes.ownerFinanceJournalEntries);
                }
              }
            : null,
        borderRadius: AppRadius.circularXxl,
        child: Opacity(
          opacity: isSupported ? 1.0 : 0.5,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: AppRadius.circularXxl,
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconForResource(resource.key),
                        color: primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _getLocalizedTitle(resource.key),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryLight,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (pendingCount > 0)
                PositionedDirectional(
                  top: -8,
                  end: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: AppRadius.circularFull,
                    ),
                    child: Text(
                      pendingCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
