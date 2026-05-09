import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../screens/checkout_screen.dart';
import '../screens/product_detail_screen.dart';
import '../services/shop_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();
    final isFavorite = shop.isFavorite(product);
    final oldPrice = product.price * 1.18;
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(width: double.infinity, color: primary.withOpacity(0.06), padding: const EdgeInsets.all(8), child: Image.asset(product.imagePath, fit: BoxFit.contain)),
                  if (product.featured)
                    Positioned(left: 8, top: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)), child: const Text('DISKON', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)))),
                  Positioned(right: 6, top: 6, child: CircleAvatar(radius: 17, backgroundColor: Theme.of(context).cardColor, child: IconButton(padding: EdgeInsets.zero, iconSize: 18, onPressed: () => shop.toggleFavorite(product), icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : primary)))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(children: [const Icon(Icons.star, size: 14, color: Colors.amber), const SizedBox(width: 3), Text(product.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12)), const Spacer(), Text(product.categoryName, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))]),
                  const SizedBox(height: 5),
                  if (product.featured) Text(shop.formatCurrency(oldPrice), style: const TextStyle(fontSize: 11, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                  Text(shop.formatCurrency(product.price), style: TextStyle(color: primary, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 34,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () {
                              shop.addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk telah ditambahkan ke keranjang')));
                            },
                            child: const FittedBox(child: Text('Keranjang', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: SizedBox(
                          height: 34,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                            onPressed: () {
                              shop.addToCart(product);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen()));
                            },
                            child: const FittedBox(child: Text('Pesan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
