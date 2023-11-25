import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';

import '../../animation/animated_switcher_wrapper.dart';
import '../../controller/authentication_controller.dart';
import 'custom_textfield.dart';

class OrderTableDialog extends StatelessWidget {
  const OrderTableDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    RxBool fullNameValidator = false.obs;
    TextEditingController phoneNumberController = TextEditingController();
    RxBool phoneNumberValidator = false.obs;
    Rx<DateTime?> datePicked = DateTime.now().obs;
    Rx<TimeOfDay?> pickedTime = TimeOfDay.now().obs;
    RxInt numberOfPerson = 1.obs;

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'table reservation'.tr,
              style: GoogleFonts.aBeeZee(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ).paddingAll(5),
            CustomTextField(
                label: "Full Name".tr,
                controller: fullNameController,
                inputType: TextInputType.text,
                icon: Icons.person,
                width: Get.width * 0.8,
                validate: fullNameValidator,
                validateText: "enter your fullname".tr.obs),
            CustomTextField(
                label: "phone number".tr,
                controller: phoneNumberController,
                inputType: TextInputType.phone,
                icon: Icons.phone,
                width: Get.width * 0.8,
                validate: phoneNumberValidator,
                validateText: "enter phone number".tr.obs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.ltr,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    onPressed: () async {
                      var now = DateTime.now();
                      datePicked.value = await DatePicker.showSimpleDatePicker(
                        context,
                        initialDate: DateTime(now.year, now.month, now.day),
                        firstDate: DateTime(2023, now.month, now.day),
                        lastDate: DateTime(2090),
                        dateFormat: "dd-MMMM-yyyy",
                        locale: DateTimePickerLocale.en_us,
                        looping: false,
                      );
                    },
                    child: Text("Choose Day".tr)),
                Obx(() => Text(
                    intl.DateFormat('dd-MM-yyyy').format(datePicked.value!)))
              ],
            ).paddingSymmetric(vertical: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.ltr,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    onPressed: () async {
                      TimeOfDay initialTime = TimeOfDay.now();
                      pickedTime.value = await showTimePicker(
                        context: context,
                        initialTime: initialTime,
                        helpText: "Choose Time".tr,
                      );
                    },
                    child: Text("Choose Time".tr)),
                Obx(() => Text(
                      intl.DateFormat("h:mm a").format(intl.DateFormat("h:mm a")
                          .parse(pickedTime.value!.format(context))),
                      textDirection: TextDirection.ltr,
                    ))
              ],
            ).paddingSymmetric(vertical: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Number of Persons".tr),
                Row(
                  children: [
                    IconButton(
                      splashRadius: 10.0,
                      onPressed: () {
                        if (numberOfPerson.value != 1) {
                          numberOfPerson.value--;
                        }
                      },
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Color(0xFFEC6813),
                      ),
                    ),
                    Obx(() {
                      return AnimatedSwitcherWrapper(
                        child: Text(
                          numberOfPerson.value.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }),
                    IconButton(
                      splashRadius: 10.0,
                      onPressed: () {
                        numberOfPerson.value++;
                      },
                      icon: const Icon(Icons.add_circle,
                          color: Color(0xFFEC6813)),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  AuthenticationController authService =
                      Get.put(AuthenticationController());
                  phoneNumberValidator.value =
                      phoneNumberController.text.isEmpty ? true : false;
                  fullNameValidator.value =
                      fullNameController.text.isEmpty ? true : false;
                  if (phoneNumberController.text.isNotEmpty &&
                      fullNameController.text.isNotEmpty) {
                    var id = UniqueKey().hashCode;
                    var order = {
                      "fullName": fullNameController.text,
                      "phoneNumber": phoneNumberController.text,
                      "time": intl.DateFormat("h:mm a").format(
                          intl.DateFormat("h:mm a")
                              .parse(pickedTime.value!.format(context))),
                      "date": intl.DateFormat('dd-MM-yyyy')
                          .format(datePicked.value!),
                      "numberOfPersons": numberOfPerson.value.toString(),
                      "invoiceNumber": id
                    };
                    var contact = "491739476929";
                    var divider =
                        "----------------------------------------------------";
                    var text =
                        "*Tischreservierung*\n $divider \n $divider \n Name : ${order["fullName"]} \n $divider  \n Telefonnummer : ${order["phoneNumber"]} \n $divider \n Anzahl der Personen : ${order["numberOfPersons"]} \n $divider \n das Datum : ${order["date"]} \n $divider \n die Zeit : ${order["time"]}  \n$divider\n${"*Rechnungsnummer*"}:   $id \n";
                    try {
                      var url = "whatsapp://send?phone=$contact&text=$text";

                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      }
                      FirebaseDatabase.instance
                          .ref()
                          .child("orders_table")
                          .child(authService.auth.currentUser!.uid)
                          .push()
                          .set(order);
                      Get.back();
                    } on Exception {
                      Fluttertoast.showToast(msg: "Can't Open Whatsapp");
                    }
                  }
                },
                child: Text("Order Now".tr))
          ],
        ),
      ),
    );
  }
}