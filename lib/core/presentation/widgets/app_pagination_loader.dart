import 'package:flutter/material.dart';
import '../../theme/color_utils.dart';

/// Loading indicator shown at the bottom of paginated lists.
/// Used as the last item in ListView.builder when loading next page.
class AppPaginationLoader extends StatelessWidget {
  const AppPaginationLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: context.primaryColor,
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }
}
