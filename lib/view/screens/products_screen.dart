import 'package:flutter/material.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/view/base/products_grid.dart';

import '../../model/db/CartProductStorage.dart';
import 'cart_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen(
      {Key? key, required this.products, required this.category})
      : super(key: key);

  final List products;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GetBuilder(
          init: CartProductStorage(),
          builder: (cart) {
            var total = 0.0;
            var productCount= 0;
            if (cart.products != null) {
              for (var product in cart.products!) {
                total += product.product.price!.replaceAll(",", ".").toDouble() * product.quantity.toInt();
                productCount += product.quantity.toInt();
              }
            }
            return Visibility(
              visible:
              cart.products != null ? cart.products!.isNotEmpty : false,
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(const CartScreen());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(total.toString()),
                      Text("Show Shopping Cart".tr),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white.withOpacity(0.3)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: cart.products != null
                              ? Text(productCount.toString())
                              : Text("0"))
                    ],
                  )).width(Get.width).paddingSymmetric(horizontal: 20),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: Text(category,
            style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.deepOrange)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10,bottom: 70,right: 10,left: 10),
          child: ProductsGrid(products: products, length: products.length),
        ),
      ),
    );
  }
}
