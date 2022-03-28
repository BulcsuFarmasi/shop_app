import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/shared/colors.dart';

import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext ctx) => Products()),
        ChangeNotifierProvider(create: (BuildContext ctx) => Cart()),
        ChangeNotifierProvider(create: (BuildContext ctx) => Orders()),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primaryColor)
              .copyWith(secondary: AppColors.secondaryColor),
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (BuildContext context) => ProductDetailScreen(),
          CartScreen.routeName: (BuildContext context) => CartScreen(),
          OrdersScreen.routeName: (BuildContext context) => OrdersScreen(),
          UserProductsScreen.routeName: (BuildContext context) => UserProductsScreen(),
          EditProductScreen.routeName: (BuildContext context) => EditProductScreen(),
        },
      ),
    );
  }
}
