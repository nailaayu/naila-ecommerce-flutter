import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../services/shop_controller.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  final String totalLabel;
  const OrderDetailScreen({super.key, required this.order, required this.totalLabel});

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(order.id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                const SizedBox(height: 8),
                Text('${order.itemCount} item'),
                const SizedBox(height: 8),
                Text(shop.formatCurrency(order.total), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900, fontSize: 20)),
                const SizedBox(height: 8),
                Text('Status: ${order.status}'),
              ]),
            ),
          )
        ],
      ),
    );
  }
}
