import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/localization/locale_keys.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/color_utils.dart';
import '../../../domain/entities/property_details_entity.dart';
import '../../cubit/details/property_details_cubit.dart';
import '../../cubit/details/property_details_state.dart';

class PropertyOwnersTab extends StatelessWidget {
  final PropertyDetailsEntity property;

  const PropertyOwnersTab({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PropertyDetailsCubit, PropertyDetailsState>(
      listener: (context, state) {
        if (state is PropertyDetailsLoaded && state.actionOwnerId == null && !state.isMakingRepresentative) {
          // Success is implied if we go from isMakingRepresentative = true back to false.
          // The easiest way to show success without complex previous state tracking is just checking if we were loading.
          // But since listener fires often, we shouldn't show it randomly. We'll skip the toast for now or rely on the UI update (the crown icon moves).
        }
      },
      builder: (context, state) {
        final currentProperty = state is PropertyDetailsLoaded ? state.property : property;
        final actionOwnerId = state is PropertyDetailsLoaded ? state.actionOwnerId : null;
        final isMakingRep = state is PropertyDetailsLoaded ? state.isMakingRepresentative : false;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocaleKeys.propertyDetailsOwners.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              if (currentProperty.owners.isEmpty)
                Center(child: Text(LocaleKeys.propertyDetailsNoOwners.tr()))
              else
                ...currentProperty.owners.map((owner) => Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  color: owner.isRepresentative ? context.primaryColor.withValues(alpha: 0.03) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: owner.isRepresentative ? context.primaryColor : Colors.grey.withValues(alpha: 0.2)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: owner.isRepresentative ? context.primaryColor.withValues(alpha: 0.1) : context.primarySubtle,
                      child: Icon(
                        owner.isRepresentative ? Icons.workspace_premium_rounded : Icons.person,
                        color: context.primaryColor,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(owner.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (owner.isRepresentative) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.workspace_premium_rounded, color: context.primaryColor, size: 16),
                        ],
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(owner.phone ?? LocaleKeys.propertyDetailsNoPhone.tr()),
                        const SizedBox(height: 12),
                        if (owner.isRepresentative)
                           Align(
                             alignment: AlignmentDirectional.centerEnd,
                             child: state is PropertyDetailsLoaded && state.isRemovingRepresentative && actionOwnerId == owner.id
                               ? Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                   child: SizedBox(
                                     width: 20, height: 20,
                                     child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red.shade400),
                                   ),
                                 )
                               : Material(
                                   color: Colors.transparent,
                                   child: InkWell(
                                     onTap: () {
                                       context.read<PropertyDetailsCubit>().removeRepresentative(currentProperty.id, owner.id);
                                     },
                                     borderRadius: BorderRadius.circular(8),
                                     child: Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                       decoration: BoxDecoration(
                                         color: Colors.red.shade50,
                                         borderRadius: BorderRadius.circular(8),
                                         border: Border.all(color: Colors.red.shade100),
                                       ),
                                       child: Row(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           Icon(Icons.person_remove_rounded, size: 16, color: Colors.red.shade600),
                                           const SizedBox(width: 6),
                                           Text(
                                             LocaleKeys.propertyDetailsRemoveRepresentative.tr(),
                                             style: TextStyle(fontSize: 12, color: Colors.red.shade600, fontWeight: FontWeight.bold),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                           ),
                        if (!owner.isRepresentative)
                           Align(
                             alignment: AlignmentDirectional.centerEnd,
                             child: isMakingRep && actionOwnerId == owner.id
                               ? Padding(
                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                   child: SizedBox(
                                     width: 20, height: 20,
                                     child: CircularProgressIndicator(strokeWidth: 2, color: context.primaryColor),
                                   ),
                                 )
                               : Material(
                                   color: Colors.transparent,
                                   child: InkWell(
                                     onTap: () {
                                       context.read<PropertyDetailsCubit>().makeRepresentative(currentProperty.id, owner.id);
                                     },
                                     borderRadius: BorderRadius.circular(8),
                                     child: Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                       decoration: BoxDecoration(
                                         color: context.primaryColor.withValues(alpha: 0.05),
                                         borderRadius: BorderRadius.circular(8),
                                         border: Border.all(color: context.primaryColor.withValues(alpha: 0.1)),
                                       ),
                                       child: Row(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           Icon(Icons.how_to_reg_rounded, size: 16, color: context.primaryColor),
                                           const SizedBox(width: 6),
                                           Text(
                                             LocaleKeys.propertyDetailsMakeRepresentative.tr(),
                                             style: TextStyle(fontSize: 12, color: context.primaryColor, fontWeight: FontWeight.bold),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                           ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${owner.percentage}%',
                        style: TextStyle(color: context.primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )),
                
              const SizedBox(height: 24),
              Text(LocaleKeys.propertyDetailsDeedAndDocs.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDocRow('رقم الصك', currentProperty.deedNumber ?? '-'),
                      const Divider(),
                      _buildDocRow('تاريخ الصك', currentProperty.deedDate ?? '-'),
                      const Divider(),
                      _buildDocRow('نوع الوثيقة', currentProperty.documentType ?? '-'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDocRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
