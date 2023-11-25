import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hive/hive.dart';

import '../../model/product.dart';


class FavProductStorage extends GetxController {
  late Box<Product> productsBox;
  List<Product> products= <Product>[];

  @override
  void onInit() async {
    productsBox = await Hive.openBox<Product>("Products_storage");
    loadProducts();
    super.onInit();
  }

  void addProduct(Product product) {
    productsBox.add(product);
    loadProducts();
    update();
  }

  void loadProducts() {
    products= productsBox.values.toList();
    update();
  }

  Future<void> deleteProducts(int index) async {
    await productsBox.deleteAt(index);
    update();
  }

  Future<void> deleteAllProducts() async {
    await productsBox.clear();
    products.clear();
    update();
  }

  Future<void> updateProduct(int index, Product product) async {
    await productsBox.putAt(index, product);
  }
}
