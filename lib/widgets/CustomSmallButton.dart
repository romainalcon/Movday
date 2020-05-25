import 'package:Movday/widgets/CustomText.dart';
import 'package:flutter/material.dart';

class CustomSmallButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final FontColor fontColor;
  final FontSize fontSize;
  final FontWeight fontWeight;
  final void Function() onPressed;
  final Color backgroundColor;
  final Color borderColor;

  CustomSmallButton({
    @required this.text,
    @required this.onPressed,
    @required this.fontColor,
    @required this.backgroundColor,
    @required this.borderColor,
    this.fontWeight = FontWeight.normal,
    this.fontSize = FontSize.sm,
    this.icon
  });

  Widget build(BuildContext context) {
    List<Widget> listWidget = [];
    
    listWidget.add(
      CustomText(
        text: this.text,
        fontColor: this.fontColor,
        fontSize: this.fontSize,
        fontWeight: this.fontWeight,
      )
    );

    if (this.icon != null) {
      listWidget.add(
        Icon(
          this.icon,
          size: CustomText.textSize(fontSize),
          color: CustomText.textColor(fontColor),
        )
      );
    }

    return GestureDetector(
      onTap: this.onPressed,
      child: Container(
        decoration: new BoxDecoration(
          color: backgroundColor,
          borderRadius: new BorderRadius.all(const Radius.circular(5)),
          border: Border.all(
            color: borderColor,
            width: 1
          )
        ),
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
        child: Row(children: listWidget),
      ),
    );

  }

}