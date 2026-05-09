class Order {
  final String id;
  final int itemCount;
  final double total;
  final String status;
  final String paymentMethod;
  final String address;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.itemCount,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.address,
    required this.createdAt,
  });
}
