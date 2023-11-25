import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/controller/authentication_controller.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/product.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationService =
        Get.put(AuthenticationController());
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Order Details".tr,
            style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseDatabase.instance
                .ref()
                .child("orders")
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
                            Column(
                              children: [
                                Visibility(
                                  visible: order["OrderProgress"] != null &&
                                      order["OrderProgress"] == "delivered",
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          "DELIVERED".tr,
                                          style: GoogleFonts.aBeeZee(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        )
                                      ]),
                                ),
                                Visibility(
                                  visible: (order["canceled"]!=null&&order["canceled"]),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    itemCount: order["productOrder"].length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemBuilder: (_, index) {
                                      var product = Product.fromJson(
                                          order["productOrder"][index]
                                              ["product"]);
                                      return Column(children: [
                                        Image.network(
                                          product.imageUrl![0],
                                          width: 200,
                                          height: 170,
                                        ),
                                        Text(
                                          product.title!.length > 25
                                              ? "${product.title!.substring(0, 23)}...."
                                              : product.title!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 3),
                                        Row(children: [
                                          Text(
                                            (product.oldPrice != null ||
                                                    product
                                                        .oldPrice!.isNotEmpty ||
                                                    product.oldPrice != "0")
                                                ? "€${product.price}"
                                                : "€${product.oldPrice}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                          const SizedBox(width: 3),
                                        ]),
                                        Text(
                                          "${"Quantity".tr} :  ${order["productOrder"][index]["quantity"]}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ).paddingTop(5)
                                      ]);
                                    },
                                  ),
                                ).paddingAll(3),
                                Table(
                                  textDirection: TextDirection.ltr,
                                  border: TableBorder.all(
                                      color: Colors.orange,
                                      width: 2,
                                      borderRadius: BorderRadius.circular(10)),
                                  children: [
                                    TableRow(children: [
                                      Center(
                                        child: Text('Full Name'.tr,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            .paddingAll(5),
                                      ),
                                      Text(order["fullName"],
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.normal))
                                          .paddingAll(5)
                                    ]),
                                    TableRow(children: [
                                      Center(
                                        child: Text('Address'.tr,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            .paddingAll(5),
                                      ),
                                      Text(order["address"],
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.normal))
                                          .paddingAll(5)
                                    ]),
                                    TableRow(children: [
                                      Center(
                                        child: Text('Phone Number'.tr,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            .paddingAll(5),
                                      ),
                                      Text(order["phoneNumber"],
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.normal))
                                          .paddingAll(5)
                                    ]),
                                    TableRow(children: [
                                      Center(
                                        child: Text('Delivery Type'.tr,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            .paddingAll(5),
                                      ),
                                      Text(
                                              order["deliveryType"]
                                                          .toString() ==
                                                      "0"
                                                  ? "Delivery at the restaurant"
                                                      .tr
                                                  : "Home delivery".tr,
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.normal))
                                          .paddingAll(5)
                                    ]),
                                    TableRow(children: [
                                      Center(
                                        child: Text('Total Price'.tr,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            .paddingAll(5),
                                      ),
                                      Text(order["total"],
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.normal))
                                          .paddingAll(5)
                                    ]),
                                    TableRow(children: [
                                      Center(
                                        child: Text('Invoice Number'.tr,
                                                style: GoogleFonts.aBeeZee(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            .paddingAll(5),
                                      ),
                                      Text(order["invoiceNumber"].toString(),
                                              style: GoogleFonts.aBeeZee(
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight.normal))
                                          .paddingAll(5)
                                    ])
                                  ],
                                ).paddingAll(12),
                                Visibility(
                                  visible: (order["canceled"]==null||!order["canceled"]),
                                  child: Center(
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(maxHeight: 80),
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        reverse: Get.locale == const Locale('ar', 'EG'),
                                        shrinkWrap: true,
                                        children: [
                                          TimelineTile(
                                            axis: TimelineAxis.horizontal,
                                            alignment: TimelineAlign.center,
                                            isFirst: true,
                                            indicatorStyle:
                                                const IndicatorStyle(
                                              height: 20,
                                              color: Colors.orange,
                                            ),
                                            beforeLineStyle: LineStyle(
                                              color: (order["OrderProgress"] !=
                                                              null &&
                                                          (order["OrderProgress"] ==
                                                              "toDelivery") ||
                                                      order["OrderProgress"] ==
                                                          "delivered")
                                                  ? Colors.orange
                                                  : Colors.grey,
                                              thickness: 6,
                                            ),
                                            endChild: Text(
                                              "ORDERED".tr,
                                              style: const TextStyle(
                                                  color: Colors.orange),
                                            ).paddingAll(5),
                                          ),
                                          TimelineTile(
                                            axis: TimelineAxis.horizontal,
                                            alignment: TimelineAlign.center,
                                            beforeLineStyle: LineStyle(
                                              color: (order["OrderProgress"] !=
                                                              null &&
                                                          (order["OrderProgress"] ==
                                                              "toDelivery") ||
                                                      order["OrderProgress"] ==
                                                          "delivered")
                                                  ? Colors.orange
                                                  : Colors.grey,
                                              thickness: 6,
                                            ),
                                            afterLineStyle: LineStyle(
                                              color: (order["OrderProgress"] !=
                                                          null &&
                                                      order["OrderProgress"] ==
                                                          "delivered")
                                                  ? Colors.orange
                                                  : Colors.grey,
                                              thickness: 6,
                                            ),
                                            indicatorStyle: IndicatorStyle(
                                              height: 20,
                                              color: (order["OrderProgress"] !=
                                                              null &&
                                                          (order["OrderProgress"] ==
                                                              "toDelivery") ||
                                                      order["OrderProgress"] ==
                                                          "delivered")
                                                  ? Colors.orange
                                                  : Colors.grey,
                                            ),
                                            endChild: Text(
                                                    "OUT FOR DELIVERY".tr,
                                                    style: const TextStyle(
                                                        color: Colors.orange))
                                                .paddingAll(5),
                                          ),
                                          TimelineTile(
                                            axis: TimelineAxis.horizontal,
                                            alignment: TimelineAlign.center,
                                            isLast: true,
                                            beforeLineStyle: LineStyle(
                                              color: (order["OrderProgress"] !=
                                                          null &&
                                                      order["OrderProgress"] ==
                                                          "delivered")
                                                  ? Colors.orange
                                                  : Colors.grey,
                                              thickness: 6,
                                            ),
                                            indicatorStyle: IndicatorStyle(
                                              height: 20,
                                              color: (order["OrderProgress"] !=
                                                          null &&
                                                      order["OrderProgress"] ==
                                                          "delivered")
                                                  ? Colors.orange
                                                  : Colors.grey,
                                            ),
                                            endChild: Text(
                                              "DELIVERED".tr,
                                              style: const TextStyle(
                                                  color: Colors.orange),
                                            ).paddingAll(5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Visibility(
                              visible: (order["canceled"]==null||!order["canceled"]),
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
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text("Cancel".tr)),
                                      ElevatedButton(
                                          onPressed: () async {
                                            var contact = "491739476929";
                                            var text = "${"*Bestellung stornieren*"} \n----------------------\n ${"*Rechnungsnummer*"}:   ${order["invoiceNumber"]}";
                                            try {
                                              var url =
                                                  "whatsapp://send?phone=$contact&text=$text";

                                              if (await canLaunchUrl(
                                                  Uri.parse(url))) {
                                                await launchUrl(Uri.parse(url));
                                              }
                                              data[index]
                                                  .ref
                                                  .child("canceled")
                                                  .set(true);
                                              Get.back();
                                            } catch (e) {
                                              print(e.toString());
                                              Fluttertoast.showToast(
                                                  msg: "Can't Open Whatsapp");
                                            }
                                          },
                                          child: Text("Delete".tr)),
                                    ],
                                  ));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent),
                                icon:
                                    const Icon(Icons.cancel, color: Colors.red),
                                label: Text("Cancel Order".tr),
                              ),
                            ),
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
