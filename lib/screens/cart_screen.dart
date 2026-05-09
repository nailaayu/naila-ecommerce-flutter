import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/shop_controller.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/empty_state.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KERANJANG')),
      body: Consumer<ShopController>(
        builder: (context, shop, _) {
          if (shop.isCartEmpty) return const EmptyState(icon: Icons.shopping_cart_outlined, title: 'Keranjang masih kosong', subtitle: 'Tambahkan produk dari halaman beranda dulu.');
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: shop.cartItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => CartItemWidget(item: shop.cartItems[index]),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, border: Border(top: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.18)))),
                child: Column(
                  children: [
                    _TotalRow(label: 'Subtotal', value: shop.formatCurrency(shop.cartSubtotal)),
                    _TotalRow(label: 'Ongkir', value: shop.formatCurrency(shop.shippingCost)),
                    const Divider(height: 22),
                    _TotalRow(label: 'Total', value: shop.formatCurrency(shop.cartTotal), bold: true),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text('Checkout'),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _TotalRow({required this.label, required this.value, this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w500)), const Spacer(), Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w600, color: bold ? Theme.of(context).colorScheme.primary : null))]));
}
