import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/controller/authentication_controller.dart';
import 'package:haveli/view/base/order_table_dialog.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OrderTableScreen extends StatefulWidget {
  const OrderTableScreen({Key? key}) : super(key: key);

  @override
  State<OrderTableScreen> createState() => _OrderTableScreenState();
}

class _OrderTableScreenState extends State<OrderTableScreen> {
  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationService =
        Get.put(AuthenticationController());
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "table reservation".tr,
            style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          centerTitle: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          onPressed: () {
            Get.dialog(OrderTableDialog());
          },
          child: Text("Order table reservation".tr),
        ),
        body: StreamBuilder(
            stream: FirebaseDatabase.instance
                .ref()
                .child("orders_table")
                .child(authenticationService.auth.currentUser!.uid)
                .onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                var data =
                    snapshot.data?.snapshot.children.toList().reversed.toList();
                if (data == null || data.isEmpty) {
                  return Center(
                    child: Text("There is No Orders".tr),
                  );
                }
                return ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var order = data[index].value as Map;
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 10,
                        child: Column(
                          children: [
                            Visibility(
                              visible: (order["canceled"] != null &&
                                  order["canceled"]),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                      size: 25,
                                    ),
                                    Text(
                                      "Order Canceled".tr,
                                      style: GoogleFonts.aBeeZee(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    )
                                  ]),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Full Name".tr,
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange)),
                                const SizedBox(width: 8),
                                Text(order["fullName"])
                              ],
                            ),
                            Row(
                                textDirection: TextDirection.ltr,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/plat.svg",
                                    height: 80,
                                    width: 80,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("phone number".tr,
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange)),
                                          const SizedBox(width: 8),
                                          Text(order["phoneNumber"])
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Number of Persons".tr,
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange)),
                                          const SizedBox(width: 8),
                                          Text(order["numberOfPersons"]
                                              .toString())
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Date".tr,
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange)),
                                          const SizedBox(width: 8),
                                          Text(order["date"])
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Time".tr,
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange)),
                                          const SizedBox(width: 8),
                                          Text(order["time"])
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Invoice Number'.tr,
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange)),
                                          const SizedBox(width: 8),
                                          Text(
                                              order["invoiceNumber"].toString())
                                        ],
                                      ),
                                      Visibility(
                                        visible: (order["canceled"] == null ||
                                            !order["canceled"]),
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Get.dialog(AlertDialog(
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "Are you sure you want to delete this order?"
                                                        .tr,
                                                    style: GoogleFonts.aBeeZee(
                                                        color: Colors.orange),
                                                  )
                                                ],
                                              ),
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text("Cancel".tr)),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      var contact =
                                                          "491739476929";
                                                      var text =
                                                          "*Tischreservierung*\n\n${"*Bestellung stornieren*"} \n----------------------\n ${"*Rechnungsnummer*"}:   ${order["invoiceNumber"]}";
                                                      try {
                                                        var url =
                                                            "whatsapp://send?phone=$contact&text=$text";

                                                        if (await canLaunchUrl(
                                                            Uri.parse(url))) {
                                                          await launchUrl(
                                                              Uri.parse(url));
                                                        }
                                                        data[index]
                                                            .ref
                                                            .child("canceled")
                                                            .set(true);
                                                        Get.back();
                                                      } catch (e) {
                                                        print(e.toString());
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Can't Open Whatsapp");
                                                      }
                                                    },
                                                    child: Text("Delete".tr)),
                                              ],
                                            ));
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent),
                                          icon: const Icon(Icons.cancel,
                                              color: Colors.red),
                                          label: Text("Cancel Order".tr),
                                        ),
                                      )
                                    ],
                                  )
                                ]),
                          ],
                        ).paddingAll(10),
                      );
                    });
              } else {
                return const Center(child: SpinKitCircle(color: Colors.orange));
              }
            }));
  }
}
