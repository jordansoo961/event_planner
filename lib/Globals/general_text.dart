// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class GeneralText extends StatelessWidget {
  GeneralText({
    Key? key,
    required this.text,
    this.fontSize,
    this.textColor,
    this.textAlign,
    this.fontWeight,
    this.height,
    this.decoration,
    this.fontStyle,
    this.fontFamily,
    this.thickness
  }) : super(key: key);

  String text;
  TextAlign? textAlign;
  double? fontSize, height, thickness;
  Color? textColor;
  FontWeight? fontWeight;
  TextDecoration? decoration;
  FontStyle? fontStyle;
  String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight,
        height: height,
        decoration: decoration,
        decorationThickness: thickness,
        fontStyle: fontStyle,
        fontFamily: fontFamily
      )
    );
  }
}