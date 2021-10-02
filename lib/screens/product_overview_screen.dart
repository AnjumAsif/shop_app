import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_grid.dart';

enum FilterOptions { FAVOURITE, ALL }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavouriteOnly = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(child: ch, value: cart.itemsCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions item) {
              //this approach used when we go with app wise state maintain
              // if (item == FilterOptions.FAVOURITE) {
              //   //for favourite
              //   // productItem.showFavouriteOnly();
              // } else {
              //   //for all
              //   // productItem.showAll();
              // }

              //this approach used for local widget state maintain
              setState(() {
                if (item == FilterOptions.FAVOURITE)
                  _showFavouriteOnly = true;
                else
                  _showFavouriteOnly = false;
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('All Favourites'),
                value: FilterOptions.FAVOURITE,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.ALL,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGrid(_showFavouriteOnly),
    );
  }
}
