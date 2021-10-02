import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: true);
    final cartItem=Provider.of<Cart>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 8),
          ),
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.updateFavouriteStatus();
            },
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              cartItem.addItems(product.id, product.title, product.price);
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
