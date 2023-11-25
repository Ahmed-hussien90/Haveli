import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:haveli/model/order.dart';
import 'package:hive/hive.dart';

import '../../model/product.dart';


class CartProductStorage extends GetxController {
  late Box<ProductOrder> productsBox;
  List<ProductOrder>? products;

  @override
  void onInit() async {
    productsBox = await Hive.openBox<ProductOrder>("cart_storage");
    loadProducts();
    super.onInit();
  }

  void addProduct(ProductOrder product) {
    productsBox.add(product);
    loadProducts();
    update();
  }

  void loadProducts() {
    products = productsBox.values.toList();
    update();
  }

  Future<void> deleteProducts(int index) async {
    await productsBox.deleteAt(index);
    loadProducts();
  }

  Future<void> deleteAllProducts() async {
    await productsBox.clear();
    products?.clear();
    update();
  }

  Future<void> updateProduct(int index, ProductOrder product) async {
    print(index.toString()+"    "+product.quantity);
    await productsBox.putAt(index, product);
    print(productsBox.getAt(index)?.quantity);
    print(productsBox.getAt(index)?.toJson());
    loadProducts();
  }
}
