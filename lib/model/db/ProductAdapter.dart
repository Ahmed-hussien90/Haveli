import 'package:hive/hive.dart';

import '../../model/product.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 1;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      title: fields[0] as String,
      description: fields[1] as String,
      imageUrl: fields[2] as List<dynamic>,
      price: fields[3] as String,
      isAvailable: fields[4] as bool,
      oldPrice: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.isAvailable)
      ..writeByte(5)
      ..write(obj.oldPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProductAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}
