import 'package:flutter/material.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';

class CustomIconButton extends StatelessWidget {
  final Widget icon;
  final double width;
  final double height;
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onClick;

  const CustomIconButton(
      {Key? key,
      required this.icon,
      required this.width,
      this.height = 45,
      required this.text,
      this.fontWeight = FontWeight.bold,
      this.fontSize = 16,
      required this.backgroundColor,
      required this.onClick,
      this.textColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onClick,
      icon: icon,
      label: Text(
        text,
        style: TextStyle(
            fontWeight: fontWeight, fontSize: fontSize, color: textColor),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    ).width(width).withHeight(height);
  }
}
