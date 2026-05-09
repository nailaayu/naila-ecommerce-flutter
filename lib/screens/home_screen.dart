import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/product_service.dart';
import '../services/shop_controller.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'all';
  String _keyword = '';
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopController>(
      builder: (context, shop, _) {
        if (shop.homeLoading) return const LoadingIndicator(message: 'Menyiapkan produk...');
        if (shop.homeError) return EmptyState(icon: Icons.cloud_off, title: 'Data gagal dimuat', subtitle: 'Coba muat ulang halaman utama.', buttonLabel: 'Coba lagi', onPressed: shop.loadHomeData);

        final all = shop.allProducts.where((product) {
          final byCategory = _selectedCategory == 'all' || product.categoryId == _selectedCategory;
          final key = _keyword.toLowerCase().trim();
          final bySearch = key.isEmpty || product.name.toLowerCase().contains(key) || product.categoryName.toLowerCase().contains(key);
          return byCategory && bySearch;
        }).toList();
        final pageCount = (all.length / ProductService.pageSize).ceil().clamp(1, 99);
        if (_page > pageCount) _page = pageCount;
        final start = (_page - 1) * ProductService.pageSize;
        final products = all.skip(start).take(ProductService.pageSize).toList();

        return RefreshIndicator(
          onRefresh: shop.loadHomeData,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _HomeHeaderDelegate(
                  minExtent: 120,
                  maxExtent: 120,
                  child: _HeaderContent(
                    selectedCategory: _selectedCategory,
                    categories: shop.categories,
                    favoritesCount: shop.favorites.length,
                    cartCount: shop.totalCartItems,
                    onSearch: (value) => setState(() { _keyword = value; _page = 1; }),
                    onCategory: (id) => setState(() { _selectedCategory = id; _page = 1; }),
                  ),
                ),
              ),
              if (products.isEmpty)
                const SliverFillRemaining(child: EmptyState(icon: Icons.search_off, title: 'Produk tidak ditemukan', subtitle: 'Coba kategori atau kata kunci lain.'))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.58),
                    delegate: SliverChildBuilderDelegate((context, index) => ProductCard(product: products[index]), childCount: products.length),
                  ),
                ),
              SliverToBoxAdapter(child: _Pagination(page: _page, pageCount: pageCount, onTap: (p) => setState(() => _page = p))),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      },
    );
  }
}

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double minExtent;
  @override
  final double maxExtent;
  final Widget child;
  _HomeHeaderDelegate({required this.minExtent, required this.maxExtent, required this.child});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => Material(elevation: overlapsContent ? 1 : 0, color: Theme.of(context).scaffoldBackgroundColor, child: child);
  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) => true;
}

class _HeaderContent extends StatelessWidget {
  final String selectedCategory;
  final List<dynamic> categories;
  final int favoritesCount;
  final int cartCount;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onCategory;
  const _HeaderContent({required this.selectedCategory, required this.categories, required this.favoritesCount, required this.cartCount, required this.onSearch, required this.onCategory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    onChanged: onSearch,
                    decoration: const InputDecoration(hintText: 'Cari produk...', prefixIcon: Icon(Icons.search_rounded)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _TopIconBox(icon: Icons.favorite_border_rounded, count: favoritesCount, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _SimplePage(title: 'FAVORIT', child: FavoritesScreen())))),
              const SizedBox(width: 8),
              _TopIconBox(icon: Icons.shopping_cart_outlined, count: cartCount, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()))),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((category) => _CategoryPill(label: category.name, selected: selectedCategory == category.id, onTap: () => onCategory(category.id))).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SimplePage extends StatelessWidget {
  final String title;
  final Widget child;
  const _SimplePage({required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: child);
}

class _TopIconBox extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;
  const _TopIconBox({required this.icon, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: primary.withOpacity(0.25))),
        child: Stack(alignment: Alignment.center, children: [
          Icon(icon, color: primary, size: 26),
          if (count > 0) Positioned(right: 6, top: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)), child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))),
        ]),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryPill({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: primary,
        backgroundColor: Theme.of(context).cardColor,
        labelStyle: TextStyle(color: selected ? Colors.white : primary, fontWeight: FontWeight.w700),
        side: BorderSide(color: primary.withOpacity(0.25)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  final int page;
  final int pageCount;
  final ValueChanged<int> onTap;
  const _Pagination({required this.page, required this.pageCount, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final p in [1, 2, 3].where((value) => value <= pageCount))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => onTap(p),
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p == page ? primary : Theme.of(context).cardColor,
                    border: Border.all(color: primary.withOpacity(0.25)),
                  ),
                  child: Text('$p', style: TextStyle(color: p == page ? Colors.white : primary, fontWeight: FontWeight.w900)),
                ),
              ),
            ),
          if (pageCount > 3)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () => _showPageSelector(context),
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 42,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: primary.withOpacity(0.25)),
                  ),
                  child: Text('...', style: TextStyle(color: primary, fontSize: 18, fontWeight: FontWeight.w900)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showPageSelector(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pilih Halaman Produk', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (int i = 1; i <= pageCount; i++)
                    InkWell(
                      onTap: () {
                        Navigator.pop(sheetContext);
                        onTap(i);
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == page ? primary : primary.withOpacity(0.08),
                          border: Border.all(color: primary.withOpacity(0.25)),
                        ),
                        child: Text('$i', style: TextStyle(color: i == page ? Colors.white : primary, fontWeight: FontWeight.w900)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
