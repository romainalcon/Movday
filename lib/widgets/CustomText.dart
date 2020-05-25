import 'package:flutter/material.dart';

enum FontColor {white, blue, dark, grey}

enum FontSize {xs, sm, md, lg, xl}

enum FontOpacity {max, medium, min, none}

class CustomText extends StatelessWidget {
  final String text;
  final FontColor fontColor;
  final FontSize fontSize;
  final FontWeight fontWeight;
  final FontOpacity fontOpacity;
  final TextAlign align;
  final int maxLines;
  final bool underline;
  final TextOverflow textOverflow;

  CustomText({
    @required this.text,
    @required this.fontColor,
    @required this.fontSize,
    this.fontWeight = FontWeight.normal,
    this.fontOpacity = FontOpacity.none,
    this.align = TextAlign.start,
    this.maxLines = 2,
    this.underline = false,
    this.textOverflow = TextOverflow.ellipsis
  });

  static Color textColor(FontColor fontColor) {
    Color color;
    switch (fontColor) {
      case FontColor.white:
        color = Colors.white;
        break;
      case FontColor.blue:
        color = Color(0xFF0F4C81);
        break;
      case FontColor.dark:
        color = Color(0xFF0D0D0D);
        break;
      case FontColor.grey:
        color = Color(0xFF3B3B40);
        break;
    }
    return color;
  }

  static double textSize(FontSize fontSize) {
    double size;
    switch (fontSize) {
      case FontSize.xs:
        size = 10;
        break;
      case FontSize.sm:
        size = 12;
        break;
      case FontSize.md:
        size = 14;
        break;
      case FontSize.lg:
        size = 16;
        break;
      case FontSize.xl:
        size = 18;
        break;
    }
    return size;
  }

  @override
  Widget build(BuildContext context) {
    return new Text(
      this.text,
      maxLines: this.maxLines,
      overflow: this.textOverflow,
      textAlign: align,
      style: TextStyle(
        color: textColor(this.fontColor),
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        fontWeight: fontWeight,
        fontSize: textSize(this.fontSize)
      ),
    );
  }

}