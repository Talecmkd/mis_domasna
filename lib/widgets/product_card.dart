import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/store_provider.dart';
import '../providers/product_provider.dart';
import 'star_rating.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storeProvider = Provider.of<StoreProvider>(context);
    final isInWishlist = storeProvider.isLoading ? false : (storeProvider.isInWishlist(product.id) ?? false);

    return Card(
      elevation: 0,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    product.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (!storeProvider.isLoading)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? theme.colorScheme.error : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onPressed: () {
                        if (isInWishlist) {
                          final wishlistItemId = storeProvider.getWishlistItemId(product.id);
                          if (wishlistItemId != null) {
                            storeProvider.removeFromWishlist(wishlistItemId);
                          }
                        } else {
                          storeProvider.addToWishlist(product);
                        }
                      },
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      StarRating(
                        rating: product.rating,
                        size: 16,
                        isInteractive: true,
                        onRatingChanged: (newRating) {
                          final productProvider = Provider.of<ProductProvider>(context, listen: false);
                          productProvider.updateProductRating(product.id, newRating);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Rating updated to ${newRating.toStringAsFixed(1)}'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 4),
                      Text(
                        (product.rating > 0) ? product.rating.toStringAsFixed(1) : 'No ratings',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 