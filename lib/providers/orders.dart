import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/utils/Constants.dart';

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

  Future<void> fetchOrders(String token) async {
    var response =
        await http.get(Uri.parse(Constants.BASE_URL + 'orders.json?auth=$token'));

    print(jsonDecode(response.body));
    final extractData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extractData == null) return;
    final List<OrderItems> tempList = [];
    extractData.forEach((orderId, value) {
      tempList.add(
        OrderItems(
          id: orderId,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
          dateTime: DateTime.parse(value['dateTime']),
        ),
      );
    });

    _orders = tempList.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total, String token) async {
    var timeStamp = DateTime.now();
    var response =
        await http.post(Uri.parse(Constants.BASE_URL + 'orders.json?auth=$token'),
            body: jsonEncode({
              'amount': total,
              'dateTime': timeStamp.toIso8601String(),
              'products': cartProduct
                  .map((cp) => {
                        'id': cp.id,
                        'title': cp.title,
                        'price': cp.price,
                        'quantity': cp.quantity
                      })
                  .toList()
            }));
    print(response.body);

    _orders.insert(
      0,
      OrderItems(
        id: jsonDecode(response.body)['name'],
        amount: total,
        products: cartProduct,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
