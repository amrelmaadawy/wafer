import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_fonts.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/contract_details_entity.dart';

class ContractDetailsSliverAppBar extends StatelessWidget {
  final ContractDetailsEntity contract;
  final TabController tabController;

  const ContractDetailsSliverAppBar({
    super.key,
    required this.contract,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.primaryColor;
    final isDraft = contract.status.toLowerCase() == 'draft';
    final statusColor = isDraft ? AppColors.warning : AppColors.success;

    return SliverAppBar(
      expandedHeight: 210.0,
      pinned: true,
      backgroundColor: primary,
      leadingWidth: 64,
      leading: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: IconButton(
            icon: Icon(
              context.locale.languageCode == 'ar'
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.white,
            ),
            onPressed: () => context.pop(),
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.2),
            borderRadius: AppRadius.circularFull,
            border: Border.all(color: statusColor, width: 1),
          ),
          child: Text(
            contract.statusLabel.isNotEmpty
                ? contract.statusLabel
                : contract.status,
            style: TextStyle(
              color: statusColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [primary, AppColors.textPrimaryLight],
          ),
        ),
        child: FlexibleSpaceBar(
          background: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 76),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: AppRadius.circularXl,
                        ),
                        child: const Icon(
                          Icons.assignment_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              contract.contractNumber,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: AppFonts.fontFamilyPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (contract.propertyName.isNotEmpty)
                              Text(
                                '${contract.propertyName} • ${contract.unitName}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontFamily: AppFonts.fontFamilyPrimary,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(66),
        child: Container(
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: AppRadius.circularXl,
            ),
            child: TabBar(
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelColor: primary,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(
                fontFamily: AppFonts.fontFamilyPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: AppFonts.fontFamilyPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicatorPadding: const EdgeInsets.all(4),
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.circularLg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              tabs: [
                Tab(text: LocaleKeys.contractDetailsOverview.tr()),
                Tab(text: LocaleKeys.contractDetailsInstallments.tr()),
                Tab(text: LocaleKeys.contractDetailsPayments.tr()),
                Tab(text: LocaleKeys.contractDetailsDocuments.tr()),
                Tab(text: LocaleKeys.contractDetailsActivity.tr()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
