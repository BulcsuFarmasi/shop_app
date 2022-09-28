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
    final products = Provider.of<Products>(context, listen: false);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

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
                  await products.deleteProduct(id);
                } catch (e) {
                  scaffoldMessenger.showSnackBar(SnackBar(
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
