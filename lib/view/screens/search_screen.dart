import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_utils_project/flutter_utils_project.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../animation/open_container_wrapper.dart';
import '../../model/db/FavProductStorage.dart';
import '../../model/product.dart';
import '../../utils/util.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.searchText}) : super(key: key);

  final String searchText;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    RxString searchText = widget.searchText.obs;
    TextEditingController controller =
        TextEditingController(text: widget.searchText);
    return Scaffold(
      body: Obx(() {
        return Column(children: [
          CupertinoSearchTextField(
            controller: controller,
            style: const TextStyle(color: Colors.orange),
            onSubmitted: (text) {
              searchText.value = text;
            },
            decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(20)),
          ).width(Get.width).paddingSymmetric(horizontal: 8).center(),
          FutureBuilder(
              future: searchProducts(searchText.value),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  var products = snapshot.data as List<Product>?;
                  if (products == null || products.isEmpty) {
                    return Center(
                      child: Text("No Products Found".tr),
                    );
                  }
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: GridView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (_, index) {
                          var product = products[index];
                          return OpenContainerWrapper(
                            product: product,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.white,
                              shadowColor: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    height: 90,
                                    width: 70,
                                    imageUrl: product.imageUrl?[0],
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image:
                                            DecorationImage(image: imageProvider),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const SpinKitSpinningLines(
                                            color: Colors.deepOrange),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Text(product.title!.length > 26?
                                    "${product.title!.toString().substring(0, 25)}...":product.title!,
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
                                          init: FavProductStorage(),
                                          builder: (favStorage) {
                                            return IconButton(
                                              onPressed: () async {
                                                await likeButtonPressed(
                                                    product, favStorage);
                                                favStorage.loadProducts();
                                              },
                                              icon: Icon(
                                                EvaIcons.heart,
                                                color:
                                                    checkFav(product, favStorage)
                                                        ? Colors.red
                                                        : Colors.grey,
                                              ).paddingAll(5),
                                            );
                                          })
                                    ],
                                  ).paddingSymmetric(horizontal: 5)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return const Center(
                      child: SpinKitSpinningLines(
                    color: Colors.deepOrange,
                  ));
                }
              })
        ]).paddingTop(35);
      }),
    );
  }

  searchProducts(String keyword) async {
    print("mmmmmmmmmm");
    List<Product> products = [];
    var cats = await FirebaseDatabase.instance.ref().child("categories").get();
    for (var c in cats.children.toList()) {
      var pros = await c.child("products").ref.get();
      for (var product in pros.children.toList()) {
        var result = Product.fromJson(product.value);
        if (result.title.toString().contains(keyword)) products.add(result);
      }
    }
    return products;
  }
}
