import 'package:flutter/material.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InformationDialog extends StatefulWidget {
  const InformationDialog({Key? key, required this.title, required this.text})
      : super(key: key);

  final String title;
  final String text;

  @override
  State<InformationDialog> createState() => _InformationDialogState();
}

class _InformationDialogState extends State<InformationDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog( insetPadding:  const EdgeInsets.all(20),
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              widget.title.tr,
              style: GoogleFonts.aBeeZee(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            centerTitle: true),
        body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(color: Colors.red)),
          child: Center(
            child: SingleChildScrollView(
              child: Text(widget.text,
                  style: GoogleFonts.aBeeZee(fontSize: 18)),
            ),
          ).paddingSymmetric(horizontal: 10),
        ).paddingSymmetric(horizontal: 10,vertical: 5),
      ),
    );
  }
}
