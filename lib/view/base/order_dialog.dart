import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/controller/authentication_controller.dart';
import 'package:haveli/model/postal.dart';
import 'package:haveli/utils/util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/db/CartProductStorage.dart';
import '../../model/order.dart';
import '../screens/order_details.dart';
import 'custom_textfield.dart';

class OrderDialog extends StatelessWidget {
  const OrderDialog({Key? key, required this.products, required this.total})
      : super(key: key);

  final List<ProductOrder> products;
  final String total;

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    RxBool fullNameValidator = false.obs;
    TextEditingController phoneNumberController = TextEditingController();
    RxBool phoneNumberValidator = false.obs;
    TextEditingController aprtNumberController = TextEditingController();
    RxBool aprtNumberValidator = false.obs;
    TextEditingController streetController = TextEditingController();
    RxBool streetValidator = false.obs;
    RxInt deliveryType = 1.obs;
    RxInt payTybe = 1.obs;
    Rx<PostalCode> postalCode = postalCodes.first.obs;

    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
                onPressed: () async {
                  AuthenticationController authService =
                      Get.put(AuthenticationController());
                  phoneNumberValidator.value =
                      phoneNumberController.text.isEmpty ? true : false;
                  fullNameValidator.value =
                      fullNameController.text.isEmpty ? true : false;
                  aprtNumberValidator.value =
                      aprtNumberController.text.isEmpty ? true : false;
                  streetValidator.value =
                      streetController.text.isEmpty ? true : false;
                  if (phoneNumberController.text.isNotEmpty &&
                      fullNameController.text.isNotEmpty &&
                      aprtNumberController.text.isNotEmpty &&
                      streetController.text.isNotEmpty) {
                    var isRestaurantOpen = (await FirebaseDatabase.instance
                            .ref()
                            .child("admin")
                            .child("rest")
                            .get())
                        .value as bool;
                    if (!isRestaurantOpen) {
                      Fluttertoast.showToast(
                          msg:
                              "Restaurant is Closed now, please Try in another time"
                                  .tr,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.redAccent);
                      return;
                    }
                    if (total.toDouble() < 25.0 && deliveryType.value == 1) {
                      Fluttertoast.showToast(
                          msg: "The minimum order for home delivery is 25 €"
                              .tr
                              .tr,
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.redAccent);
                      return;
                    }
                    showLoading();
                    var addressText =
                        "${"Street".tr} : ${streetController.text}\n${"Apartment number".tr} : ${aprtNumberController.text}\n";
                    var addressTex2 =
                        "${"Straße"} : ${streetController.text}\n${"Wohnungsnummer"} : ${aprtNumberController.text}\n";

                    var productsText = "";
                    var divider = "-----------------------------";
                    var divider2 = "_________________________________________";
                    for (var product in products) {
                      productsText += "$divider2 \n"
                          "*${product.product.title}*\n"
                          "Menge :  ${product.quantity}\n"
                          "Preis : ${product.product.price}\n";
                    }
                    var contact = "491739476929";
                    var number = (await FirebaseDatabase.instance
                            .ref()
                            .child("admin")
                            .child("number")
                            .get())
                        .value as int;
                    await FirebaseDatabase.instance
                        .ref()
                        .child("admin")
                        .child("number")
                        .set(ServerValue.increment(1));
                    var text =
                        "*ORDER*\n\n$productsText\n$divider2\n${"*Name*"}:     ${fullNameController.text} \n$divider\n${"*Telefonnummer*"}:     ${phoneNumberController.text}\n$divider\n${"*Address*"}:   ${addressTex2}\n$divider\n${"*Lieferart*"}:    ${deliveryType.value == 0 ? "*Abholung*" : "*Lieferung*"}\n$divider\n${"*Rechnungsnummer*"}:   $number \n$divider\n${"*Liefer kostet*"}:   ${deliveryType.value == 1 ? postalCode.value.tax : "0"}€ \n$divider\n${"*Gesamtpreis*"}:   ${deliveryType.value == 0 ? total : (total.toDouble() + postalCode.value.tax)}€\n$divider2\n ${deliveryType.value == 0 ? "*●	 Die manuelle Lieferung im Restaurant dauert 10 bis 20 Minuten*" : "*●	 Die Lieferung nach Hause erfolgt innerhalb von 60 Minuten*"} ";
                    try {
                      var url = "whatsapp://send?phone=$contact&text=$text";

                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      }
                      FirebaseDatabase.instance
                          .ref()
                          .child("orders")
                          .child(authService.auth.currentUser!.uid)
                          .push()
                          .set({
                        "fullName": fullNameController.text,
                        "phoneNumber": phoneNumberController.text,
                        "address": addressText,
                        "total": total,
                        "productOrder": productOrderToJson(products),
                        "deliveryType": deliveryType.value.toString(),
                        "invoiceNumber": number,
                        "tax": postalCode.value
                      });
                      CartProductStorage cartStore =
                          Get.put(CartProductStorage());
                      await cartStore.deleteAllProducts();
                      Get.back();
                      Get.back();
                      Get.to(const OrderDetails());
                    } catch (e) {
                      print(e.toString());
                      Fluttertoast.showToast(msg: "Can't Open Whatsapp");
                    }
                  }
                },
                child: Text("Order Now".tr))
            .widthAndHeight(width: Get.width * 0.6, height: 44)
      ],
      contentPadding: const EdgeInsets.all(5),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                label: "Full Name".tr,
                controller: fullNameController,
                inputType: TextInputType.text,
                icon: Icons.person,
                width: Get.width * 0.8,
                validate: fullNameValidator,
                validateText: "enter your fullname".tr.obs),
            Text(
              "Address".tr,
              style: const TextStyle(fontSize: 15),
            ),
            CustomTextField(
                label: "Street".tr,
                controller: streetController,
                inputType: TextInputType.text,
                width: Get.width * 0.8,
                validate: streetValidator,
                validateText: "Required Field".tr.obs),
            Row(
              children: [
                Expanded(
                  flex: 6,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      contentPadding: EdgeInsets.all(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Postal Code".tr,
                          style: const TextStyle(color: Colors.orange),
                        ),
                        Obx(() {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<dynamic>(
                              value: postalCode.value,
                              isDense: true,
                              isExpanded: true,
                              items: postalCodes.map((PostalCode value) {
                                return DropdownMenuItem<PostalCode>(
                                  value: value,
                                  child: Text(value.value.toString(),
                                      style: const TextStyle(
                                          color: Colors.orange)),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                postalCode.value = newValue;
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: CustomTextField(
                        label: "Apartment number".tr,
                        controller: aprtNumberController,
                        inputType: TextInputType.number,
                        validate: aprtNumberValidator,
                        validateText: "Required Field".tr.obs)),
              ],
            ),
            CustomTextField(
                label: "phone number".tr,
                controller: phoneNumberController,
                inputType: TextInputType.phone,
                icon: Icons.phone,
                width: Get.width * 0.8,
                validate: phoneNumberValidator,
                validateText: "enter phone number".tr.obs),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: deliveryType.value == 0
                              ? Colors.green
                              : Colors.transparent),
                      child: Center(
                        child: Text(
                          "Delivery at the restaurant".tr,
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ).onTap(() {
                      deliveryType.value = 0;
                    }),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: deliveryType.value == 1
                              ? Colors.green
                              : Colors.transparent),
                      child: Center(
                        child: Text("Home delivery".tr),
                      ),
                    ).onTap(() {
                      deliveryType.value = 1;
                    }),
                  ),
                ],
              ).paddingSymmetric(horizontal: 10);
            }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: payTybe.value == 0
                              ? Colors.green
                              : Colors.transparent),
                      child: Center(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/paypal.png",
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                "Pay With Paypal".tr,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).onTap(() {
                      Fluttertoast.showToast(msg: "Not Available Now".tr);
                    }),
                  ),
                  Expanded(
                      flex: 2,
                      child: Text(
                        "Or".tr,
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: payTybe.value == 1
                              ? Colors.green
                              : Colors.transparent),
                      child: Center(
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/cash-on-delivery.png",
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                "Cash".tr,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).onTap(() {
                      payTybe.value = 1;
                    }),
                  ),
                ],
              ).paddingSymmetric(horizontal: 10);
            }),
            Text(
              "●	 ${"Hand delivery in the restaurant takes 10 to 20 minutes".tr}.",
              style: GoogleFonts.aBeeZee(color: Colors.orange),
            ).paddingSymmetric(vertical: 10),
            Text(
              "●	 ${"Home delivery is within 60 minutes".tr}.",
              style: GoogleFonts.aBeeZee(color: Colors.orange),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
