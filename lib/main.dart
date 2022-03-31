import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import '../providers/auth.dart';
import '../screens/edit_product_screen.dart';
import '../screens/orders_screen.dart';
import '../shared/colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext ctx) => Products()),
        ChangeNotifierProvider(create: (BuildContext ctx) => Cart()),
        ChangeNotifierProvider(create: (BuildContext ctx) => Orders()),
        ChangeNotifierProvider(create: (BuildContext ctx) => Auth()),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primaryColor)
              .copyWith(secondary: AppColors.secondaryColor),
        ),
        home: AuthScreen(),
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
