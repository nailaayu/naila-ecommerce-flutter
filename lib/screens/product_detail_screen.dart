import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../services/shop_controller.dart';
import 'checkout_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();
    final isFavorite = shop.isFavorite(product);
    final oldPrice = product.price * 1.18;
    return Scaffold(
      appBar: AppBar(title: const Text('DETAIL PRODUK')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 260, width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF4F8FF), borderRadius: BorderRadius.circular(18)), child: Image.asset(product.imagePath, fit: BoxFit.contain)),
                  const SizedBox(height: 18),
                  Text(product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Row(children: [const Icon(Icons.star, color: Colors.amber), const SizedBox(width: 4), Text('${product.rating.toStringAsFixed(1)} / 5.0'), const Spacer(), if (product.featured) const Chip(label: Text('Diskon'))]),
                  const SizedBox(height: 8),
                  if (product.featured) Text(shop.formatCurrency(oldPrice), style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                  Text(shop.formatCurrency(product.price), style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 14),
                  const Text('Informasi Produk', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('${product.description}\n\nProduk ini cocok untuk kebutuhan belajar, kerja, dan aktivitas digital harian. Tersedia pilihan checkout langsung atau simpan ke keranjang terlebih dahulu.', style: const TextStyle(height: 1.5)),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton.icon(onPressed: () => shop.toggleFavorite(product), icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border), label: const Text('Favorit'))),
                      const SizedBox(width: 10),
                      Expanded(child: OutlinedButton.icon(onPressed: () { shop.addToCart(product); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk telah ditambahkan ke keranjang'))); }, icon: const Icon(Icons.add_shopping_cart), label: const Text('Keranjang'))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () { shop.addToCart(product); Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())); }, icon: const Icon(Icons.shopping_bag_outlined), label: const Text('Buat Pesanan'))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
