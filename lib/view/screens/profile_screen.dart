import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/view/base/profile_dialog.dart';
import 'package:haveli/view/screens/home.dart';
import 'package:haveli/view/screens/order_table_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../../controller/authentication_controller.dart';
import '../../controller/languageController.dart';
import '../../controller/theme_controller.dart';
import '../base/information_dialgo.dart';
import 'login.dart';
import 'order_details.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxString selectedDropDownValue = Get.locale == const Locale('ar', 'EG')
        ? 'Arabic'.obs
        : Get.locale == const Locale('en', 'US')
            ? 'English'.obs
            : "German".obs;
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings".tr,
            style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.orange)),
      ),
      body: GetBuilder(
        init: AuthenticationController(),
        builder: (authenticationController) {
          var currentUser = authenticationController.auth.currentUser;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CachedNetworkImage(
                    imageUrl: currentUser!.photoURL ?? "",
                    width: 200,
                    height: 100,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider),
                      ),
                    ),
                    placeholder: (context, url) =>
                    const SpinKitSpinningLines(color: Colors.deepOrange),
                    errorWidget: (context, url, error) => Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: Image.asset('assets/images/profile_pic.png')
                                .image,
                          )),
                    ),
                  ),
                ),
                authenticationController.auth.currentUser != null
                    ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${currentUser.displayName}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.dialog(const ProfileDialog());
                                },
                                icon: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.orange,
                                ))
                          ],
                        ),
                        Text(
                          "${currentUser.email}",
                          style: const TextStyle(fontSize: 17),
                        ),
                      ],
                    )
                    : Column(
                        children: [
                          Text(
                            "you are not login".tr,
                            style: GoogleFonts.aBeeZee(fontSize: 18),
                          ),
                          Text(
                            "Login".tr,
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.orange),
                          ).onTap(() {
                            Get.to(const LoginScreen());
                          })
                        ],
                      ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    EvaIcons.home,
                    color: Colors.orange,
                  ),
                  title: Text(
                    'Home'.tr,
                    style: GoogleFonts.aBeeZee(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Get.back();
                    Get.to(const Home());
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.delivery_dining_outlined,
                    color: Colors.orange,
                  ),
                  title: Text(
                    'Orders'.tr,
                    style: GoogleFonts.aBeeZee(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    if (authenticationController.auth.currentUser != null) {
                      Get.to(const OrderDetails());
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please Login to Show Orders".tr,
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_LONG);
                      Get.to(const LoginScreen());
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.table_restaurant_rounded,
                    color: Colors.orange,
                  ),
                  title: Text(
                    'table reservation'.tr,
                    style: GoogleFonts.aBeeZee(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    if (authenticationController.auth.currentUser != null) {
                      Get.dialog(OrderTableScreen());
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please Login to Show Orders".tr,
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_LONG);
                      Get.to(const LoginScreen());
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.language,
                    color: Colors.orange,
                  ),
                  title: GetBuilder(
                      init: LanguageController(),
                      builder: (languageController) {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              focusColor: Colors.transparent,
                              onChanged: (String? newValue) {
                                if (newValue == 'Arabic') {
                                  Get.updateLocale(const Locale('ar', 'EG'));
                                  languageController.changeLanguage(arabic);
                                } else if (newValue == 'English') {
                                  Get.updateLocale(const Locale('en', 'US'));
                                  languageController.changeLanguage(english);
                                } else {
                                  Get.updateLocale(const Locale('de', 'DE'));
                                  languageController.changeLanguage(german);
                                }
                                selectedDropDownValue.value = newValue!;
                              },
                              items: <String>['English', 'Arabic', 'German']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.tr),
                                );
                              }).toList(),
                              value: selectedDropDownValue.value,
                              icon: Icon(Get.locale == const Locale('ar', 'EG')
                                  ? Icons.keyboard_arrow_left
                                  : Icons.keyboard_arrow_right),
                              iconSize: 24,
                              elevation: 16),
                        );
                      }),
                  onTap: () async {},
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    EvaIcons.info,
                    color: Colors.orange,
                  ),
                  title: Text('About Us'.tr,
                      style: GoogleFonts.aBeeZee(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  onTap: () async {
                    var text = (await FirebaseDatabase.instance
                            .ref()
                            .child("aboutus")
                            .get())
                        .value
                        .toString();
                    Get.dialog(InformationDialog(title: "About Us", text: text));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    EvaIcons.phoneCall,
                    color: Colors.orange,
                  ),
                  title: Text('Contact'.tr,
                      style: GoogleFonts.aBeeZee(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  onTap: () async {
                    var text = (await FirebaseDatabase.instance
                            .ref()
                            .child("contactus")
                            .get())
                        .value
                        .toString();
                    Get.dialog(InformationDialog(title: "Contact", text: text));
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    EvaIcons.star,
                    color: Colors.orange,
                  ),
                  title: Text('Rate Us'.tr,
                      style: GoogleFonts.aBeeZee(
                          fontSize: 17, fontWeight: FontWeight.bold)),
                  onTap: () async {
                    var shareLink = (await FirebaseDatabase.instance
                            .ref()
                            .child("rateus")
                            .get())
                        .value
                        .toString();
                    Share.share(shareLink);
                  },
                ),
                const Divider(),
                GetBuilder(
                    init: ThemeController(),
                    builder: (themeController) {
                      return ListTile(
                        leading: CupertinoSwitch(
                            value: themeController.darkTheme.value,
                            onChanged: (value) {
                              themeController.darkMode(value);
                            }),
                        title: Text('Dark Mode'.tr,
                            style: GoogleFonts.aBeeZee(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        onTap: () async {},
                      );
                    }),
                const Divider(),
                Visibility(
                  visible: true,
                  child: ListTile(
                    leading: const Icon(
                      EvaIcons.logOut,
                      color: Colors.orange,
                    ),
                    title: Text('Logout'.tr,
                        style: GoogleFonts.aBeeZee(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    onTap: () async {
                      Get.dialog(
                        AlertDialog(
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Are you sure you want to logout?".tr,
                                style: GoogleFonts.aBeeZee(color: Colors.orange),
                              )
                            ],
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("cancel".tr)),
                            ElevatedButton(
                                onPressed: () async {
                                  await authenticationController.logOut();
                                },
                                child: Text("Logout".tr)),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
