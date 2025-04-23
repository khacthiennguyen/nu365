import 'package:flutter/material.dart';
import 'package:nu365/core/constants/colors.dart';

class AppText extends StatelessWidget {
  String? content;
  double? textSize;
  TextAlign? textAlign;
  Color? color;
  TextDecoration? textDecoration;
  FontWeight? fontWeight;
  FontStyle? fontStyle;
  int? maxLine;

  AppText(
      {super.key,
        required this.content,
        this.textSize,
        this.color,
        this.textAlign,
        this.textDecoration,
        this.fontWeight,
        this.fontStyle,
        this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Text(
      content ?? "",
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
          fontFamily: 'Roboto',
          decoration: textDecoration ?? TextDecoration.none,
          fontStyle: fontStyle ?? FontStyle.normal,
          fontSize: textSize ?? 16,
          color: color ?? AppColor.light,
          fontWeight: fontWeight ?? FontWeight.normal),
      overflow: maxLine != null ? TextOverflow.ellipsis : TextOverflow.visible,
      maxLines: maxLine ?? maxLine,
    );
  }
}
