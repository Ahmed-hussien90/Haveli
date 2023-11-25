import 'package:flutter/material.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/controller/languageController.dart';
import 'package:haveli/view/screens/login.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxInt _value = 0.obs;
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    bottomLeft: Radius.circular(50)),
                child: Image.asset(
                  "assets/images/6.jpeg",
                  fit: BoxFit.fitHeight,
                  height: Get.height * 0.5,
                  width: Get.width,
                ).paddingBottom(10),
              ),
              Text(
                "Choose Language",
                style: GoogleFonts.aBeeZee(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.orange),
              ).paddingSymmetric(vertical: 10),
              Card(
                shadowColor: Colors.transparent,
                color: _value.value == 0
                    ? Colors.grey.withOpacity(0.6)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/syria.png",
                      width: 50,
                    ).paddingSymmetric(horizontal: 10),
                    Text(
                      "Arabic",
                      style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ).paddingSymmetric(vertical: 5),
              ).width(Get.width * 0.5).paddingSymmetric(vertical: 10).onTap(() {
                _value.value = 0;
              }),
              Card(
                shadowColor: Colors.transparent,
                color: _value.value == 1
                    ? Colors.grey.withOpacity(0.6)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/united-states.png",
                      width: 50,
                    ).paddingSymmetric(horizontal: 10),
                    Text(
                      "English",
                      style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ).paddingSymmetric(vertical: 5),
              ).width(Get.width * 0.5).paddingSymmetric(vertical: 10).onTap(() {
                _value.value = 1;
              }),
              Card(
                shadowColor: Colors.transparent,
                color: _value.value == 2
                    ? Colors.grey.withOpacity(0.6)
                    : Colors.transparent,
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/germany.png",
                      width: 50,
                    ).paddingSymmetric(horizontal: 10),
                    Text(
                      "Germany",
                      style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    )
                  ],
                ).paddingSymmetric(vertical: 5),
              ).width(Get.width * 0.5).paddingSymmetric(vertical: 10).onTap(() {
                _value.value = 2;
              }),
              ElevatedButton(
                      onPressed: () {
                        LanguageController lang = Get.put(LanguageController());
                        if (_value.value == 0) {
                          Get.updateLocale(const Locale('ar', 'EG'));
                          lang.changeLanguage(arabic);
                        } else if (_value.value == 1) {
                          Get.updateLocale(const Locale('en', 'US'));
                          lang.changeLanguage(english);
                        } else {
                          Get.updateLocale(const Locale('de', 'DE'));
                          lang.changeLanguage(german);
                        }

                        Get.to(const LoginScreen());
                      },
                      child: const Text("Next"))
                  .width(100)
                  .paddingTop(10)
            ],
          );
        }),
      ),
    );
  }
}
