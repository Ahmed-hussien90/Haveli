import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/model/db/CartProductStorage.dart';
import 'package:haveli/model/order.dart';
import '../../animation/open_container_wrapper.dart';
import '../../model/db/FavProductStorage.dart';
import '../../model/product.dart';
import '../../utils/util.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key, required this.products, required this.length})
      : super(key: key);

  final List products;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 8 / 10,
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 7.0,
        ),
        itemCount: length,
        itemBuilder: (context, index) {
          var product = Product.fromJson(products[index].value);
          return OpenContainerWrapper(
            product: product,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              shadowColor: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GetBuilder(
                        init: FavProductStorage(),
                        builder: (favStorage) {
                          return IconButton(
                            onPressed: () async {
                              await likeButtonPressed(product, favStorage);
                              favStorage.loadProducts();
                            },
                            icon: Icon(
                              EvaIcons.heart,
                              color: checkFav(product, favStorage)
                                  ? Colors.red
                                  : Colors.grey,
                            ).paddingAll(5),
                          );
                        }),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        height: 90,
                        width: 70,
                        imageUrl: product.imageUrl?[0],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(image: imageProvider),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const SpinKitSpinningLines(
                                color: Colors.deepOrange),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Text(
                        product.title!.length > 26
                            ? "${product.title!.toString().substring(0, 25)}..."
                            : product.title!,
                        style: GoogleFonts.aBeeZee(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      Row(
                        children: [
                          Text(
                            "${product.price}€",
                            style: GoogleFonts.aBeeZee(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ).paddingAll(10),
                          const Spacer(),
                          GetBuilder(
                              init: CartProductStorage(),
                              builder: (cart) {
                                int quantity = 0;
                                if (checkCart(product, cart) != null) {
                                  quantity = checkCart(product, cart)!
                                      .quantity
                                      .toInt();
                                }
                                return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.white.withOpacity(0.3)),
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        Visibility(
                                            visible: checkCart(product, cart) !=
                                                null,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.remove,
                                                  color: Colors.orange,
                                                  size: 22,
                                                ).onTap(() {
                                                  int idx = cart.products!.indexOf(
                                                      checkCart(product, cart)!);
                                                  if(quantity!=1) {
                                                    cart.updateProduct(
                                                      idx,
                                                      ProductOrder(
                                                          quantity:
                                                          (--quantity).toString(),
                                                          product: checkCart(
                                                              product, cart)!
                                                              .product));
                                                  }else{
                                                    cart.deleteProducts(idx);
                                                  }
                                                }).paddingAll(3),
                                                Text(
                                                  quantity.toString(),
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                )
                                              ],
                                            )),
                                        const Icon(
                                          Icons.add,
                                          color: Colors.orange,
                                          size: 20,
                                        ).onTap(() {
                                          if (checkCart(product, cart) ==
                                              null) {
                                            cart.addProduct(ProductOrder(
                                                quantity: "1",
                                                product: product));
                                          } else {
                                            int idx = cart.products!.indexOf(
                                                checkCart(product, cart)!);
                                            cart.updateProduct(
                                                idx,
                                                ProductOrder(
                                                    quantity:
                                                    (++quantity).toString(),
                                                    product: checkCart(
                                                            product, cart)!
                                                        .product));
                                          }
                                        }).paddingAll(4),
                                      ],
                                    )).paddingSymmetric(vertical: 5,horizontal: 5);
                              })
                        ],
                      ).paddingSymmetric(horizontal: 5,vertical: 4)
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
