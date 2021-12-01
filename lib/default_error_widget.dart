import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const String _noImageFound = 'packages/image_loader/assetFlag/noImageFound.svg';

class DefaultErrorWidget extends StatelessWidget {
  final Color? color;
  final BlendMode blendMode;
  final BoxFit boxFit;
  final Alignment alignment;
  final String? semanticLabel;
  final bool matchTextDirection;
  final bool excludeFromSemantics;
  final double? height, width;

  DefaultErrorWidget(
      {Key? key,
      this.alignment = Alignment.center,
      this.boxFit = BoxFit.contain,
      this.blendMode = BlendMode.src,
      this.semanticLabel,
      this.matchTextDirection = false,
      this.excludeFromSemantics = false,
      this.width,
      this.height,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) => _defaultErrorBuilder;

  Widget get _defaultErrorBuilder => SvgPicture.asset(
        _noImageFound,
        height: _imageNotFoundHeight,
        width: _imageNotFoundWidth,
        color: color,
        colorBlendMode: blendMode,
        fit: boxFit,
        alignment: alignment,
        excludeFromSemantics: excludeFromSemantics,
        matchTextDirection: matchTextDirection,
        semanticsLabel: semanticLabel,
      );

  double get _imageNotFoundHeight => height != null ? height! / 2 : 30.0;

  double get _imageNotFoundWidth => width != null ? width! / 2 : 30.0;
}
