import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _controller = TextEditingController();
  final List<_TodoItem> _items = [
    _TodoItem('Cek stok produk harian', true),
    _TodoItem('Packing pesanan pelanggan', false),
    _TodoItem('Update banner promo Shopee style', false),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _items.insert(0, _TodoItem(text, false)));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final done = _items.where((item) => item.done).length;
    return Scaffold(
      appBar: AppBar(title: const Text('Todo Project')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$done dari ${_items.length} tugas selesai', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: _items.isEmpty ? 0 : done / _items.length),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(labelText: 'Tambah tugas'))),
              const SizedBox(width: 10),
              FilledButton(onPressed: _addTodo, child: const Icon(Icons.add)),
            ],
          ),
          const SizedBox(height: 14),
          for (final item in _items)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                child: CheckboxListTile(
                  value: item.done,
                  title: Text(item.title, style: TextStyle(decoration: item.done ? TextDecoration.lineThrough : null)),
                  onChanged: (value) => setState(() => item.done = value ?? false),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TodoItem {
  final String title;
  bool done;
  _TodoItem(this.title, this.done);
}
