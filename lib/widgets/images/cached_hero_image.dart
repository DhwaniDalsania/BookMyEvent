import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedHeroImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? fallbackAsset;
  final Color? color;

  const CachedHeroImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fallbackAsset,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      color: color,
      placeholder: (context, url) => Container(
        color: Colors.grey[900],
        width: width,
        height: height,
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
          );
        }
        return Container(
          color: Colors.grey[900],
          width: width,
          height: height,
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.white24),
          ),
        );
      },
    );
  }
}
