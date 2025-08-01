// Project imports:
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.fontSize,
    this.height,
    this.fontWeight,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.fontFamily,
    this.fontStyle,
    this.style,
    this.decoration,
  });
  final String text;
  final Color? color;
  final double? fontSize;
  final double? height;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final TextStyle? style;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: true,
      style:
          style ??
          TextStyle(
            decoration: decoration,
            decorationColor: color,
            height: height ?? 1.2,
            fontStyle: fontStyle,
            fontSize: fontSize,
            fontFamily: fontFamily,
            fontWeight: fontWeight,
            color: color,
          ),
    );
  }
}
