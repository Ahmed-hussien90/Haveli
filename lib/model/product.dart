
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? description;
  @HiveField(2)
  List<dynamic>? imageUrl;
  @HiveField(3)
  String? price;
  @HiveField(4)
  bool? isAvailable;
  @HiveField(5)
  String? oldPrice;

  Product(
      {required this.title,
        required this.description,
        required this.imageUrl,
        required this.price,
        required this.isAvailable,
        required this.oldPrice,
      });

  factory Product.fromJson(dynamic json) {
    return Product(
        title: json["title"],
        imageUrl: json["image"],
        description: json["description"],
        price: json['price'],
        isAvailable: json["isAvailable"],
        oldPrice: json["oldPrice"],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['image'] = imageUrl;
    map['description'] = description;
    map['price'] = price;
    map["isAvailable"] = isAvailable;
    map["oldPrice"] = oldPrice;
    return map;
  }
}
