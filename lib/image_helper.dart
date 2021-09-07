import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImageType { asset, file, network, svg, networkSvg }
enum ImageShape { circle, rectangle, oval, none }

class ImageHelper extends StatelessWidget {
  /// image type is for provide different image loader with enum type
  /// it provide image changes as asset, file, network, or cached
  final ImageType imageType;

  /// image shape is for define the shape around the image
  /// as provided circle , rounded or none
  final ImageShape imageShape;

  /// image path is the path of the image that will be loaded from
  final String image;

  /// color for change tint image with different color, by default it's null
  final Color? color, defaultLoaderColor, defaultErrorBuilderColor;

  /// image height and width , by default is null
  final double? height, width;

  /// change image fit into source, default is null
  final BoxFit? boxFit;

  /// error and loader Builders have default value in case of null
  final Widget? errorBuilder, loaderBuilder;

  /// default is low
  /// Quality levels for image sampling in [ImageFilter] and [Shader] objects that sample
  /// images and for [Canvas] operations that render images.
  ///
  /// When scaling up typically the quality is lowest at [none], higher at [low] and [medium],
  /// and for very large scale factors (over 10x) the highest at [high].
  ///
  /// When scaling down, [medium] provides the best quality especially when scaling an
  /// image to less than half its size or for animating the scale factor between such
  /// reductions. Otherwise, [low] and [high] provide similar effects for reductions of
  /// between 50% and 100% but the image may lose detail and have dropouts below 50%.
  ///
  /// To get high quality when scaling images up and down, or when the scale is
  /// unknown, [medium] is typically a good balanced choice.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/filter_quality.png)
  ///
  /// When building for the web using the `--web-renderer=html` option, filter
  /// quality has no effect. All images are rendered using the respective
  /// browser's default setting.
  ///
  /// See also:
  ///
  ///  * [Paint.filterQuality], which is used to pass [FilterQuality] to the
  ///    engine while using drawImage calls on a [Canvas].
  ///  * [ImageShader].
  ///  * [ImageFilter.matrix].
  ///  * [Canvas.drawImage].
  ///  * [Canvas.drawImageRect].
  ///  * [Canvas.drawImageNine].
  ///  * [Canvas.drawAtlas].
  final FilterQuality filterQuality;

  /// change image blend mode
  final BlendMode blendMode;

  /// How to align the image within its bounds.
  ///
  /// The alignment aligns the given position in the image to the given position
  /// in the layout bounds. For example, an [Alignment] alignment of (-1.0,
  /// -1.0) aligns the image to the top-left corner of its layout bounds, while an
  /// [Alignment] alignment of (1.0, 1.0) aligns the bottom right of the
  /// image with the bottom right corner of its layout bounds. Similarly, an
  /// alignment of (0.0, 1.0) aligns the bottom middle of the image with the
  /// middle of the bottom edge of its layout bounds.
  ///
  /// To display a subpart of an image, consider using a [CustomPainter] and
  /// [Canvas.drawImageRect].
  ///
  /// If the [alignment] is [TextDirection]-dependent (i.e. if it is a
  /// [AlignmentDirectional]), then an ambient [Directionality] widget
  /// must be in scope.
  ///
  /// Defaults to [Alignment.center].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final Alignment alignment;

  /// image scale , default value is 1.0
  final double scale;

  /// work only when [ImageShape.rectangle]
  /// If non-null, the corners of this box are rounded by this [BorderRadius].
  ///
  /// Applies only to boxes with rectangular shapes; ignored if [shape] is not
  /// [BoxShape.rectangle].
  ///
  /// {@macro flutter.painting.BoxDecoration.clip}
  final BorderRadiusGeometry? borderRadius;

  ImageHelper(
      {required this.image,
      required this.imageType,
      this.imageShape = ImageShape.none,
      this.color,
      this.height,
      this.width,
      this.boxFit,
      this.errorBuilder,
      this.filterQuality = FilterQuality.low,
      this.loaderBuilder,
      this.blendMode = BlendMode.srcIn,
      this.alignment = Alignment.center,
      this.scale = 1.0,
      this.borderRadius,
      this.defaultLoaderColor,
      this.defaultErrorBuilderColor});

