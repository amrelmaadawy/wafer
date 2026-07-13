import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/owner_dashboard_entity.dart';

class OwnerRecentReceiptsSection extends StatelessWidget {
  final List<ReceiptEntity> receipts;

  const OwnerRecentReceiptsSection({super.key, required this.receipts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocaleKeys.dashboardRecentReceipts.tr(), style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.w800)),
            if (receipts.isNotEmpty)
              TextButton(
                onPressed: () {},
                child: Text(LocaleKeys.dashboardViewAll.tr(), style: TextStyle(color: context.primaryColor, fontSize: 13, fontWeight: FontWeight.w700)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (receipts.isEmpty)
          _buildEmptyState(context)
        else
          ...receipts.map((r) => _buildReceiptCard(context, r)),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF0F7)),
      ),
      child: Column(
        children: [
          Container(
            width: 54, height: 54,
            decoration: BoxDecoration(color: context.primaryFaint, shape: BoxShape.circle),
            child: Icon(Icons.receipt_long_rounded, color: context.primaryColor, size: 28),
          ),
          const SizedBox(height: 14),
          Text(LocaleKeys.dashboardNoRecentReceipts.tr(), style: const TextStyle(color: Color(0xFF1E293B), fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(LocaleKeys.dashboardReceiptsSubtitle.tr(), style: const TextStyle(color: Color(0xFF64748B), fontSize: 12.5), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(BuildContext context, ReceiptEntity receipt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDF0F7)),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: const Color(0xFF10B981).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_downward_rounded, color: Color(0xFF10B981), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(receipt.tenantName, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13.5, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.domain_rounded, size: 13, color: Color(0xFF64748B)),
                    const SizedBox(width: 4),
                    Text('${receipt.propertyName} - ${LocaleKeys.dashboardUnitPrefix.tr(args: [receipt.unitNumber])}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11.5)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('+${LocaleKeys.commonCurrencySar.tr(args: [_fmt(receipt.amount)])}', style: const TextStyle(color: Color(0xFF10B981), fontSize: 14, fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              Text(receipt.date, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(num n) => n == n.toInt()
      ? n.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')
      : n.toStringAsFixed(2);
}
