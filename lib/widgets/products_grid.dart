import 'package:flutter/material.dart';

import '../models/product.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {

  late List<Product> loadedProducts;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: loadedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (BuildContext ctx, int index) => ProductItem(
        loadedProducts[index].id,
        loadedProducts[index].title,
        loadedProducts[index].imageUrl,
      ),
    );
  }
}