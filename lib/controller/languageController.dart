import 'dart:ui';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

const String arabic = "Arabic";
const String english = "English";
const String german = "German";

class LanguageController extends GetxController {
  final RxString language = english.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentLanguage();
  }

  Future<void> changeLanguage(String eng) async {
    language.value = eng;
    Box languageBox = await Hive.openBox("language");
    languageBox.put("lang", eng);
  }

  void _loadCurrentLanguage() async {
    Box languageBox = await Hive.openBox("language");
    language.value = languageBox.get("lang") ?? english;
  }
}

loadCurrentLanguage() async {
  Box languageBox = await Hive.openBox("language");
  var language = languageBox.get("lang") ?? english;
  if (language == english) {
    Get.updateLocale(const Locale('en', 'US'));
  } else if (language == arabic) {
    Get.updateLocale(const Locale('ar', 'EG'));
  }else{
    Get.updateLocale(const Locale('de', 'DE'));
  }
}
