import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BoxFit? fit;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.placeholder,
    this.errorWidget,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return placeholder ?? _defaultPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      placeholder: (context, url) => placeholder ?? _defaultPlaceholder(),
      errorWidget: (context, url, error) => errorWidget ?? _defaultErrorWidget(),
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _defaultErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Icon(
        Icons.error,
        color: Colors.grey,
      ),
    );
  }
}
