import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/widgets/splash_screen.dart';

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
          ChangeNotifierProvider(create: (BuildContext ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (BuildContext ctx) => Products('', ''),
              update: (BuildContext ctx, Auth auth, previousProducts) =>
                  (previousProducts ?? Products('', ''))..updateUser(auth.token, auth.userId)),
          ChangeNotifierProvider(create: (BuildContext ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (BuildContext ctx) => Orders('', '', []),
              update: (BuildContext ctx, Auth auth, previousOrders) =>
                  Orders(auth.token, auth.userId, previousOrders?.items ?? [])),
        ],
        child: Consumer<Auth>(
          builder: (BuildContext context, Auth auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primaryColor)
                  .copyWith(secondary: AppColors.secondaryColor),
            ),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogIn(),
                    builder: (BuildContext ctx, AsyncSnapshot snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (BuildContext context) => ProductDetailScreen(),
              CartScreen.routeName: (BuildContext context) => CartScreen(),
              OrdersScreen.routeName: (BuildContext context) => OrdersScreen(),
              UserProductsScreen.routeName: (BuildContext context) => UserProductsScreen(),
              EditProductScreen.routeName: (BuildContext context) => EditProductScreen(),
            },
          ),
        ));
  }
}
