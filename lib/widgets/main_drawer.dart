import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final navigator = Navigator.of(context);
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            child: Text(
              'MyShop',
              style: theme.textTheme.headline6?.copyWith(color: Colors.white),
            ),
            width: double.infinity,
            height: 84,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            padding: EdgeInsets.only(top: mediaQuery.padding.top),
          ),
          ListTile(
            leading: Icon(Icons.store, size: 20,),
            title: Text('Shop', style: TextStyle(fontSize: 20), ),
            onTap: () {
              navigator.pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.store, size: 20,),
            title: Text('Orders', style: TextStyle(fontSize: 20), ),
            onTap: () {
              navigator.pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit, size: 20,),
            title: Text('Manage Products', style: TextStyle(fontSize: 20), ),
            onTap: () {
              navigator.pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
