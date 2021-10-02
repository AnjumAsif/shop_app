import 'package:flutter/foundation.dart';

import 'cart.dart';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItems(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders extends ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProduct, double total) {
    _orders.insert(
      0,
      OrderItems(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProduct,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
