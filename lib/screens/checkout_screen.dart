import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/shop_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 0;
  String _payment = 'COD - Bayar di Tempat';
  final _address = TextEditingController(text: 'Jl. Melati No. 10, Lumajang');
  final _note = TextEditingController();

  @override
  void dispose() {
    _address.dispose();
    _note.dispose();
    super.dispose();
  }

  void _finish() {
    final shop = context.read<ShopController>();
    shop.checkout(paymentMethod: _payment, address: _address.text.trim().isEmpty ? 'Alamat utama pelanggan' : _address.text.trim());
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Pesanan Dibuat'),
        content: const Text('Pesanan berhasil masuk ke halaman ORDER dan bisa dibatalkan sebelum selesai.'),
        actions: [TextButton(onPressed: () { Navigator.pop(context); Navigator.pop(context); }, child: const Text('Oke'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopController>();
    return Scaffold(
      appBar: AppBar(title: const Text('CHECKOUT')),
      body: Stepper(
        currentStep: _step,
        onStepContinue: _step == 2 ? _finish : () => setState(() => _step += 1),
        onStepCancel: _step == 0 ? null : () => setState(() => _step -= 1),
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: details.onStepContinue, child: Text(_step == 2 ? 'Buat Pesanan' : 'Lanjut'))),
                if (_step > 0) ...[
                  const SizedBox(width: 10),
                  Expanded(child: OutlinedButton(onPressed: details.onStepCancel, child: const Text('Kembali'))),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Cek Produk'),
            isActive: _step >= 0,
            content: Column(
              children: [
                ...shop.cartItems.map((item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(item.product.imagePath, width: 54, height: 54, fit: BoxFit.cover)),
                  title: Text(item.product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${item.quantity} barang'),
                  trailing: Text(shop.formatCurrency(item.total), style: const TextStyle(fontWeight: FontWeight.w800)),
                )),
                const Divider(),
                Row(children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w900)), const Spacer(), Text(shop.formatCurrency(shop.cartTotal), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900))]),
              ],
            ),
          ),
          Step(
            title: const Text('Alamat Pengiriman'),
            isActive: _step >= 1,
            content: Column(
              children: [
                TextField(controller: _address, maxLines: 2, decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on_outlined), labelText: 'Alamat lengkap')),
                const SizedBox(height: 12),
                TextField(controller: _note, decoration: const InputDecoration(prefixIcon: Icon(Icons.edit_note), labelText: 'Catatan pesanan')),
              ],
            ),
          ),
          Step(
            title: const Text('Pembayaran'),
            isActive: _step >= 2,
            content: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _payment,
                  decoration: const InputDecoration(labelText: 'Metode pembayaran'),
                  items: const [
                    DropdownMenuItem(value: 'COD - Bayar di Tempat', child: Text('COD - Bayar di Tempat')),
                    DropdownMenuItem(value: 'Transfer Bank', child: Text('Transfer Bank')),
                    DropdownMenuItem(value: 'E-Wallet', child: Text('E-Wallet')),
                  ],
                  onChanged: (v) => setState(() => _payment = v ?? 'COD - Bayar di Tempat'),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.primary.withOpacity(0.08)),
                  child: Text('Ringkasan pembayaran: ${shop.formatCurrency(shop.cartTotal)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
