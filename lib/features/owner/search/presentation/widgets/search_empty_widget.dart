import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/localization/locale_keys.dart';
import 'package:wafer/core/theme/theme_context.dart';

class SearchEmptyWidget extends StatelessWidget {
  final String query;

  const SearchEmptyWidget({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: context.appBorderColor,
            ),
            const SizedBox(height: 16),
            Text(
              LocaleKeys.searchNoResults.tr(namedArgs: {'query': query}),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.appSecondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
