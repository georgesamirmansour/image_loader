import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'default_error_widget.dart';

enum ImageType { asset, file, network, svg, networkSvg, memory }
enum ImageShape { circle, rectangle, oval, none }

class ImageHelper extends StatelessWidget {
  /// image type is for provide different image loader with enum type
  /// it provide image changes as assets, file, network, or cached
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
  final BoxFit boxFit;

  /// error and loader Builders have default value in case of null
  final Widget? errorBuilder, loaderBuilder;

  /// default is low
  /// Quality levels for image sampling in [ImageFilter] and [Shader] objects that sample
  /// assets and for [Canvas] operations that render assets.
  ///
  /// When scaling up typically the quality is lowest at [none], higher at [low] and [medium],
  /// and for very large scale factors (over 10x) the highest at [high].
  ///
  /// When scaling down, [medium] provides the best quality especially when scaling an
  /// image to less than half its size or for animating the scale factor between such
  /// reductions. Otherwise, [low] and [high] provide similar effects for reductions of
  /// between 50% and 100% but the image may lose detail and have dropouts below 50%.
  ///
  /// To get high quality when scaling assets up and down, or when the scale is
  /// unknown, [medium] is typically a good balanced choice.
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/filter_quality.png)
  ///
  /// When building for the web using the `--web-renderer=html` option, filter
  /// quality has no effect. All assets are rendered using the respective
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

  /// curve that use to load image with animation, not applied to all type of assets
  final Curve fadeInAnime, fadeOutAnime;

  /// duration of loading image, not applied to all type of assets
  final Duration fadeInDuration, fadeOutDuration;

  /// opacity animation for image, default is null
  final Animation<double>? opacity;

  /// image repeat for repeat image , default is ImageRepeat.noRepeat
  final ImageRepeat imageRepeat;

  /// Whether to exclude this image from semantics.
  ///
  /// Useful for assets which do not contribute meaningful information to an
  /// application.
  final bool excludeFromSemantics;

  /// The center slice for a nine-patch image.
  ///
  /// The region of the image inside the center slice will be stretched both
  /// horizontally and vertically to fit the image into its destination. The
  /// region of the image above and below the center slice will be stretched
  /// only horizontally and the region of the image to the left and right of
  /// the center slice will be stretched only vertically.
  final Rect? centerSlice;

  /// Whether to continue showing the old image (true), or briefly show nothing
  /// (false), when the image provider changes. The default value is false.
  ///
  /// ## Design discussion
  ///
  /// ### Why is the default value of [gaplessPlayback] false?
  ///
  /// Having the default value of [gaplessPlayback] be false helps prevent
  /// situations where stale or misleading information might be presented.
  /// Consider the following case:
  ///
  /// We have constructed a 'Person' widget that displays an avatar [Image] of
  /// the currently loaded person along with their name. We could request for a
  /// new person to be loaded into the widget at any time. Suppose we have a
  /// person currently loaded and the widget loads a new person. What happens
  /// if the [Image] fails to load?
  ///
  /// * Option A ([gaplessPlayback] = false): The new person's name is coupled
  /// with a blank image.
  ///
  /// * Option B ([gaplessPlayback] = true): The widget displays the avatar of
  /// the previous person and the name of the newly loaded person.
  ///
  /// This is why the default value is false. Most of the time, when you change
  /// the image provider you're not just changing the image, you're removing the
  /// old widget and adding a new one and not expecting them to have any
  /// relationship. With [gaplessPlayback] on you might accidentally break this
  /// expectation and re-use the old widget.
  final bool gaplessPlayback;

  /// Whether to paint the image with anti-aliasing.
  ///
  /// Anti-aliasing alleviates the sawtooth artifact when the image is rotated.
  final bool isAntiAlias;

  /// Whether to paint the image in the direction of the [TextDirection].
  ///
  /// If this is true, then in [TextDirection.ltr] contexts, the image will be
  /// drawn with its origin in the top left (the "normal" painting direction for
  /// assets); and in [TextDirection.rtl] contexts, the image will be drawn with
  /// a scaling factor of -1 in the horizontal direction so that the origin is
  /// in the top right.
  ///
  /// This is occasionally used with assets in right-to-left environments, for
  /// assets that were designed for left-to-right locales. Be careful, when
  /// using this, to not flip assets with integral shadows, text, or other
  /// effects that will look incorrect when flipped.
  ///
  /// If this is true, there must be an ambient [Directionality] widget in
  /// scope.
  final bool matchTextDirection;

  /// A Semantic description of the image.
  ///
  /// Used to provide a description of the image to TalkBack on Android, and
  /// VoiceOver on iOS.
  final String? semanticLabel;

  ImageHelper(
      {required this.image,
      required this.imageType,
      this.imageShape = ImageShape.none,
      this.color,
      this.height,
      this.width,
      this.boxFit = BoxFit.contain,
      this.errorBuilder,
      this.filterQuality = FilterQuality.low,
      this.loaderBuilder,
      this.blendMode = BlendMode.srcIn,
      this.alignment = Alignment.center,
      this.scale = 1.0,
      this.borderRadius,
      this.defaultLoaderColor,
      this.defaultErrorBuilderColor,
      this.fadeInAnime = Curves.easeIn,
      this.fadeOutAnime = Curves.easeOut,
      this.fadeInDuration = const Duration(milliseconds: 300),
      this.fadeOutDuration = const Duration(milliseconds: 300),
      this.opacity,
      this.imageRepeat = ImageRepeat.noRepeat,
      this.excludeFromSemantics = false,
      this.centerSlice,
      this.gaplessPlayback = false,
      this.isAntiAlias = false,
      this.matchTextDirection = false,
      this.semanticLabel});

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
      case ImageType.memory:
        return memoryImage;
    }
  }

  Widget get _file => Image.file(
        File(image),
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
        scale: scale,
        opacity: opacity,
        repeat: imageRepeat,
        excludeFromSemantics: excludeFromSemantics,
        centerSlice: centerSlice,
        gaplessPlayback: gaplessPlayback,
        isAntiAlias: false,
        matchTextDirection: matchTextDirection,
        semanticLabel: semanticLabel,
      );

  Widget get _cached => CachedNetworkImage(
        imageUrl: image,
        color: color,
        colorBlendMode: blendMode,
        filterQuality: filterQuality,
        height: height,
        width: width,
        fit: boxFit,
        fadeInCurve: Curves.fastOutSlowIn,
        fadeInDuration: Duration(milliseconds: 300),
        progressIndicatorBuilder: (context, url, progress) => _loaderBuilder,
        errorWidget: (context, url, error) => _errorBuilder,
        alignment: alignment,
        matchTextDirection: matchTextDirection,
        repeat: imageRepeat,
        fadeOutCurve: fadeOutAnime,
        fadeOutDuration: fadeOutDuration,
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
        repeat: imageRepeat,
        matchTextDirection: matchTextDirection,
        isAntiAlias: isAntiAlias,
        gaplessPlayback: gaplessPlayback,
        centerSlice: centerSlice,
        excludeFromSemantics: excludeFromSemantics,
        opacity: opacity,
        semanticLabel: semanticLabel,
      );

  Widget get _svgLocalIcon => SvgPicture.asset(
        image,
        height: height,
        width: width,
        color: color,
        colorBlendMode: blendMode,
        fit: boxFit,
        alignment: alignment,
        placeholderBuilder: (context) => _errorBuilder,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        semanticsLabel: semanticLabel,
      );

  Widget get _svgNetworkIcon => SvgPicture.network(
        image,
        height: height,
        width: width,
        color: color,
        colorBlendMode: blendMode,
        fit: boxFit,
        alignment: alignment,
        placeholderBuilder: (context) => _loaderBuilder,
        semanticsLabel: semanticLabel,
        matchTextDirection: matchTextDirection,
        excludeFromSemantics: excludeFromSemantics,
      );

  Widget get memoryImage => Image.memory(
        dataFromBase64String(image),
        width: 100,
        height: 100,
        color: color,
        scale: scale,
        fit: boxFit,
        alignment: alignment,
        filterQuality: filterQuality,
        errorBuilder: (context, error, stackTrace) => _errorBuilder,
        colorBlendMode: blendMode,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        semanticLabel: semanticLabel,
        opacity: opacity,
        centerSlice: centerSlice,
        gaplessPlayback: gaplessPlayback,
        isAntiAlias: isAntiAlias,
        repeat: imageRepeat,
      );

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

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

  Widget get _errorBuilder => errorBuilder == null
      ? DefaultErrorWidget(
          alignment: alignment,
          boxFit: boxFit,
          color: color,
          height: height,
          semanticLabel: semanticLabel,
          matchTextDirection: matchTextDirection,
          excludeFromSemantics: excludeFromSemantics,
          width: width,
          blendMode: blendMode,
        )
      : errorBuilder!;

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
