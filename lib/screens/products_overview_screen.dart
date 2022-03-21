import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;
  static const _cartItemNumberDisplayLimit = 100;

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
          Consumer<Cart>(
            builder: (_, Cart cart, Widget? child) => Badge(
                child: child!,
                value: (cart.allProductCount <= _cartItemNumberDisplayLimit)
                    ? cart.allProductCount.toString()
                    : '${_cartItemNumberDisplayLimit}+'),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}

enum ProductFilter { onlyFavorites, showAll }
