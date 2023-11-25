import 'package:haveli/model/product.dart';
import 'package:hive/hive.dart';

List<Map<String, dynamic>> orderToJson(List<Order> data) =>
    data.map((product) => product.toJson()).toList();

List<Map<String, dynamic>> productOrderToJson(List<ProductOrder> data) =>
    data.map((product) => product.toJson()).toList();

List<Map<String, dynamic>> productToJson(List<Product> data) =>
    data.map((product) => product.toJson()).toList();

@HiveType(typeId: 2)
class Order {
  @HiveField(1)
  String address;
  @HiveField(2)
  String total;
  @HiveField(3)
  List<ProductOrder> productOrder;
  @HiveField(4)
  String phoneNumber;
  @HiveField(5)
  String fullName;

  Order(
      {required this.address,
      required this.total,
      required this.productOrder,
      required this.phoneNumber,
      required this.fullName});

  factory Order.fromJson(dynamic json) {
    return Order(
        address: json["address"],
        total: json["total"],
        productOrder: json["productOrder"],
        phoneNumber: json["phoneNumber"],
        fullName: json["fullName"]);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = address;
    map['total'] = total;
    map["productOrder"] = productOrderToJson(productOrder);
    map["phoneNumber"] = phoneNumber;
    map["fullName"] = fullName;
    return map;
  }
}

@HiveType(typeId: 3)
class ProductOrder {
  @HiveField(0)
  String quantity;
  @HiveField(1)
  Product product;

  ProductOrder({
    required this.quantity,
    required this.product,
  });

  factory ProductOrder.fromJson(dynamic json) {
    return ProductOrder(
      quantity: json["quantity"],
      product: json["product"],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['quantity'] = quantity;
    map['product'] = product.toJson();
    return map;
  }
}
