import 'comic.dart';

class CartDetail {
  final int id;
  final Comic comic;
  final double price;
  int quantity;
  double subTotal;

  CartDetail({
    required this.id,
    required this.comic,
    required this.price,
    required this.quantity,
    required this.subTotal,
  });

  factory CartDetail.fromJson(Map<String, dynamic> json) {
    return CartDetail(
      id: json['id'],
      comic: Comic.fromJson(json['comic']),
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      subTotal: json['subTotal'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comic': comic.toJson(),
      'price': price,
      'quantity': quantity,
      'subTotal': subTotal,
    };
  }

  @override
  String toString() {
    return 'CartDetail{id: $id, comic: $comic, price: $price, quantity: $quantity, subTotal: $subTotal}';
  }

}
