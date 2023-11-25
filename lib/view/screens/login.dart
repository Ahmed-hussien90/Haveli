import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:get/get.dart';
import 'package:haveli/controller/authentication_controller.dart';
import 'package:haveli/view/screens/home.dart';

import '../base/custom_button.dart';
import '../base/custom_textfield.dart';
import '../base/icon_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(50), bottomLeft: Radius.circular(50)),
          child: Image.asset(
            "assets/images/2.jpeg",
            fit: BoxFit.fitHeight,
            height: Get.height * 0.5,
            width: Get.width,
          ).paddingBottom(10),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            child: Container(
              color: Colors.grey.withOpacity(0.1),
              child: Column(
                children: [
                  TabBar(
                    unselectedLabelColor: Colors.white,
                    labelColor: Colors.white,
                    indicator: const BoxDecoration(color: Colors.orangeAccent),
                    tabs: [
                      Tab(
                        text: 'Login'.tr,
                      ),
                      Tab(
                        text: 'Sign Up'.tr,
                      )
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [loginWidget(), signUpWidget()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  loginWidget() {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    RxBool emailValidator = false.obs;
    RxBool passwordValidator = false.obs;
    var passwordValidatorText =
        "Password should be at least 6 characters".tr.obs;
    AuthenticationController authenticationService =
    Get.put(AuthenticationController());

    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
                  width: Get.width * 0.7,
                  label: "Email".tr,
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  icon: Icons.email,
                  validate: emailValidator,
                  validateText: "enter valid email".tr.obs)
              .paddingTop(10),
          CustomTextField(
              width: Get.width * 0.7,
              label: "Password".tr,
              controller: passwordController,
              inputType: TextInputType.visiblePassword,
              icon: Icons.lock,
              validate: passwordValidator,
              validateText: passwordValidatorText),
          CustomIconButton(
                  icon: Image.asset(
                    "assets/images/google.png",
                    height: 30,
                  ),
                  width: Get.width * 0.65,
                  text: "Log in with Google".tr,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onClick: () async {
                    User? user = await authenticationService.signInWithGoogle();
                    if (user != null) {
                      Get.offAll(const MyHomePage());
                    }
                  })
              .paddingAll(5),
          CustomButton(
              width: Get.width * 0.4,
              text: "Log in".tr,
              backgroundColor: Colors.orange,
              onClick: () async {
                emailValidator.value =
                    !emailController.text.isEmail ? true : false;
                if (passwordController.text.isEmpty ||
                    passwordController.text.length < 6) {
                  passwordValidator.value = true;
                  passwordController.text.isEmpty
                      ? passwordValidatorText.value =
                          "Password Can Not Be Empty".tr
                      : passwordValidatorText.value =
                          "Password should be at least 6 characters".tr;
                } else {
                  passwordValidator.value = false;
                }
                if (emailController.text.isEmail &&
                    passwordController.text.isNotEmpty &&
                    passwordController.text.length >= 6) {
                  User? user =
                  await authenticationService.signInWithEmailAndPassword(
                      emailController.text, passwordController.text);
                  if (user != null) {
                    Get.offAll(const MyHomePage());
                  } else {
                    passwordValidator.value = true;
                    passwordValidatorText.value =
                        "Incorrect Password or Email".tr;
                  }
                }
              }).paddingSymmetric(vertical: 10),
        ],
      ).paddingTop(20),
    );
  }

  signUpWidget() {
    TextEditingController emailController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    RxBool emailValidator = false.obs;
    RxBool passwordValidator = false.obs;
    RxBool usernameValidator = false.obs;
    var passwordValidatorText =
        "Password should be at least 6 characters".tr.obs;
    AuthenticationController authenticationService =
    Get.put(AuthenticationController());

    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                width: Get.width * 0.7,
                label: "Username".tr,
                controller: usernameController,
                inputType: TextInputType.text,
                icon: Icons.person,
                validate: usernameValidator,
                validateText: "enter valid username".tr.obs),
            CustomTextField(
                width: Get.width * 0.7,
                label: "Email".tr,
                controller: emailController,
                inputType: TextInputType.emailAddress,
                icon: Icons.email,
                validate: emailValidator,
                validateText: "enter valid email".tr.obs),
            CustomTextField(
                width: Get.width * 0.7,
                label: "Password".tr,
                controller: passwordController,
                inputType: TextInputType.visiblePassword,
                icon: Icons.lock,
                validate: passwordValidator,
                validateText: passwordValidatorText),
            CustomIconButton(
                icon: Image.asset(
                  "assets/images/google.png",
                  height: 30,
                ),
                width: Get.width * 0.65,
                text: "SignUp with Google".tr,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onClick: () async {
                  User? user = await authenticationService.signInWithGoogle();
                  if (user != null) {
                    Get.offAll(const MyHomePage());
                  }
                }),
            CustomButton(
                width: Get.width * 0.4,
                text: "Sign Up".tr,
                backgroundColor: Colors.orange,
                onClick: () async {
                  emailValidator.value =
                      !emailController.text.isEmail ? true : false;
                  usernameValidator.value =
                      !usernameController.text.isNotEmpty ? true : false;
                  if (passwordController.text.isEmpty ||
                      passwordController.text.length < 6) {
                    passwordValidator.value = true;
                    passwordController.text.isEmpty
                        ? passwordValidatorText.value =
                            "Password Can Not Be Empty".tr
                        : passwordValidatorText.value =
                            "Password should be at least 6 characters".tr;
                  } else {
                    passwordValidator.value = false;
                  }
                  if (emailController.text.isEmail &&
                      passwordController.text.isNotEmpty &&
                      passwordController.text.length >= 6 &&
                      usernameController.text.isNotEmpty) {
                    User? user =
                        await authenticationService.signUpWithEmailAndPassword(
                            usernameController.text,
                            emailController.text,
                            passwordController.text);
                    if (user != null) {
                      Get.offAll(const MyHomePage());
                    } else {
                      passwordValidator.value = true;
                      passwordValidatorText.value =
                          "Incorrect Password or Email".tr;
                    }
                  }
                }).paddingSymmetric(vertical: 10),
          ]).paddingTop(20),
    );
  }
}
