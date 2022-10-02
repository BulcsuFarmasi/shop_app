import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/shared/custom_route.dart';
import 'package:shop_app/widgets/splash_screen.dart';

import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/shared/colors.dart';

class App extends StatelessWidget {
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
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTranslationBuilder(),
                TargetPlatform.iOS: CustomPageTranslationBuilder(),
              }),
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
