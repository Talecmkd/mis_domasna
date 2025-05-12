import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../services/firestore_service.dart';
import 'product_detail_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F2E8),
      appBar: AppBar(
        backgroundColor: Color(0xFFE8F2E8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1C170D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Your Cart',
          style: GoogleFonts.plusJakartaSans(
            color: Color(0xFF1C170D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              final cart = Provider.of<Cart>(context, listen: false);
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Clear Cart?'),
                  content: Text('This will remove all items from your cart.'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    TextButton(
                      child: Text('Clear'),
                      onPressed: () {
                        cart.clear();
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Cart cleared')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.remove_shopping_cart, color: Color(0xFF1C170D)),
            label: Text(
              'Clear',
              style: TextStyle(color: Color(0xFF1C170D)),
            ),
          ),
        ],
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Color(0xFF9AC49A),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C170D),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add items to start shopping',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: Color(0xFF6C736B),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1AE51A),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Continue Shopping',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C170D),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) => CartItemWidget(
                    cartItem: cart.items.values.toList()[i],
                    productId: cart.items.keys.toList()[i],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C170D),
                            ),
                          ),
                          Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C170D),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: cart.totalAmount <= 0
                            ? null
                            : () async {
                                final firestoreService = FirestoreService();
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Place Order'),
                                    content: Text(
                                        'Would you like to proceed with your order?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () => Navigator.of(ctx).pop(),
                                      ),
                                      TextButton(
                                        child: Text('Proceed'),
                                        onPressed: () async {
                                          try {
                                            // Create the order in Firebase
                                            await firestoreService.createOrder(
                                              cart.items.values.toList(),
                                              cart.totalAmount,
                                            );
                                            
                                            // Clear the cart
                                            cart.clear();
                                            
                                            Navigator.of(ctx).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Order placed successfully!'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                          } catch (error) {
                                            Navigator.of(ctx).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Failed to place order. Please try again.'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1AE51A),
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Checkout (\$${cart.totalAmount.toStringAsFixed(2)})',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1C170D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final String productId;

  CartItemWidget({
    required this.cartItem,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Colors.red.shade100,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Icon(
          Icons.delete,
          color: Colors.red,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Remove Item'),
            content: Text('Do you want to remove this item from the cart?'),
            actions: [
              TextButton(
                child: Text('No'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${cartItem.product.name} removed from cart'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                Provider.of<Cart>(context, listen: false)
                    .addItem(cartItem.product);
              },
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(product: cartItem.product),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(cartItem.product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartItem.product.name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C170D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$${cartItem.product.price.toStringAsFixed(2)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9AC49A),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (cartItem.quantity > 1) {
                          Provider.of<Cart>(context, listen: false)
                              .updateQuantity(productId, cartItem.quantity - 1);
                        } else {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Remove Item'),
                              content: Text(
                                  'Do you want to remove this item from the cart?'),
                              actions: [
                                TextButton(
                                  child: Text('No'),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                ),
                                TextButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    Provider.of<Cart>(context, listen: false)
                                        .removeItem(productId);
                                  },
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    Text(
                      '${cartItem.quantity}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        Provider.of<Cart>(context, listen: false)
                            .updateQuantity(productId, cartItem.quantity + 1);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
