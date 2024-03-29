import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import 'package:shop_app/widgets/main_drawer.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {

  static const String routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (BuildContext ctx, Products products, _) => Padding(
                    padding: EdgeInsets.all(6),
                    child: ListView.builder(
                      itemBuilder: (_, int i) => UserProductItem(
                        id: products.items[i].id!,
                        title: products.items[i].title,
                        imageUrl: products.items[i].imageUrl,
                      ),
                      itemCount: products.items.length,
                    ),
                  ),
                )),
      ),
    );
  }
}
