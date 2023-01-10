import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/utils/Constants.dart';

class Product extends ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> updateFavouriteStatus(String token,String userId) async {
    var oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.put(Uri.parse(Constants.BASE_URL + 'userFavorites/$userId/$id.json?auth=$token'),
          body: jsonEncode(isFavorite));

    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
