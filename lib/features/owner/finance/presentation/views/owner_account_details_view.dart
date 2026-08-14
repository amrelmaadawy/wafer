import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/widgets/custom_back_button.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_fonts.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/routing/routes.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../domain/entities/finance_account_entity.dart';
import '../../domain/entities/finance_account_type.dart';
import '../cubit/accounts/finance_account_details_cubit.dart';
import '../cubit/accounts/finance_account_details_state.dart';

class OwnerAccountDetailsView extends StatefulWidget {
  final int accountId;

  const OwnerAccountDetailsView({super.key, required this.accountId});

  @override
  State<OwnerAccountDetailsView> createState() => _OwnerAccountDetailsViewState();
}

class _OwnerAccountDetailsViewState extends State<OwnerAccountDetailsView> {
  @override
  void initState() {
    super.initState();
    context.read<FinanceAccountDetailsCubit>().fetchAccountDetails(widget.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leadingWidth: 68,
        leading: const CustomBackButton(),
        title: const Text('تفاصيل الحساب'), // No need to translate unless requested
        actions: [
          BlocBuilder<FinanceAccountDetailsCubit, FinanceAccountDetailsState>(
            builder: (context, state) {
              if (state is FinanceAccountDetailsSuccess) {
                return IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    final result = await context.push(
                      Routes.ownerFinanceAccountUpdate,
                      extra: state.account,
                    );
                    if (result == true && context.mounted) {
                      context
                          .read<FinanceAccountDetailsCubit>()
                          .fetchAccountDetails(widget.accountId);
                    }
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<FinanceAccountDetailsCubit, FinanceAccountDetailsState>(
        builder: (context, state) {
          if (state is FinanceAccountDetailsLoading || state is FinanceAccountDetailsInitial) {
            return const Center(child: CircularProgressIndicator()); // Can be a skeleton later
          }

          if (state is FinanceAccountDetailsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context
                  .read<FinanceAccountDetailsCubit>()
                  .fetchAccountDetails(widget.accountId),
            );
          }

          if (state is FinanceAccountDetailsSuccess) {
            return _buildDetails(context, state.account);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetails(BuildContext context, FinanceAccountEntity account) {
    final name = context.locale.languageCode == 'ar' ? account.nameAr : account.nameEn;
    final primary = context.primaryColor;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Main Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.circularXxl,
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: AppRadius.circularLg,
                    ),
                    child: Text(
                      account.code,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontFamily: AppFonts.fontFamilyEn,
                            color: primary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  _buildStatusBadge(context, account.isActive),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimaryLight,
                      height: 1.3,
                    ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTypeTag(context, account.type),
                  if (account.isPostable) _buildPostableTag(context),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Other Details Card
        Text(
          LocaleKeys.profile_basic_info.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.circularXxl,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (account.descriptionAr != null && account.descriptionAr!.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description_outlined, size: 18, color: AppColors.textSecondaryLight),
                          const SizedBox(width: 8),
                          Text(
                            LocaleKeys.owner_finance_account_desc.tr(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        account.descriptionAr!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimaryLight,
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.borderLight),
              ],
              _buildInfoRow(
                context,
                icon: Icons.translate_rounded,
                title: LocaleKeys.owner_finance_account_name_ar.tr(),
                value: account.nameAr,
              ),
              const Divider(height: 1, color: AppColors.borderLight, indent: 40),
              _buildInfoRow(
                context,
                icon: Icons.language_rounded,
                title: LocaleKeys.owner_finance_account_name_en.tr(),
                value: account.nameEn,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, {required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondaryLight.withValues(alpha: 0.7)),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isActive) {
    final color = isActive ? AppColors.success : AppColors.error;
    final text = isActive
        ? LocaleKeys.profile_active.tr()
        : LocaleKeys.profile_inactive.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularXl,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeTag(BuildContext context, FinanceAccountType type) {
    Color color;
    String label;
    switch (type) {
      case FinanceAccountType.asset:
        label = LocaleKeys.owner_finance_assets.tr();
        color = AppColors.success;
        break;
      case FinanceAccountType.liability:
        label = LocaleKeys.owner_finance_liabilities.tr();
        color = AppColors.error;
        break;
      case FinanceAccountType.expense:
        label = LocaleKeys.owner_finance_expenses.tr();
        color = AppColors.warning;
        break;
      case FinanceAccountType.revenue:
        label = LocaleKeys.owner_finance_revenues.tr();
        color = AppColors.info;
        break;
      case FinanceAccountType.equity:
        label = LocaleKeys.owner_finance_equity.tr();
        color = Colors.purple;
        break;
      default:
        label = type.value;
        color = AppColors.textSecondaryLight;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularLg,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildPostableTag(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: AppRadius.circularLg,
      ),
      child: Text(
        LocaleKeys.owner_finance_postable.tr(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}