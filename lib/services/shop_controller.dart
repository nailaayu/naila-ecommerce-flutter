import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/category.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'cart_service.dart';
import 'product_service.dart';

class ShopController extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();

  List<Category> categories = const [];
  List<Product> featuredProducts = const [];
  List<Product> favorites = const [];
  List<Order> orders = const [];

  bool darkMode = false;
  String language = 'Indonesia';
  Color themeColor = const Color(0xFF1565C0);

  String userName = 'Naila Student';
  String userEmail = 'naila@gmail.com';
  String userPhone = '';
  String userAddress = '';
  Uint8List? profileImageBytes;

  bool homeLoading = true;
  bool homeError = false;
  bool ordersLoading = false;
  bool ordersLoadingMore = false;
  bool hasMoreOrders = true;

  Future<void> initialize() async {
    await loadHomeData();
  }

  Future<void> loadHomeData() async {
    homeLoading = true;
    homeError = false;
    notifyListeners();
    try {
      categories = await _productService.fetchCategories();
      featuredProducts = await _productService.fetchFeaturedProducts();
      homeLoading = false;
      notifyListeners();
    } catch (_) {
      homeLoading = false;
      homeError = true;
      notifyListeners();
    }
  }

  List<Product> get allProducts => _productService.allProducts;
  List<CartItem> get cartItems => _cartService.items;
  double get cartSubtotal => _cartService.subtotal;
  double get shippingCost => _cartService.shipping;
  double get cartTotal => _cartService.total;
  int get totalCartItems => _cartService.totalItems;
  bool get isCartEmpty => _cartService.isEmpty;

  void setUserProfile({required String name, required String email, String? phone, String? address}) {
    final cleanName = name.trim();
    final cleanEmail = email.trim();
    userName = cleanName.isEmpty ? userName : cleanName;
    userEmail = cleanEmail.isEmpty ? userEmail : cleanEmail;
    if (phone != null) userPhone = phone.trim();
    if (address != null) userAddress = address.trim();
    notifyListeners();
  }


  void setProfilePhoto(Uint8List bytes) {
    profileImageBytes = bytes;
    notifyListeners();
  }

  void addToCart(Product product) {
    _cartService.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartService.remove(product);
    notifyListeners();
  }

  void updateCartQuantity(Product product, int quantity) {
    _cartService.setQuantity(product, quantity);
    notifyListeners();
  }

  int quantityInCart(Product product) => _cartService.quantityFor(product);

  void toggleFavorite(Product product) {
    final exists = favorites.any((item) => item.id == product.id);
    if (exists) {
      favorites = favorites.where((item) => item.id != product.id).toList();
    } else {
      favorites = [...favorites, product];
    }
    notifyListeners();
  }

  bool isFavorite(Product product) => favorites.any((item) => item.id == product.id);

  Future<List<Product>> fetchProductPage({
    required int page,
    String? categoryId,
    String search = '',
    String sortBy = 'name',
  }) {
    return _productService.fetchProducts(
      page: page,
      categoryId: categoryId,
      search: search,
      sortBy: sortBy,
    );
  }

  Future<void> refreshOrders() async {
    ordersLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 300));
    ordersLoading = false;
    hasMoreOrders = false;
    notifyListeners();
  }

  Future<void> loadMoreOrders() async {
    hasMoreOrders = false;
  }

  String createOrderId() {
    final now = DateTime.now();
    final d = now.day.toString().padLeft(2, '0');
    final m = now.month.toString().padLeft(2, '0');
    final y = now.year.toString();
    final h = now.hour.toString().padLeft(2, '0');
    final min = now.minute.toString().padLeft(2, '0');
    return 'ORD-$d$m$y-$h$min';
  }

  void checkout({String paymentMethod = 'COD', String address = 'Alamat utama pelanggan'}) {
    if (_cartService.isEmpty) return;
    final newOrder = Order(
      id: createOrderId(),
      itemCount: _cartService.totalItems,
      total: _cartService.total,
      status: 'Dikemas',
      paymentMethod: paymentMethod,
      address: address,
      createdAt: DateTime.now(),
    );
    orders = [newOrder, ...orders];
    _cartService.clear();
    notifyListeners();
  }

  void checkoutProduct(Product product, {String paymentMethod = 'COD', String address = 'Alamat utama pelanggan'}) {
    _cartService.clear();
    _cartService.add(product);
    checkout(paymentMethod: paymentMethod, address: address);
  }

  void cancelOrder(Order order) {
    orders = orders.map((item) {
      if (item.id == order.id) {
        return Order(
          id: item.id,
          itemCount: item.itemCount,
          total: item.total,
          status: 'Dibatalkan',
          paymentMethod: item.paymentMethod,
          address: item.address,
          createdAt: item.createdAt,
        );
      }
      return item;
    }).toList();
    notifyListeners();
  }

  void setLanguage(String value) {
    language = value;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }

  void setThemeColor(Color value) {
    themeColor = value;
    notifyListeners();
  }

  String formatCurrency(double value) {
    final whole = value.toStringAsFixed(0);
    final buffer = StringBuffer();
    for (int i = 0; i < whole.length; i++) {
      final reverseIndex = whole.length - i;
      buffer.write(whole[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp $buffer';
  }
}
