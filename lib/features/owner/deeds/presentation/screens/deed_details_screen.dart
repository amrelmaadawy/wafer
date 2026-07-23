import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:wafer/core/theme/app_colors.dart';
import 'package:wafer/core/theme/color_utils.dart';
import '../../../../../core/presentation/widgets/custom_app_bar.dart';
import '../../../../../core/presentation/widgets/custom_error_widget.dart';
import '../../../../../core/localization/locale_keys.dart';
import '../cubit/details/deed_details_cubit.dart';
import '../cubit/details/deed_details_state.dart';
import '../widgets/details/deed_details_header.dart';
import '../widgets/details/deed_details_info_card.dart';
import '../widgets/details/deed_details_location_card.dart';
import '../widgets/details/deed_details_properties_card.dart';

class DeedDetailsScreen extends StatefulWidget {
  final int deedId;
  const DeedDetailsScreen({super.key, required this.deedId});

  @override
  State<DeedDetailsScreen> createState() => _DeedDetailsScreenState();
}

class _DeedDetailsScreenState extends State<DeedDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DeedDetailsCubit>().fetchDeedDetails(widget.deedId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: CustomAppBar(
        title: LocaleKeys.deedDetailsTitle.tr(),
      ),
      body: BlocBuilder<DeedDetailsCubit, DeedDetailsState>(
        builder: (context, state) {
          if (state is DeedDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DeedDetailsError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<DeedDetailsCubit>().fetchDeedDetails(widget.deedId),
            );
          } else if (state is DeedDetailsLoaded) {
            final deed = state.deed;
            return RefreshIndicator(
              onRefresh: () => context.read<DeedDetailsCubit>().fetchDeedDetails(widget.deedId),
              color: context.primaryColor,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  DeedDetailsHeader(deed: deed),
                  const SizedBox(height: 16),
                  DeedDetailsInfoCard(deed: deed),
                  const SizedBox(height: 16),
                  DeedDetailsLocationCard(deed: deed),
                  if (deed.notes != null && deed.notes!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildNotesCard(context, deed.notes!),
                  ],
                  if (deed.propertiesCount > 0 || deed.properties.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DeedDetailsPropertiesCard(deed: deed),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotesCard(BuildContext context, String notes) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.primarySubtle,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.note_alt_outlined, color: context.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                LocaleKeys.deedNotes.tr(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            notes,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
