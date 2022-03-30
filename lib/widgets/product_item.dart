import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            navigator.pushNamed(ProductDetailScreen.routeName, arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (BuildContext ctx, Product product, _) =>
                IconButton(
                  icon: Icon((product.isFavorite) ? Icons.favorite : Icons.favorite_border),
                  onPressed: () async {
                    try {
                      await product.toggleFavoriteStatus();
                    } catch (e) {
                      scaffoldMessenger.showSnackBar(SnackBar(content: Text('Failed to make favorite')));
                    }
                  },
                  color: theme.colorScheme.secondary,
                ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id!, product.price, product.title);
              ScaffoldMessenger.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeQuantityFromItem(product.id!);
                    },
                  ),
                  duration: Duration(seconds: 2),
                ));
            },
            color: theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
