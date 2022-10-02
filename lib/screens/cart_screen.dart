import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/widgets/cart_item.dart';
import 'package:shop_app/providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final productIds = cart.items.keys.toList(growable: false);
    final cartItems = cart.items.values.toList(growable: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Chip(
                        label: Text(
                          '\$${cart.totalAmount}',
                          style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6?.color),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      OrderButton(
                        cart: cart,
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (_, int index) {
                    return CartItem(
                        id: cartItems[index].product.id!,
                        productId: productIds[index],
                        title: cartItems[index].product.title,
                        quantity: cartItems[index].quantity,
                        price: cartItems[index].product.price);
                  },
                  itemCount: cart.items.length),
            ),
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    required this.cart,
  });

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: ((widget.cart.totalAmount > 0 && widget.cart.items.values.isNotEmpty) && !_isLoading)
            ? () async {
                setState(() {
                  _isLoading = true;
                });
                try {
                  await Provider.of<Orders>(context).addOrder(widget.cart.items.values.toList(), widget.cart.totalAmount);
                  widget.cart.clear();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Couldn\'t place order')));
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            : null,
        child: (_isLoading) ? CircularProgressIndicator() : Text('ORDER NOW'));
  }
}
