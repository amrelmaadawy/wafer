import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/owner_dashboard_entity.dart';

class OwnerOccupancyCard extends StatelessWidget {
  final OwnerDashboardEntity data;

  const OwnerOccupancyCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final rate = (data.occupancyRate.toDouble() / 100).clamp(0.0, 1.0);
    final rateColor = data.occupancyRate >= 70 ? const Color(0xFF10B981) : data.occupancyRate >= 40 ? const Color(0xFFF59E0B) : AppColors.error;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.pie_chart_outline_rounded, size: 16, color: Color(0xFF64748B)),
                  SizedBox(width: 7),
                  Text('كفاءة الإشغال', style: TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.w700)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: rateColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                child: Text('${data.occupancyRate}%', style: TextStyle(color: rateColor, fontSize: 13, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: rate),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: const Color(0xFFE8EDF5),
                valueColor: AlwaysStoppedAnimation<Color>(rateColor),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _pill(label: 'مؤجرة', count: data.rentedUnits, color: const Color(0xFF10B981), icon: Icons.check_circle_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _pill(label: 'شاغرة', count: data.vacantUnits, color: const Color(0xFF64748B), icon: Icons.roofing_rounded)),
              const SizedBox(width: 8),
              Expanded(child: _pill(label: 'عقارات', count: data.totalProperties, color: const Color(0xFF6366F1), icon: Icons.domain_rounded)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pill({required String label, required int count, required Color color, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Text('$count', style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEDF0F7)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 6)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}
