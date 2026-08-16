import 'package:flutter/material.dart';
import 'package:wafer/core/theme/theme_context.dart';
import '../../domain/entities/search_result_entity.dart';
import 'search_result_item.dart';

class SearchResultGroup extends StatelessWidget {
  final String title;
  final List<SearchResultEntity> items;

  const SearchResultGroup({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            '$title (${items.length})',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: context.appSecondaryTextColor,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return SearchResultItem(result: items[index]);
          },
        ),
      ],
    );
  }
}
