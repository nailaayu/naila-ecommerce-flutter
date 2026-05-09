import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../services/shop_controller.dart';
import '../widgets/empty_state.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<Product> _results = const [];
  List<String> _recentSearches = ['Laptop', 'Monitor', 'Keyboard'];
  bool _isTyping = false;

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    setState(() => _isTyping = true);
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final keyword = value.trim().toLowerCase();
      final shop = context.read<ShopController>();
      final results = keyword.isEmpty
          ? <Product>[]
          : shop.allProducts.where((product) {
              return product.name.toLowerCase().contains(keyword) ||
                  product.categoryName.toLowerCase().contains(keyword);
            }).toList();
      if (!mounted) return;
      setState(() {
        _results = results;
        _isTyping = false;
        if (keyword.isNotEmpty) {
          _recentSearches = [keyword, ..._recentSearches.where((item) => item.toLowerCase() != keyword)].take(5).toList();
        }
      });
    });
  }

  void _applyRecent(String keyword) {
    _controller.text = keyword;
    _onQueryChanged(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: _onQueryChanged,
            decoration: InputDecoration(
              hintText: 'Cari produk',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        _controller.clear();
                        _onQueryChanged('');
                      },
                      icon: const Icon(Icons.close),
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((keyword) {
                return ActionChip(
                  label: Text(keyword),
                  onPressed: () => _applyRecent(keyword),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: _controller.text.isEmpty
                ? const EmptyState(
                    icon: Icons.search,
                    title: 'Mulai pencarian',
                    subtitle: 'Ketik nama atau kategori.',
                  )
                : _isTyping
                    ? const Center(child: CircularProgressIndicator())
                    : _results.isEmpty
                        ? const EmptyState(
                            icon: Icons.search_off,
                            title: 'Produk tidak ditemukan',
                            subtitle: 'Coba kata kunci lain.',
                          )
                        : ListView.builder(
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final product = _results[index];
                              final isFavorite = shop.isFavorite(product);
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailScreen(product: product),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(12),
                                    leading: Container(
                                      width: 64,
                                      height: 64,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF5FF),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Image.asset(product.imagePath),
                                    ),
                                    title: Text(product.name),
                                    subtitle: Text('${product.categoryName} • ${shop.formatCurrency(product.price)}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () => shop.toggleFavorite(product),
                                          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                                          color: isFavorite ? Colors.red : Theme.of(context).colorScheme.primary,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            shop.addToCart(product);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('${product.name} ditambahkan')),
                                            );
                                          },
                                          icon: const Icon(Icons.add_shopping_cart),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
