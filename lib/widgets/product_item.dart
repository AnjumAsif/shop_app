import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return GridTile(child: Image.network(imageUrl, fit: BoxFit.cover,),
      footer: GridTileBar(title: Text(title, textAlign: TextAlign.center,style: TextStyle(fontSize: 8),),
        backgroundColor: Colors.black54,
        leading: IconButton(icon: Icon(Icons.favorite), onPressed: () {},
        ),
        trailing: IconButton(icon: Icon(Icons.add_shopping_cart),onPressed: (){},),
      ),
    );
  }

}