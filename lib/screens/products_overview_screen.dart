import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/main_drawer.dart';

import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/products_grid.dart';
import 'package:shop_app/widgets/badge.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;
  static const _cartItemNumberDisplayLimit = 100;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;

        Provider.of<Products>(context).fetchProducts().catchError((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn't load products")));
        }).whenComplete(() => setState(() {
              _isLoading = false;
            }));
        _isInit = false;
      });
    }
    super.didChangeDependencies();
  }

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
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}

enum ProductFilter { onlyFavorites, showAll }
