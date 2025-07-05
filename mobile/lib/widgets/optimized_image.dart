import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Optimized image widget that handles both network and local images
/// with memory management and caching
class OptimizedImage extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int? memCacheWidth;
  final int? memCacheHeight;

  const OptimizedImage({
    super.key,
    this.imageUrl,
    this.imageFile,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.memCacheWidth,
    this.memCacheHeight,
  }) : assert(imageUrl != null || imageFile != null, 'Either imageUrl or imageFile must be provided');

  @override
  Widget build(BuildContext context) {
    // Handle network images with caching
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memCacheWidth ?? 300,
        memCacheHeight: memCacheHeight ?? 300,
        placeholder: placeholder != null 
          ? (context, url) => placeholder!
          : (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
        errorWidget: errorWidget != null
          ? (context, url, error) => errorWidget!
          : (context, url, error) => const Icon(
              Icons.error,
              color: Colors.red,
            ),
      );
    }

    // Handle local files with memory optimization
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: memCacheWidth,
        cacheHeight: memCacheHeight,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? const Icon(
            Icons.error,
            color: Colors.red,
          );
        },
      );
    }

    return errorWidget ?? const Icon(
      Icons.error,
      color: Colors.red,
    );
  }
}

/// Optimized image widget specifically for prescription images
class PrescriptionImage extends StatelessWidget {
  final File imageFile;
  final double? width;
  final double? height;
  final BoxFit fit;
  final VoidCallback? onTap;

  const PrescriptionImage({
    super.key,
    required this.imageFile,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = OptimizedImage(
      imageFile: imageFile,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: 400, // Optimized for prescription images
      memCacheHeight: 400,
      placeholder: const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 48,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
