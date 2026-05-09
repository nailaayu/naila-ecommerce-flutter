import 'dart:async';

import '../models/category.dart';
import '../models/order.dart';
import '../models/product.dart';

class ProductService {
  static const int pageSize = 6;

  final List<Category> _categories = const [
    Category(id: 'all', name: 'Semua', imagePath: 'assets/images/logo.png', iconEmoji: ''),
    Category(id: 'laptop', name: 'Laptop', imagePath: 'assets/images/laptop1.jpg', iconEmoji: ''),
    Category(id: 'phone', name: 'Handphone', imagePath: 'assets/images/hp_samsung.jpg', iconEmoji: ''),
    Category(id: 'printer', name: 'Printer', imagePath: 'assets/images/printer.jpg', iconEmoji: ''),
    Category(id: 'camera', name: 'Kamera', imagePath: 'assets/images/kamera.jpg', iconEmoji: ''),
    Category(id: 'projector', name: 'Proyektor', imagePath: 'assets/images/proyektor.jpg', iconEmoji: ''),
    Category(id: 'monitor', name: 'Monitor', imagePath: 'assets/images/pc.jpg', iconEmoji: ''),
    Category(id: 'mouse', name: 'Mouse', imagePath: 'assets/images/mouse1.jpg', iconEmoji: ''),
  ];

