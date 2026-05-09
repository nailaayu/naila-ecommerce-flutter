import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../services/shop_controller.dart';
import '../widgets/empty_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShopController>(
      builder: (context, shop, _) {
        if (shop.orders.isEmpty) return const EmptyState(icon: Icons.receipt_long_outlined, title: 'Belum ada pesanan', subtitle: 'Pesanan yang sudah dibuat akan tampil di halaman ini.');
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Center(child: Text('Riwayat Orderan', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900))),
            const SizedBox(height: 14),
            ...shop.orders.map((order) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _OrderCard(order: order))),
          ],
        );
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();
    final cancelled = order.status == 'Dibatalkan';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Expanded(child: Text(order.id, style: const TextStyle(fontWeight: FontWeight.w900))), Chip(label: Text(order.status))]),
            const SizedBox(height: 8),
            Text('${order.itemCount} item • ${shop.formatCurrency(order.total)}'),
            const SizedBox(height: 4),
            Text('${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}', style: TextStyle(color: Colors.grey.shade700)),
            const SizedBox(height: 14),
            Row(
              children: [
                _Step(title: 'Checkout', active: true),
                _Line(active: !cancelled),
                _Step(title: 'Bayar', active: !cancelled),
                _Line(active: !cancelled),
                _Step(title: 'Dikemas', active: !cancelled),
                _Line(active: !cancelled),
                _Step(title: cancelled ? 'Batal' : 'Selesai', active: !cancelled),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(14)),
              child: Text('Metode pembayaran: ${order.paymentMethod}\nAlamat: ${order.address}', style: const TextStyle(height: 1.4)),
            ),
            if (!cancelled) ...[
              const SizedBox(height: 10),
              Align(alignment: Alignment.centerRight, child: OutlinedButton.icon(onPressed: () => shop.cancelOrder(order), icon: const Icon(Icons.cancel_outlined), label: const Text('Batalkan Pesanan'))),
            ],
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String title;
  final bool active;
  const _Step({required this.title, required this.active});
  @override
  Widget build(BuildContext context) => Column(children: [CircleAvatar(radius: 12, backgroundColor: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade300, child: Icon(active ? Icons.check : Icons.circle, color: Colors.white, size: 13)), const SizedBox(height: 5), Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700))]);
}

class _Line extends StatelessWidget {
  final bool active;
  const _Line({required this.active});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(height: 2, color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade300));
}
