import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/color_utils.dart';

class CustomDropdownMenu<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final String Function(T) itemLabelBuilder;
  final void Function(T)? onSelected;
  final bool isExpanded;
  final String? errorText;
  final double height;

  const CustomDropdownMenu({
    super.key,
    required this.items,
    required this.value,
    required this.hint,
    required this.itemLabelBuilder,
    this.onSelected,
    this.isExpanded = true,
    this.errorText,
    this.height = 48,
  });

  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SearchModal<T>(
        items: items,
        value: value,
        hint: hint,
        itemLabelBuilder: itemLabelBuilder,
      ),
    ).then((selectedValue) {
      if (selectedValue != null && onSelected != null) {
        onSelected!(selectedValue as T);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: items.isEmpty ? null : () => _showSearchModal(context),
          borderRadius: AppRadius.circularLg,
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: items.isEmpty ? const Color(0xFFF1F5F9) : AppColors.backgroundLight,
              borderRadius: AppRadius.circularLg,
              border: Border.all(
                color: errorText != null ? Colors.red : const Color(0xFFE2E8F0),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value != null ? itemLabelBuilder(value as T) : hint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          value != null ? FontWeight.w600 : FontWeight.w500,
                      color: items.isEmpty
                          ? AppColors.textSecondaryLight.withValues(alpha: 0.5)
                          : (value != null
                              ? AppColors.textPrimaryLight
                              : AppColors.textSecondaryLight),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: items.isEmpty 
                      ? AppColors.textSecondaryLight.withValues(alpha: 0.3)
                      : AppColors.textSecondaryLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 16, left: 16),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

class _SearchModal<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final String Function(T) itemLabelBuilder;

  const _SearchModal({
    required this.items,
    required this.value,
    required this.hint,
    required this.itemLabelBuilder,
  });

  @override
  State<_SearchModal<T>> createState() => _SearchModalState<T>();
}

class _SearchModalState<T> extends State<_SearchModal<T>> {
  late List<T> filteredItems;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredItems = widget.items;
      } else {
        filteredItems = widget.items.where((item) {
          final label = widget.itemLabelBuilder(item).toLowerCase();
          return label.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine height based on screen size (max 80%)
    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.hint,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.textSecondaryLight,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: AppRadius.circularLg,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondaryLight,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'بحث...',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondaryLight.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    InkWell(
                      onTap: () {
                        _searchController.clear();
                      },
                      child: const Icon(
                        Icons.cancel_rounded,
                        color: AppColors.textSecondaryLight,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: filteredItems.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppColors.textSecondaryLight.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد نتائج مطابقة',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shrinkWrap: true,
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = widget.value == item;

                      return InkWell(
                        onTap: () => Navigator.pop(context, item),
                        borderRadius: AppRadius.circularMd,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? context.primaryColor.withValues(alpha: 0.08)
                                : Colors.transparent,
                            borderRadius: AppRadius.circularMd,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.itemLabelBuilder(item),
                                  style: TextStyle(
                                    color: isSelected
                                        ? context.primaryColor
                                        : AppColors.textPrimaryLight,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: context.primaryColor,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
