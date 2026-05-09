import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/shop_controller.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopController>(
      builder: (context, shop, _) {
        if (shop.favorites.isEmpty) {
          return const EmptyState(
            icon: Icons.favorite_outline,
            title: 'Belum ada favorit',
            subtitle: 'Simpan produk dengan ikon hati.',
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: shop.favorites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.62,
          ),
          itemBuilder: (context, index) => ProductCard(product: shop.favorites[index]),
        );
      },
    );
  }
}
