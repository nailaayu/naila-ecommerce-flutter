import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/shop_controller.dart';
import 'product_list_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.extent(
          maxCrossAxisExtent: 220,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          children: shop.categories.map((category) {
            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductListScreen(
                        categoryId: category.id,
                        categoryName: category.name,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Image.asset(category.imagePath, fit: BoxFit.contain)),
                      const SizedBox(height: 12),
                      Text(category.iconEmoji, style: const TextStyle(fontSize: 26)),
                      const SizedBox(height: 6),
                      Text(category.name, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
