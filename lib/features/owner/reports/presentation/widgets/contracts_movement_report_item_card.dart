import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../domain/entities/contracts_movement_item_entity.dart';

class ContractsMovementReportItemCard extends StatelessWidget {
  final ContractsMovementItemEntity item;

  const ContractsMovementReportItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.circularLg,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildDivider(),
          _buildBody(),
          _buildDivider(),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.renter.name.isNotEmpty
                      ? item.renter.name
                      : LocaleKeys.contractsMovementUnknownRenter.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.maps_home_work_outlined,
                      size: 14,
                      color: AppColors.textSecondaryLight,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${item.property.name.isNotEmpty ? item.property.name : item.property.code} - ${item.unit.name.isNotEmpty ? item.unit.name : item.unit.unitNumber}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _getTypeColor(item.type).withValues(alpha: 0.1),
              borderRadius: AppRadius.circularSm,
              border: Border.all(
                color: _getTypeColor(item.type).withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              _getTypeLabel(item.type),
              style: TextStyle(
                color: _getTypeColor(item.type),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.borderLight.withValues(alpha: 0.5),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildDetailItem(
            LocaleKeys.contractsMovementContractNo.tr(),
            item.contractNumber,
            Icons.tag_rounded,
          ),
          const SizedBox(width: 16),
          _buildDetailItem(
            LocaleKeys.contractsMovementDate.tr(),
            item.date.split(' ').first,
            Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondaryLight),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.contractsMovementRentValue.tr(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${item.rentValue.toStringAsFixed(2)} ر.س',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.circularSm,
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Icon(
                  _getStatusIcon(item.status),
                  size: 14,
                  color: _getStatusColor(item.status),
                ),
                const SizedBox(width: 6),
                Text(
                  item.statusLabel,
                  style: TextStyle(
                    color: _getStatusColor(item.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'creation':
        return const Color(0xFF10B981); // Emerald
      case 'renewal':
        return const Color(0xFF3B82F6); // Blue
      case 'termination':
        return const Color(0xFFEF4444); // Red
      default:
        return AppColors.textSecondaryLight;
    }
  }

  String _getTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'creation':
        return LocaleKeys.contractsMovementTypeCreation.tr();
      case 'renewal':
        return LocaleKeys.contractsMovementTypeRenewal.tr();
      case 'termination':
        return LocaleKeys.contractsMovementTypeTermination.tr();
      default:
        return type;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return const Color(0xFF10B981); // Emerald
      case 'draft':
      case 'pending_approval':
      case 'awaiting_signature':
      case 'pending_renewal':
        return const Color(0xFFF59E0B); // Amber
      case 'expired':
      case 'terminated':
      case 'early_terminated':
        return const Color(0xFFEF4444); // Red
      default:
        return AppColors.textSecondaryLight;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Icons.check_circle_outline;
      case 'expired':
      case 'terminated':
      case 'early_terminated':
        return Icons.cancel_outlined;
      default:
        return Icons.hourglass_empty;
    }
  }
}
