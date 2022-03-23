import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;
  final Widget placeholder;
  final double width;
  final double height;
  final BoxFit fit;
  final Color? color;

  const ImageView({
    Key? key,
    required this.imageUrl,
    required this.placeholder,
    this.width = 64,
    this.height = 64,
    this.fit = BoxFit.contain,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Theme.of(context).primaryColor.withOpacity(.75),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          return (progress == null)
              ? child
              : Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes != null
                        ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                        : null,
                  ),
                );
        },
        errorBuilder: (context, exception, stackTrace) {
          return placeholder;
        },
      ),
    );
  }
}

class CircleImageView extends StatelessWidget {
  final String imageUrl;
  final Widget placeholder;
  final double width;
  final double height;
  final BoxFit fit;
  final Color? color;

  const CircleImageView({
    Key? key,
    required this.imageUrl,
    required this.placeholder,
    this.width = 64,
    this.height = 64,
    this.fit = BoxFit.contain,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: ImageView(
        imageUrl: imageUrl,
        placeholder: placeholder,
        width: width,
        height: height,
        fit: fit,
        color: color,
      ),
    );
  }
}

class RoundedImageView extends StatelessWidget {
  final String imageUrl;
  final Widget placeholder;
  final double width;
  final double height;
  final BoxFit fit;
  final Color? color;
  final BorderRadius borderRadius;

  const RoundedImageView({
    Key? key,
    required this.imageUrl,
    required this.placeholder,
    this.width = 64,
    this.height = 64,
    this.fit = BoxFit.contain,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: ImageView(
        imageUrl: imageUrl,
        placeholder: placeholder,
        width: width,
        height: height,
        fit: fit,
        color: color,
      ),
    );
  }
}

class CircleCaptionedImageView extends StatelessWidget {
  final String imageUrl;
  final Widget placeholder;
  final double width;
  final double height;
  final BoxFit fit;
  final Color? color;
  final String caption;

  const CircleCaptionedImageView({
    Key? key,
    required this.imageUrl,
    required this.placeholder,
    this.width = 64,
    this.height = 64,
    this.fit = BoxFit.contain,
    this.color,
    required this.caption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleImageView(
          imageUrl: imageUrl,
          placeholder: placeholder,
          width: width,
          height: height,
          fit: fit,
          color: color,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            width: width * 1.5,
            child: Text(caption + "\n",
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }
}