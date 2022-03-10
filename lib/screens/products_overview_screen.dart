import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (ProductFilter filter) {
              setState(() {
                switch (filter) {
                  case ProductFilter.onlyFavorites:
                    _showOnlyFavorites = true;

                    break;
                  case ProductFilter.showAll:
                    _showOnlyFavorites = false;
                    break;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Text('Only Favorites'),
                value: ProductFilter.onlyFavorites,
              ),
              PopupMenuItem(
                child: const Text('Show All'),
                value: ProductFilter.showAll,
              )
            ],
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}

enum ProductFilter { onlyFavorites, showAll }
