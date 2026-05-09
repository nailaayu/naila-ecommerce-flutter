import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  final List<CartItem> _items = [];

  List<CartItem> get items => List<CartItem>.unmodifiable(_items);

  void add(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index == -1) {
      _items.add(CartItem(product: product, quantity: 1));
    } else {
      _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    }
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  void setQuantity(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index == -1) return;
    if (quantity <= 0) {
      remove(product);
      return;
    }
    _items[index] = _items[index].copyWith(quantity: quantity);
  }

  void clear() {
    _items.clear();
  }

  int quantityFor(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    return index == -1 ? 0 : _items[index].quantity;
  }

  double get subtotal => _items.fold<double>(0, (sum, item) => sum + item.total);
  double get shipping => _items.isEmpty ? 0 : 25000;
  double get total => subtotal + shipping;
  int get totalItems => _items.fold<int>(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;
}
