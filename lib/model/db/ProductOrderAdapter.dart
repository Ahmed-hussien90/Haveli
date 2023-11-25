import 'package:hive/hive.dart';

import '../../model/product.dart';
import '../order.dart';

class ProductOrderAdapter extends TypeAdapter<ProductOrder> {
  @override
  final int typeId = 3;

  @override
  ProductOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductOrder(
        quantity: fields[0] as String,
        product: fields[1] as Product,
    );
  }

  @override
  void write(BinaryWriter writer, ProductOrder obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.product);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