  @override
  Widget build(BuildContext context) {
    switch (imageShape) {
      case ImageShape.circle:
        return _circle;
      case ImageShape.rectangle:
        return _rounded;
      case ImageShape.none:
        return _loadImage;
      case ImageShape.oval:
        return _oval;
    }
  }

  Widget get _rounded => Container(
        child: _loadImage,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: borderRadius),
      );

  Widget get _circle => Container(
        child: _loadImage,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(shape: BoxShape.circle),
      );

  Widget get _oval => ClipOval(
        child: _loadImage,
        clipBehavior: Clip.antiAlias,
      );

  Widget get _loadImage {
    switch (imageType) {
      case ImageType.asset:
        return _asset;
      case ImageType.file:
        return _file;
      case ImageType.network:
        return _cached;
      case ImageType.svg:
        return _svgLocalIcon;
      case ImageType.networkSvg:
        return _svgNetworkIcon;
    }
  }

  Widget get _svgLocalIcon => SvgPicture.asset(
        image,
        height: height,
        width: width,
        color: color,
        fit: boxFit!,
        placeholderBuilder: (context) => _errorBuilder,
      );

  Widget get _svgNetworkIcon => SvgPicture.network(
        image,
        height: height,
        width: width,
        color: color,
        fit: boxFit!,
        placeholderBuilder: (context) => _loaderBuilder,
      );

  Widget get _file => Image.file(File(image),
      color: color,
      cacheHeight: height!.toInt(),
      cacheWidth: width!.toInt(),
      height: height,
      width: width,
      fit: boxFit,
      errorBuilder: (context, error, stackTrace) => _errorBuilder,
      filterQuality: filterQuality,
      colorBlendMode: blendMode,
      alignment: alignment,
      scale: scale);

  Widget get _cached => CachedNetworkImage(
        imageUrl: image,
        color: color,
        colorBlendMode: blendMode,
        filterQuality: filterQuality,
        height: height,
        width: width,
        fit: boxFit,
        progressIndicatorBuilder: (context, url, progress) => _loaderBuilder,
        errorWidget: (context, url, error) => _errorBuilder,
        alignment: alignment,
      );

  Widget get _asset => Image.asset(
        image,
        alignment: alignment,
        fit: boxFit,
        width: width,
        height: height,
        filterQuality: filterQuality,
        colorBlendMode: blendMode,
        color: color,
        scale: scale,
        errorBuilder: (context, error, stackTrace) => _errorBuilder,
      );

  Widget get _loaderBuilder => Center(
        child: SizedBox(
          width: _loaderWidth,
          height: _loaderHeight,
          child: FittedBox(
            child: _loader,
            fit: BoxFit.contain,
          ),
        ),
      );

  Widget get _errorBuilder => FittedBox(
        fit: BoxFit.contain,
        child: errorBuilder == null ? _defaultErrorBuilder : errorBuilder!,
      );

  Widget get _defaultErrorBuilder => Icon(
        Icons.image_not_supported_rounded,
        color: defaultErrorBuilderColor,
        size: _imageNotFoundHeight > _imageNotFoundWidth
            ? _imageNotFoundWidth
            : _imageNotFoundHeight,
      );

  double get _imageNotFoundHeight => height != null ? height! / 2 : 30.0;

  double get _imageNotFoundWidth => width != null ? width! / 2 : 30.0;

  Widget get _loader => loaderBuilder == null
      ? CircularProgressIndicator(
          color: defaultLoaderColor,
          backgroundColor: Colors.transparent,
        )
      : loaderBuilder!;

  double get _loaderWidth => width != null
      ? width! > 100
          ? 50.0
          : 30.0
      : 30.0;

  double get _loaderHeight => height != null
      ? height! > 100
          ? 50.0
          : 30.0
      : 30.0;
}
