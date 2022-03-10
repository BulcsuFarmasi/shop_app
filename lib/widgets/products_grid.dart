import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;

  const ProductsGrid(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    final products = (showOnlyFavorites) ? productProvider.favoriteItems : productProvider.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (BuildContext ctx, int index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
    );
  }
}