  late final List<Product> _products = const [
    Product(id: 1, name: 'Epson Projector Pro', categoryId: 'projector', categoryName: 'Proyektor', price: 7850000, rating: 4.8, imagePath: 'assets/images/proyektor.jpg', description: 'Proyektor Epson dengan tampilan tajam untuk presentasi, kelas, meeting, dan kebutuhan multimedia.', featured: true),
    Product(id: 2, name: 'Canon Printer Pink Series', categoryId: 'printer', categoryName: 'Printer', price: 1850000, rating: 4.9, imagePath: 'assets/images/printer.jpg', description: 'Printer Canon warna pink dengan desain aesthetic, cocok untuk cetak tugas, dokumen, dan foto ringan.', featured: true),
    Product(id: 3, name: 'Samsung Wide Monitor', categoryId: 'monitor', categoryName: 'Monitor', price: 3250000, rating: 4.7, imagePath: 'assets/images/pc.jpg', description: 'Monitor layar lebar untuk belajar, desain, coding, dan menonton dengan tampilan jernih.'),
    Product(id: 4, name: 'Canon EOS 60D Camera', categoryId: 'camera', categoryName: 'Kamera', price: 4999000, rating: 4.8, imagePath: 'assets/images/kamera.jpg', description: 'Kamera DSLR Canon untuk foto produk, dokumentasi kegiatan, dan kebutuhan konten digital.', featured: true),
    Product(id: 5, name: 'Samsung Galaxy S23 Ultra', categoryId: 'phone', categoryName: 'Handphone', price: 14999000, rating: 4.9, imagePath: 'assets/images/hp_samsung.jpg', description: 'Smartphone flagship dengan kamera tajam, performa kencang, dan desain premium.', featured: true),
    Product(id: 6, name: 'Acer Slim Laptop', categoryId: 'laptop', categoryName: 'Laptop', price: 6799000, rating: 4.6, imagePath: 'assets/images/laptop1.jpg', description: 'Laptop Acer ringan untuk kuliah, tugas, browsing, dan penggunaan harian.'),
    Product(id: 7, name: 'Laptop Business Touch', categoryId: 'laptop', categoryName: 'Laptop', price: 11250000, rating: 4.7, imagePath: 'assets/images/laptop2.jpg', description: 'Laptop bisnis dengan tampilan modern, cocok untuk produktivitas dan presentasi.', featured: true),
    Product(id: 8, name: 'ASUS Zenbook Pro Dual', categoryId: 'laptop', categoryName: 'Laptop', price: 22899000, rating: 4.9, imagePath: 'assets/images/laptop3.jpg', description: 'Laptop ASUS layar ganda untuk multitasking, desain, editing, dan pekerjaan profesional.', featured: true),
    Product(id: 9, name: 'ASUS ZenBook Classic', categoryId: 'laptop', categoryName: 'Laptop', price: 13999000, rating: 4.7, imagePath: 'assets/images/laptop4.jpg', description: 'Laptop premium dengan desain elegan, performa stabil, dan layar nyaman.'),
    Product(id: 10, name: 'MacBook Pink Edition', categoryId: 'laptop', categoryName: 'Laptop', price: 16500000, rating: 4.8, imagePath: 'assets/images/laptop5.jpg', description: 'Laptop warna pink dengan desain cantik untuk kerja kreatif dan aktivitas harian.', featured: true),
    Product(id: 11, name: 'HP EliteBook Silver', categoryId: 'laptop', categoryName: 'Laptop', price: 9499000, rating: 4.5, imagePath: 'assets/images/laptop6.jpg', description: 'Laptop HP dengan bodi silver, cocok untuk pekerjaan kantor dan tugas kuliah.'),
    Product(id: 12, name: 'Lenovo ThinkPad Black', categoryId: 'laptop', categoryName: 'Laptop', price: 8999000, rating: 4.6, imagePath: 'assets/images/laptop7.jpg', description: 'ThinkPad tangguh dengan keyboard nyaman untuk coding dan administrasi.'),
    Product(id: 13, name: 'ROG Gaming Laptop RGB', categoryId: 'laptop', categoryName: 'Laptop', price: 18999000, rating: 4.9, imagePath: 'assets/images/laptop8.jpg', description: 'Laptop gaming dengan keyboard RGB, cocok untuk game, desain, dan performa tinggi.', featured: true),
    Product(id: 14, name: 'ASUS VivoBook Color', categoryId: 'laptop', categoryName: 'Laptop', price: 7799000, rating: 4.6, imagePath: 'assets/images/laptop9.jpg', description: 'Laptop VivoBook dengan tampilan cerah dan performa harian yang stabil.'),
    Product(id: 15, name: 'MacBook Air Blue Display', categoryId: 'laptop', categoryName: 'Laptop', price: 17999000, rating: 4.8, imagePath: 'assets/images/laptop10.jpg', description: 'Laptop tipis premium dengan layar tajam, baterai awet, dan desain elegan.'),

    Product(id: 16, name: 'Mouse Wireless Flower White', categoryId: 'mouse', categoryName: 'Mouse', price: 95000, rating: 4.7, imagePath: 'assets/images/mouse1.jpg', description: 'Mouse wireless motif bunga dengan desain ringan, cocok untuk belajar dan kerja harian.', featured: true),
    Product(id: 17, name: 'Mouse Elegant Floral Black', categoryId: 'mouse', categoryName: 'Mouse', price: 129000, rating: 4.8, imagePath: 'assets/images/mouse2.jpg', description: 'Mouse hitam elegan dengan motif floral premium dan klik yang nyaman.', featured: true),
    Product(id: 18, name: 'Mouse Wireless Cream', categoryId: 'mouse', categoryName: 'Mouse', price: 89000, rating: 4.6, imagePath: 'assets/images/mouse3.jpg', description: 'Mouse warna cream aesthetic dengan receiver USB, cocok untuk laptop dan PC.'),
    Product(id: 19, name: 'Mouse Gaming Black Orange', categoryId: 'mouse', categoryName: 'Mouse', price: 145000, rating: 4.7, imagePath: 'assets/images/mouse4.jpg', description: 'Mouse gaming warna hitam oranye dengan desain sporty dan responsif.', featured: true),
    Product(id: 20, name: 'Mouse Tecnet Purple', categoryId: 'mouse', categoryName: 'Mouse', price: 115000, rating: 4.6, imagePath: 'assets/images/mouse5.jpg', description: 'Mouse wireless ungu dengan desain compact untuk kebutuhan harian.'),
    Product(id: 21, name: 'Mouse Pink Gaming Edition', categoryId: 'mouse', categoryName: 'Mouse', price: 185000, rating: 4.8, imagePath: 'assets/images/mouse6.jpg', description: 'Mouse pink gaming dengan desain modern, nyaman untuk kerja dan bermain.', featured: true),
    Product(id: 22, name: 'Mouse Lavender Wireless', categoryId: 'mouse', categoryName: 'Mouse', price: 99000, rating: 4.7, imagePath: 'assets/images/mouse7.jpg', description: 'Mouse lavender wireless yang ringan, cantik, dan mudah dibawa.'),
    Product(id: 23, name: 'Mouse White Minimalist', categoryId: 'mouse', categoryName: 'Mouse', price: 125000, rating: 4.8, imagePath: 'assets/images/mouse8.jpg', description: 'Mouse putih minimalis dengan tampilan bersih dan presisi stabil.', featured: true),
    Product(id: 24, name: 'Mouse HP Wireless Black', categoryId: 'mouse', categoryName: 'Mouse', price: 135000, rating: 4.7, imagePath: 'assets/images/mouse9.jpg', description: 'Mouse HP wireless warna hitam untuk penggunaan kantor, belajar, dan browsing.'),
    Product(id: 25, name: 'Mouse RGB Gaming Pro', categoryId: 'mouse', categoryName: 'Mouse', price: 210000, rating: 4.9, imagePath: 'assets/images/mouse10.jpg', description: 'Mouse gaming RGB dengan tampilan profesional dan grip nyaman.', featured: true),
  ];

  List<Category> get categories => _categories;
  List<Product> get allProducts => _products;

  Future<List<Category>> fetchCategories() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _categories;
  }

  Future<List<Product>> fetchFeaturedProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _products.where((product) => product.featured).toList();
  }

  Future<List<Product>> fetchProducts({required int page, String? categoryId, String search = '', String sortBy = 'name'}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    Iterable<Product> filtered = _products;
    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') filtered = filtered.where((p) => p.categoryId == categoryId);
    if (search.trim().isNotEmpty) {
      final k = search.trim().toLowerCase();
      filtered = filtered.where((p) => p.name.toLowerCase().contains(k) || p.categoryName.toLowerCase().contains(k) || p.description.toLowerCase().contains(k));
    }
    final list = filtered.toList();
    final start = (page - 1) * pageSize;
    if (start >= list.length) return [];
    final end = (start + pageSize).clamp(0, list.length).toInt();
    return list.sublist(start, end);
  }

  Future<List<Order>> fetchOrders({required int page}) async => [];
}
