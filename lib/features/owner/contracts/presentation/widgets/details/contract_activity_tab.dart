import 'package:flutter/material.dart';
import '../../../../../../core/activity/widgets/activity_timeline_widget.dart';

class ContractActivityTab extends StatelessWidget {
  const ContractActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const ActivityTimelineWidget(
      activities: [],
      isScrollable: true,
    );
  }
}
