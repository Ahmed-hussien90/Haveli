import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../animation/open_container_wrapper.dart';
import '../../model/db/FavProductStorage.dart';
import '../../utils/util.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite".tr,
          style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.orange)
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: GetBuilder(
              init: FavProductStorage(),
              builder: (favProductStorage) {
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: favProductStorage.products.length,
                  itemBuilder: (context, index) {
                    var product = favProductStorage.products[index];
                    return OpenContainerWrapper(
                      product: product,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
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
                                  image: DecorationImage(image: imageProvider),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const SpinKitFadingCircle(
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
                                          await likeButtonPressed(product,favStorage);
                                          favStorage.loadProducts();
                                        },
                                        icon: Icon(
                                          EvaIcons.heart,
                                          color: checkFav(product,favStorage)
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
                );
              })),
    );
  }
}
