import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavouriteOnly;

  ProductGrid(this.showFavouriteOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavouriteOnly ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      itemCount: products.length,
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2),
      itemBuilder: (context, it) => ChangeNotifierProvider.value(
        value: products[it],
        child: ProductItem(),
      ),
    );
  }
}
