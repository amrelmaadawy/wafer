import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wafer/core/theme/app_radius.dart';
import '../../domain/entities/owner_dashboard_entity.dart';
import 'owner_financial_summary_card.dart';
import 'owner_installment_stats_card.dart';
import '../../../../../core/theme/color_utils.dart';

class OwnerFinanceCarouselWidget extends StatefulWidget {
  final OwnerDashboardEntity data;
  const OwnerFinanceCarouselWidget({super.key, required this.data});

  @override
  State<OwnerFinanceCarouselWidget> createState() =>
      _OwnerFinanceCarouselWidgetState();
}

class _OwnerFinanceCarouselWidgetState
    extends State<OwnerFinanceCarouselWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    if (widget.data.installmentStats == null) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextPage = _currentIndex == 0 ? 1 : 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250, // increased height for new 2x2 grid
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: [
              OwnerFinancialSummaryCard(data: widget.data),
              if (widget.data.installmentStats != null)
                OwnerInstallmentStatsCard(stats: widget.data.installmentStats!),
            ],
          ),
        ),
        if (widget.data.installmentStats != null) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              2,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? context.primaryColor
                      : Colors.grey.shade300,
                  borderRadius: AppRadius.circularSm,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
