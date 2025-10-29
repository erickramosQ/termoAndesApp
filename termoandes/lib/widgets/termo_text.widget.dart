import 'package:flutter/material.dart';
import '../shared/theme/app_colors.dart';

class TermoAndesText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final double? lineHeight;

  const TermoAndesText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.lineHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme.bodySmall;

    return Text(
      text,
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(
        fontSize: fontSize ?? theme?.fontSize ?? 12,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? theme?.color ?? AppColors.darkText200,
        height: lineHeight != null
            ? lineHeight! / (fontSize ?? theme?.fontSize ?? 12)
            : theme?.height,
      ),
    );
  }
}
