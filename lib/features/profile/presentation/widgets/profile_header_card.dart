import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/color_utils.dart';
import '../../domain/entities/profile_entity.dart';
import '../../../../core/presentation/widgets/custom_cached_image.dart';
import 'profile_header_badges.dart';

class ProfileHeaderCard extends StatelessWidget {
  final ProfileEntity profile;

  const ProfileHeaderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final initials = profile.name.isNotEmpty
        ? profile.name
              .trim()
              .split(' ')
              .take(2)
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .join()
        : 'U';

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadius.circularXxl,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            context.primaryLight,
            context.primaryColor,
            context.primaryDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryShadow,
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -30,
            left: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildAvatar(context, initials),
                  const SizedBox(height: 16),
                  Text(
                    profile.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${profile.username}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ProfileHeaderBadges(profile: profile),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String initials) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: (profile.avatar != null && profile.avatar!.isNotEmpty)
            ? CustomCachedImage(
                imageUrl: profile.avatar!,
                fit: BoxFit.cover,
                width: 92,
                height: 92,
                memCacheWidth: 200,
                memCacheHeight: 200,
                errorWidget: _initialsWidget(context, initials),
              )
            : _initialsWidget(context, initials),
      ),
    );
  }

  Widget _initialsWidget(BuildContext context, String initials) {
    return Container(
      color: Colors.white.withValues(alpha: 0.25),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
