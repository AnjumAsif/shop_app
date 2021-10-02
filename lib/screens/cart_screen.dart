import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item_row.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your cart'),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15.0),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount ',
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context,listen: false).addOrder(
                            cart.items.values.toList(), cart.totalAmount);
                        cart.clear();
                      },
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, it) => CartItemRow(
                    id: cart.items.values.toList()[it].id,
                    productId: cart.items.keys.toList()[it],
                    title: cart.items.values.toList()[it].title,
                    quantity: cart.items.values.toList()[it].quantity,
                    price: cart.items.values.toList()[it].price),
              ),
            )
          ],
        ),
      ),
    );
  }
}
