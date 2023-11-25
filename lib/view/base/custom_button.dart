import 'package:flutter/material.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';

class CustomButton extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onClick;

  const CustomButton(
      {Key? key,
      required this.width,
      this.height = 45,
      required this.text,
      this.fontWeight = FontWeight.bold,
      this.fontSize = 16,
      required this.backgroundColor,
      this.textColor = Colors.white,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: textColor,),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10))),
      child: Text(text),
    ).width(width).withHeight(height);
  }
}
