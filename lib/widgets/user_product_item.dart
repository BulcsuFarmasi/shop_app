import 'package:flutter/material.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({required this.id, required this.title, required this.imageUrl});

  final String id;
  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 3,
      margin: EdgeInsets.all(5),
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).colorScheme.primary,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false).deleteProduct(id);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Deleting failed',
                      textAlign: TextAlign.center,
                    ),
                  ));
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
    //);
  }
}
