import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final TextInputType inputType;
  final IconData? icon;
  final double? width;
  final RxBool validate;
  final RxString validateText;
  final double borderRadius;
  final int? maxLines;
  final double? height;

  const CustomTextField({super.key,
    required this.label,
    required this.controller,
    required this.inputType,
    this.icon,
    required this.validate,
    required this.validateText,
    this.maxLines,
    this.height,
    this.width,
    this.borderRadius = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Center(
        child: Obx(() {
          return TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
                filled: true,
                prefixIcon: icon == null ? null : Icon(icon,color: Colors.orange),
                hintText: label,
                hintStyle: const TextStyle(color: Colors.grey),
                label: label == null ? null : Text(
                  label!, style: const TextStyle(color: Colors.orange),),
                errorText: validate.value ? validateText.value : null,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                        width: 0.5, color: Colors.black.withOpacity(0.6))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                        width: 0.5, color: Colors.black.withOpacity(0.6)))),
            keyboardType: inputType,
          );
        }),
      ),
    ).paddingAll(8);
  }
}
