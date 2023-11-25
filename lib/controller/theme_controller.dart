import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ThemeController extends GetxController {
  ThemeController() {
    _loadCurrentTheme();
  }

  @override
  void onInit() {
    _loadCurrentTheme();
    updateThemeState();
    super.onInit();
  }

  final RxBool _darkTheme = true.obs;

  RxBool get darkTheme => _darkTheme;

  Future<void> darkMode(bool theme) async {
    darkTheme.value = theme;
    Box darkThemeBox = await Hive.openBox("dark_mode");
    darkThemeBox.put("dark", theme);
    _loadCurrentTheme();
    updateThemeState();
  }

  void _loadCurrentTheme() async {
    Box darkThemeBox = await Hive.openBox("dark_mode");
    _darkTheme.value = darkThemeBox.get("dark") ?? true;
    update();
  }
}

updateThemeState() async {
  Box darkThemeBox = await Hive.openBox("dark_mode");
  bool isDarkTheme = await darkThemeBox.get("dark") ?? true;
  Get.changeThemeMode(isDarkTheme ? ThemeMode.dark : ThemeMode.light);
}

