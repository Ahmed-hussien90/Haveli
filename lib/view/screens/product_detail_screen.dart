import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:haveli/model/order.dart';
import 'package:haveli/view/base/carousel_slider.dart';
import '../../model/db/CartProductStorage.dart';
import '../../model/product.dart';
import '../base/page_wrapper.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen(this.product, {Key? key}) : super(key: key);

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  Widget productPageView(double width, double height) {
    return Container(
      height: height * 0.42,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E6E8),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(200),
          bottomLeft: Radius.circular(200),
        ),
      ),
      child: CarouselSlider(items: product.imageUrl!),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    CartProductStorage cartProductStorage = Get.put(CartProductStorage());
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: PageWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productPageView(width, height),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title!,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "€${product.price}",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          const SizedBox(width: 3),
                          const Spacer(),
                          Text(
                            product.isAvailable!
                                ? "Available in stock".tr
                                : "Not available".tr,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "About".tr,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(product.description!),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: product.isAvailable!
                              ? () async {
                                  if (!checkInCart(product)) {
                                    cartProductStorage.addProduct(ProductOrder(
                                        quantity: "1", product: product));
                                    cartProductStorage.loadProducts();
                                  }
                                  Get.to(const CartScreen());
                                }
                              : null,
                          child: Text("Add to cart".tr),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool checkInCart(Product product) {
  CartProductStorage cartProductStorage = Get.put(CartProductStorage());
  cartProductStorage.loadProducts();
  Product? result = cartProductStorage.products
      ?.firstWhereOrNull((element) => (element.product.title == product.title &&
          element.product.description == product.description &&
          element.product.imageUrl == product.imageUrl))
      ?.product;
  if (result != null) {
    return true;
  }
  return false;
}
