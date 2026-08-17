import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../localization/locale_keys.dart';
import '../../presentation/widgets/custom_empty_widget.dart';
import '../../theme/app_fonts.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/color_utils.dart';
import '../../theme/theme_context.dart';
import '../entities/document_item_entity.dart';
import 'document_item_widget.dart';

class DocumentsListWidget extends StatelessWidget {
  final List<DocumentItemEntity> documents;
  final bool isScrollable;
  final bool showHeader;
  final EdgeInsetsGeometry padding;
  final String? emptyTitle;
  final String? emptySubtitle;

  const DocumentsListWidget({
    super.key,
    required this.documents,
    this.isScrollable = false,
    this.showHeader = true,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.emptyTitle,
    this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return Padding(
        padding: padding,
        child: CustomEmptyWidget(
          icon: Icons.folder_open_outlined,
          title: emptyTitle ?? LocaleKeys.documentsEmpty.tr(),
          subtitle: emptySubtitle ?? LocaleKeys.documentsEmptySubtitle.tr(),
        ),
      );
    }

    if (isScrollable) {
      return ListView.builder(
        padding: padding,
        itemCount: documents.length + (showHeader ? 1 : 0),
        itemBuilder: (context, index) {
          if (showHeader && index == 0) {
            return _buildHeader(context);
          }
          final docIndex = showHeader ? index - 1 : index;
          return DocumentItemWidget(document: documents[docIndex]);
        },
      );
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHeader) _buildHeader(context),
          ...documents.map(
            (doc) => DocumentItemWidget(document: doc),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.documentsSectionHeader.tr(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: AppFonts.bold,
              color: context.appOnSurfaceColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: context.primaryColor.withA(0.12),
              borderRadius: AppRadius.circularSm,
            ),
            child: Text(
              LocaleKeys.documentsCount.tr(
                args: [documents.length.toString()],
              ),
              style: TextStyle(
                fontSize: 12,
                fontWeight: AppFonts.semiBold,
                color: context.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
