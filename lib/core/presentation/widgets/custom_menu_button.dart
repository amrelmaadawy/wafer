import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/color_utils.dart';

class CustomMenuButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CustomMenuButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 8),
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            borderRadius: AppRadius.circularLg,
          ),
          child: IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: context.primaryColor,
              size: 20,
            ),
            padding: EdgeInsets.zero,
            onPressed: onPressed ??
                () {
                  final rootScaffold = context.findRootAncestorStateOfType<ScaffoldState>();
                  if (rootScaffold != null) {
                    rootScaffold.openDrawer();
                  } else {
                    Scaffold.of(context).openDrawer();
                  }
                },
          ),
        ),
      ),
    );
  }
}
