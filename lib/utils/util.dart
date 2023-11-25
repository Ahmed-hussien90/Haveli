import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haveli/model/db/CartProductStorage.dart';
import 'package:haveli/model/order.dart';

import '../model/db/FavProductStorage.dart';
import '../model/product.dart';

likeButtonPressed(Product product, FavProductStorage favProductStorage) {
  favProductStorage.loadProducts();
  if (!checkFav(product, favProductStorage)) {
    favProductStorage.addProduct(product);
  } else {
    favProductStorage.deleteProducts(favProductStorage.products.indexWhere(
        (element) =>
            product.title == element.title &&
            product.description == element.description &&
            product.imageUrl![0] == element.imageUrl![0]));
  }
  favProductStorage.loadProducts();
}

bool checkFav(Product product, FavProductStorage favProductStorage) {
  Product? result = favProductStorage.products.firstWhereOrNull((element) =>
      (element.title == product.title &&
          element.description == product.description &&
          element.imageUrl![0] == product.imageUrl![0]));
  if (result != null) {
    return true;
  }
  return false;
}

ProductOrder? checkCart(Product product, CartProductStorage cartProductStorage) {
  ProductOrder? result = cartProductStorage.products
      ?.firstWhereOrNull((element) => (element.product.title == product.title &&
          element.product.description == product.description &&
          element.product.imageUrl![0] == product.imageUrl![0]));
  return result;
}

Future<String> uploadImage(
    Uint8List imageFile, String path, String? fileName) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child('$path/$fileName');
  UploadTask uploadTask = ref.putData(imageFile);
  // Wait for the upload to complete
  TaskSnapshot taskSnapshot = await uploadTask;
  // Get the download URL of the uploaded image
  String downloadURL = await taskSnapshot.ref.getDownloadURL();
  return downloadURL;
}

showLoading() {
  Get.dialog(
      AlertDialog(
          content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: SpinKitCircle(color: Colors.orange)),
          Text(
            "Loading...".tr,
            style: GoogleFonts.aBeeZee(color: Colors.orange),
          )
        ],
      )),
      barrierDismissible: false);
}