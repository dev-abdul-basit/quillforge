import 'package:flutter/cupertino.dart';
import 'package:ainotes/app/common/constants/color_consrtant.dart';

class CustomContainer extends Container {
  CustomContainer({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.containerPadding,
    this.containerMargin,
    this.containerChild,
    this.image,
    this.gradient,
  });
  final double? width;
  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsets? containerPadding;
  final EdgeInsets? containerMargin;
  final Widget? containerChild;
  final DecorationImage? image;
  final Gradient? gradient;
  @override
  Clip get clipBehavior => Clip.hardEdge;
  @override
  BoxConstraints? get constraints => (width != null || height != null)
      ? super.constraints?.tighten(width: width, height: height) ??
          BoxConstraints.tightFor(width: width, height: height)
      : null;
  @override
  EdgeInsets get padding => containerPadding ?? EdgeInsets.zero;
  @override
  EdgeInsets get margin => containerMargin ?? EdgeInsets.zero;
  @override
  Widget? get child => containerChild;
  @override
  BoxDecoration get decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 12),
        color: backgroundColor ?? ColorCodes.background,
      );
  @override
  Decoration get foregroundDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 12),
        image: image,
        gradient: gradient,
        border: (borderWidth == null)
            ? Border.all(
                color: borderColor ?? ColorCodes.background,
                width: 1,
              )
            : (borderWidth == 0)
                ? null
                : Border.all(
                    color: borderColor ?? ColorCodes.background,
                    width: borderWidth!,
                  ),
      );
}
