import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/utils/Constants.dart';

class Products extends ChangeNotifier {
  String _token;
  String _userId;

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // )
  ];

  Products(this._token, this._userId, this._items);

  //this approach used when we go with app wise state maintain
  // var _showFavouriteOnly = false;

  List<Product> get items {
    //this approach used when we go with app wise state maintain
    /* if (_showFavouriteOnly)
      return _items.where((element) => element.isFavorite).toList();*/
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

//this approach used when we go with app wise state maintain
  /*void showFavouriteOnly(){
    _showFavouriteOnly=true;
    notifyListeners();
  }
  void showAll(){
    _showFavouriteOnly=false;
    notifyListeners();
  }*/

  Product findByIdItems(String id) {
    return _items.firstWhere((element) => element.id == id, orElse: () => null);
  }

  Future<void> fetchProductData(bool filterByUser) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$_userId"' : "";
    try {
      final response = await http.get(Uri.parse(
          Constants.BASE_URL + 'product.json?auth=$_token&$filterString'));
      final extractData = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Product> tempList = [];
      final favoriteResponse = await http.get(Uri.parse(
          Constants.BASE_URL + 'userFavorites/$_userId.json?auth=$_token'));
      final favoriteData = json.decode(favoriteResponse.body);
      extractData.forEach((prodId, value) {
        tempList.add(
          Product(
            id: prodId,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = tempList;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(Product products) async {
    http
        .post(
      Uri.parse(Constants.BASE_URL + 'product.json?auth=$_token'),
      body: json.encode({
        'title': products.title,
        'description': products.description,
        'imageUrl': products.imageUrl,
        'price': products.price,
        'creatorId': _userId
      }),
    )
        .then((value) {
      print(jsonDecode(value.body));
      final temp = Product(
          title: products.title,
          description: products.description,
          price: products.price,
          imageUrl: products.imageUrl,
          id: jsonDecode(value.body)['name']);
      _items.add(temp);
      notifyListeners();
    });
  }

  Future<void> updateProduct(String id, Product newProducts) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      await http.patch(
          Uri.parse(Constants.BASE_URL + 'product/$id.json?auth=$_token'),
          body: jsonEncode({
            'title': newProducts.title,
            'description': newProducts.description,
            'imageUrl': newProducts.imageUrl,
            'price': newProducts.price,
            'creatorId': _userId
          }));
      _items[prodIndex] = newProducts;
      notifyListeners();
    } else {
      print('nothing to update');
    }
  }

  void deleteSingleProduct(String id) async {
    final existingProductId = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductId];
    final response = await http.delete(
        Uri.parse(Constants.BASE_URL + 'product/$id.json?auth=$_token'));
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    if (response.statusCode >= 400) {
      _items.insert(existingProductId, existingProduct);
      notifyListeners();
      throw HttpException('Account can not delete');
    }

    existingProduct = null;
  }
}
