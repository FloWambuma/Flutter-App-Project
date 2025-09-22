import 'package:flutter/material.dart';

class SubtitleTextWidget extends StatelessWidget {
  final String label;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextDecoration? textDecoration;
  final int? maxLines;
  final TextOverflow? overflow;

  const SubtitleTextWidget({
    super.key,
    required this.label,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.textDecoration,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        color: color ?? Colors.black54,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontStyle: fontStyle ?? FontStyle.normal,
        decoration: textDecoration ?? TextDecoration.none,
      ),
    );
  }
}
