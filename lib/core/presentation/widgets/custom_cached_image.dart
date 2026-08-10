import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_colors.dart';

class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double borderRadius;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.memCacheWidth,
    this.memCacheHeight,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius = 0,
  });

  static final CacheManager customCacheManager = CacheManager(
    Config(
      'codra_image_cache',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 200,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        cacheManager: customCacheManager,
        placeholder: (context, url) =>
            placeholder ??
            Shimmer.fromColors(
              baseColor: AppColors.backgroundLight,
              highlightColor: Colors.white,
              child: Container(
                width: width ?? double.infinity,
                height: height ?? double.infinity,
                color: Colors.white,
              ),
            ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              color: AppColors.backgroundLight,
              child: const Icon(
                Icons.image_not_supported_rounded,
                color: AppColors.textSecondaryLight,
              ),
            ),
      ),
    );
  }
}
