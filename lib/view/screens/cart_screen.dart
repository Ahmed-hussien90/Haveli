import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/controller/authentication_controller.dart';
import 'package:haveli/view/screens/product_detail_screen.dart';

import '../../animation/animated_switcher_wrapper.dart';
import '../../model/db/CartProductStorage.dart';
import '../../model/order.dart';
import '../../model/product.dart';
import '../base/empty_cart.dart';
import '../base/order_dialog.dart';
import 'login.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "My cart".tr,
        style: GoogleFonts.aBeeZee(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.orange),
      ),
    );
  }

  Widget cartList(CartProductStorage controller) {
    RxDouble total = 0.0.obs;
      if (controller.products != null &&
          controller.products!.isNotEmpty) {
        for (var pro in controller.products!) {
          total.value += pro.product.price!.replaceAll(',', '.')
              .toDouble() *
              pro.quantity.toInt();
        }
      } else {
        total.value = 0.0;
      }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: controller.products?.length,
              itemBuilder: (context, index) {
                ProductOrder product = controller.products![index];
                int quantity = controller.products![index].quantity.toInt();

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[200]?.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange,
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: CachedNetworkImage(
                                width: 100,
                                height: 90,
                                imageUrl: product.product.imageUrl![0],
                                imageBuilder: (context, imageProvider) =>
                                    ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const SpinKitSpinningLines(
                                        color: Colors.red),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.product.title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            (product.product.oldPrice != null ||
                                    product.product.oldPrice!.isNotEmpty ||
                                    product.product.oldPrice != "0")
                                ? "€${product.product.price}"
                                : "€${product.product.oldPrice}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                splashRadius: 10.0,
                                onPressed: () {
                                  if (quantity != 1) {
                                    quantity--;
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      total.value -= controller
                                          .products![index].product.price!.replaceAll(',', '.')
                                          .toDouble();
                                    });
                                    controller.updateProduct(
                                        index,
                                        ProductOrder(
                                            quantity: quantity.toString(),
                                            product: product.product));
                                  }
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: Color(0xFFEC6813),
                                ),
                              ),
                              AnimatedSwitcherWrapper(
                                child: Text(
                                  quantity.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                splashRadius: 10.0,
                                onPressed: () {
                                  quantity++;
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    total.value += controller
                                        .products![index].product.price!.replaceAll(",", ".")
                                        .toDouble();
                                    print(total.value.toDouble());
                                  });
                                  controller.updateProduct(
                                      index,
                                      ProductOrder(
                                          quantity: quantity.toString(),
                                          product: product.product));
                                },
                                icon: const Icon(Icons.add,
                                    color: Color(0xFFEC6813)),
                              ),
                            ],
                          )),
                      IconButton(
                          onPressed: () => controller.deleteProducts(index),
                          icon: const Icon(Icons.delete, color: Colors.red))
                    ],
                  ),
                ).onTap(() {
                  Get.to(ProductDetailScreen(product.product));
                });
              }),
        ),
        Container(
          width: Get.width,
          height: 50,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total".tr,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              ),
              AnimatedSwitcherWrapper(
                child: Obx(
                  () => Text(
                    total.value.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFEC6813),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 90,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
              onPressed: () {
                AuthenticationController authService =
                    Get.put(AuthenticationController());

                if (authService.auth.currentUser != null) {
                  Get.dialog(
                      OrderDialog(
                          products: controller.products!,
                          total: total.value.toStringAsFixed(2)),
                      barrierDismissible: false);
                } else {
                  Fluttertoast.showToast(
                      msg: "Please Login to Order Products".tr,
                      gravity: ToastGravity.CENTER,
                      toastLength: Toast.LENGTH_LONG);
                  Get.to(const LoginScreen());
                }
              },
              child: Text("Buy Now".tr),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CartProductStorage(),
        builder: (cartProductStorage) {
          return Scaffold(
              appBar: _appBar(context),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: cartProductStorage.products != null
                        ? cartProductStorage.products!.isNotEmpty
                            ? cartList(cartProductStorage)
                            : const EmptyCart()
                        : const SpinKitSpinningLines(
                            color: Colors.red,
                          ),
                  )
                ],
              ));
        });
  }
}
