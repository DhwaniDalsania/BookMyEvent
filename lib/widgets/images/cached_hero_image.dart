import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';

class CachedHeroImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? fallbackAsset;
  final Color? color;
  final IconData placeholderIcon;

  const CachedHeroImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackAsset,
    this.color,
    this.placeholderIcon = Icons.image_outlined,
  });

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mahogany.withValues(alpha: 0.8),
            AppColors.mountain.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Center(
        child: Icon(placeholderIcon, color: Colors.white24, size: 32),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: Colors.grey[900],
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white24, strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) {
        if (fallbackAsset != null) {
          return Image.asset(
            fallbackAsset!,
            width: width,
            height: height,
            fit: fit,
            color: color,
            errorBuilder: (_, _, _) => _buildPlaceholder(),
          );
        }
        return _buildPlaceholder();
      },
    );
  }
}
