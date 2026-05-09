import 'package:flutter/material.dart';

import '../models/order.dart';
import '../screens/order_detail_screen.dart';

class OrderTile extends StatelessWidget {
  final Order order;
  final String totalLabel;

  const OrderTile({super.key, required this.order, required this.totalLabel});

  Color _statusColor(BuildContext context, String status) {
    switch (status) {
      case 'Selesai':
        return Colors.green;
      case 'Dikirim':
        return Colors.orange;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context, order.status);
    final primary = Theme.of(context).colorScheme.primary;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrderDetailScreen(order: order, totalLabel: totalLabel),
            ),
          );
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          leading: CircleAvatar(
            backgroundColor: primary.withOpacity(0.15),
            child: Icon(Icons.receipt_long, color: primary),
          ),
          title: Text(order.id, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${order.itemCount} item • $totalLabel'),
                const SizedBox(height: 4),
                Text('${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}'),
              ],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              order.status,
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
