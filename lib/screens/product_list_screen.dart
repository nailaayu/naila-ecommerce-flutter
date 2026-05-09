import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../services/shop_controller.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final String initialSearch;

  const ProductListScreen({
    super.key,
    this.categoryId,
    this.categoryName,
    this.initialSearch = '',
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<Product> _products = [];

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadInitial() async {
    setState(() {
      _isLoading = true;
      _page = 1;
      _products.clear();
      _hasMore = true;
    });

    final shop = context.read<ShopController>();
    final items = await shop.fetchProductPage(
      page: 1,
      categoryId: widget.categoryId,
      search: widget.initialSearch,
      sortBy: _sortBy,
    );

    if (!mounted) return;
    setState(() {
      _products.addAll(items);
      _isLoading = false;
      _hasMore = items.isNotEmpty;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 160) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;
    setState(() => _isLoadingMore = true);
    final nextPage = _page + 1;
    final shop = context.read<ShopController>();
    final items = await shop.fetchProductPage(
      page: nextPage,
      categoryId: widget.categoryId,
      search: widget.initialSearch,
      sortBy: _sortBy,
    );
    if (!mounted) return;
    setState(() {
      if (items.isEmpty) {
        _hasMore = false;
      } else {
        _page = nextPage;
        _products.addAll(items);
      }
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName ?? 'Produk')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: DropdownButtonFormField<String>(
              value: _sortBy,
              decoration: const InputDecoration(labelText: 'Urutkan produk'),
              items: const [
                DropdownMenuItem(value: 'name', child: Text('Nama')),
                DropdownMenuItem(value: 'price_asc', child: Text('Harga termurah')),
                DropdownMenuItem(value: 'price_desc', child: Text('Harga tertinggi')),
                DropdownMenuItem(value: 'rating', child: Text('Rating tertinggi')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _sortBy = value);
                _loadInitial();
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const LoadingIndicator(message: 'Memuat daftar produk...');
    }

    if (_products.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'Produk tidak ditemukan',
        subtitle: 'Coba ganti filter, kategori, atau kata kunci pencarian.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInitial,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: _products.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _products.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(height: 320, child: ProductCard(product: _products[index])),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
