import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:get/get.dart';
import 'package:haveli/controller/authentication_controller.dart';
import 'package:haveli/utils/util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'custom_textfield.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({Key? key}) : super(key: key);

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  XFile? image;
  Uint8List? bytes;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var currentUser = authenticationController.auth.currentUser;
    TextEditingController fullNameController =
        TextEditingController(text: currentUser?.displayName);
    RxBool fullNameValidator = false.obs;
    TextEditingController emailController =
        TextEditingController(text: currentUser?.email);
    RxBool emailValidator = false.obs;
    TextEditingController passwordController = TextEditingController();
    RxBool passwordValidator = false.obs;
    TextEditingController newPasswordController = TextEditingController();
    RxBool newPasswordValidator = false.obs;
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () async {
              emailValidator.value =
                  emailController.text.isEmpty ? true : false;
              passwordValidator.value =
                  passwordController.text.isEmpty|| passwordController.text.length < 6? true : false;
              fullNameValidator.value =
                  !fullNameController.text.isNotEmpty ? true : false;
              newPasswordValidator.value =
                  (newPasswordController.text.length < 6 &&
                          newPasswordController.text.isNotEmpty)
                      ? true
                      : false;
              if (emailController.text.isEmail &&
                  passwordController.text.isNotEmpty &&
                  passwordController.text.length >= 6 &&
                  (newPasswordController.text.length >= 6 ||
                      newPasswordController.text.isEmpty) &&
                  fullNameController.text.isNotEmpty) {
                showLoading();
                await authenticationController.updateUser(
                    image,
                    fullNameController.text,
                    emailController.text,
                    passwordController.text,
                    newPasswordController.text);
                Get.back();
                Get.back();
              }
            },
            child: Text("Save".tr))
      ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Stack(
                children: [
                  bytes == null
                      ? CachedNetworkImage(
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
                              const SpinKitSpinningLines(
                                  color: Colors.deepOrange),
                          errorWidget: (context, url, error) => Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: Image.asset(
                                          'assets/images/profile_pic.png')
                                      .image,
                                )),
                          ),
                        )
                      : Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: Image.memory(bytes!).image,
                              ))),
                  const Positioned(
                    top: 0,
                    right: 35,
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.orange,
                    ),
                  )
                ],
              ).onTap(() async {
                image = await picker.pickImage(source: ImageSource.gallery);
                bytes = await image?.readAsBytes();
                setState(() {});
              }),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
                label: "Full Name".tr,
                controller: fullNameController,
                inputType: TextInputType.text,
                icon: Icons.person,
                width: Get.width * 0.8,
                validate: fullNameValidator,
                validateText: "enter your fullname".tr.obs),
            CustomTextField(
                label: "Email".tr,
                controller: emailController,
                inputType: TextInputType.emailAddress,
                icon: Icons.phone,
                width: Get.width * 0.8,
                validate: emailValidator,
                validateText: "enter valid email".tr.obs),
            CustomTextField(
                label: "Current Password".tr,
                controller: passwordController,
                inputType: TextInputType.visiblePassword,
                icon: Icons.password,
                width: Get.width * 0.8,
                validate: passwordValidator,
                validateText:
                    "Incorrect Password".tr.obs),
            CustomTextField(
                label: "New Password".tr,
                controller: newPasswordController,
                inputType: TextInputType.visiblePassword,
                icon: Icons.password,
                width: Get.width * 0.8,
                validate: newPasswordValidator,
                validateText: "Password should be at least 6 characters".tr.obs)
          ],
        ),
      ),
    );
  }
}
