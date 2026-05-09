import 'package:flutter/material.dart';

class InfoMenuScreen extends StatefulWidget {
  final int initialIndex;
  const InfoMenuScreen({super.key, this.initialIndex = 0});

  @override
  State<InfoMenuScreen> createState() => _InfoMenuScreenState();
}

class _InfoMenuScreenState extends State<InfoMenuScreen> {
  late int _index = widget.initialIndex;

  final _contacts = const [
    ('Customer Service', 'cs@nailashop.com', Icons.support_agent),
    ('Admin Marketplace', 'admin@nailashop.com', Icons.storefront),
    ('Gudang Pengiriman', 'warehouse@nailashop.com', Icons.local_shipping),
  ];

  final _gallery = const [
    ('Laptop Flutter Pro', 'assets/images/laptop.png'),
    ('Phone Max View', 'assets/images/phone.png'),
    ('Monitor Wide', 'assets/images/monitor.png'),
    ('Accessories', 'assets/images/accessories.png'),
    ('Wearable', 'assets/images/wearable.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Informasi')),
      body: IndexedStack(
        index: _index,
        children: [_galleryPage(), _supportPage(), _contactPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.photo_library_outlined), label: 'Galeri'),
          NavigationDestination(icon: Icon(Icons.info_outline), label: 'Tentang'),
          NavigationDestination(icon: Icon(Icons.contacts_outlined), label: 'Kontak'),
        ],
      ),
    );
  }

  Widget _galleryPage() {
    return GridView.builder(
      padding: const EdgeInsets.all(18),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: .78, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemCount: _gallery.length,
      itemBuilder: (context, index) {
        final item = _gallery[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Expanded(child: Image.asset(item.$2, fit: BoxFit.contain)),
                const SizedBox(height: 10),
                Text(item.$1, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _supportPage() {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: const [
        Card(
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NAILA E-COMMERCE', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                SizedBox(height: 10),
                Text('Aplikasi NAILA E-COMMERCE sederhana yang menggabungkan login, katalog produk, pencarian, kategori, keranjang, checkout, riwayat pesanan, favorit, profil, galeri, kontak, dan todo project.'),
              ],
            ),
          ),
        ),
        SizedBox(height: 14),
        Card(
          child: ListTile(
            leading: Icon(Icons.verified_user_outlined),
            title: Text('Fitur Utama'),
            subtitle: Text('UI marketplace, detail produk, filter, state management, dan simulasi transaksi.'),
          ),
        ),
        SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: Icon(Icons.school_outlined),
            title: Text('Tujuan Praktikum'),
            subtitle: Text('Aplikasi marketplace elektronik dengan tampilan modern dan fitur belanja lengkap.'),
          ),
        ),
      ],
    );
  }

  Widget _contactPage() {
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final item = _contacts[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.10), child: Icon(item.$3, color: Theme.of(context).colorScheme.primary)),
              title: Text(item.$1, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text(item.$2),
              trailing: const Icon(Icons.mail_outline),
            ),
          ),
        );
      },
    );
  }
}
