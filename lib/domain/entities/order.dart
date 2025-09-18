import 'customer.dart';
import 'drink.dart';

class Order {
  final String _id;
  final Customer _customer;
  final List<OrderItem> _items;
  final String _specialInstructions;
  final DateTime _orderTime;
  OrderStatus _status;

  Order({
    required String id,
    required Customer customer,
    required List<OrderItem> items,
    String specialInstructions = '',
    DateTime? orderTime,
    OrderStatus status = OrderStatus.pending,
  })  : _id = id,
        _customer = customer,
        _items = List.unmodifiable(items),
        _specialInstructions = specialInstructions.trim(),
        _orderTime = orderTime ?? DateTime.now(),
        _status = status;

  String get id => _id;
  Customer get customer => _customer;
  List<OrderItem> get items => _items;
  String get specialInstructions => _specialInstructions;
  DateTime get orderTime => _orderTime;
  OrderStatus get status => _status;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItemsCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get hasSpecialInstructions => _specialInstructions.isNotEmpty;

  String get orderSummary {
    final itemsSummary = _items.map((item) => '${item.drink.displayName} (${item.quantity})').join(', ');
    return 'Order for ${_customer.name}: $itemsSummary';
  }

  void markAsCompleted() {
    if (_status == OrderStatus.pending) {
      _status = OrderStatus.completed;
    }
  }

  void markAsCancelled() {
    if (_status == OrderStatus.pending) {
      _status = OrderStatus.cancelled;
    }
  }

  Duration get processingTime {
    if (_status == OrderStatus.completed) {
      return DateTime.now().difference(_orderTime);
    }
    return Duration.zero;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Order &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  @override
  String toString() => 'Order{id: $_id, customer: $_customer, items: $_items, status: $_status}';

  Order copyWith({
    String? id,
    Customer? customer,
    List<OrderItem>? items,
    String? specialInstructions,
    DateTime? orderTime,
    OrderStatus? status,
  }) {
    return Order(
      id: id ?? _id,
      customer: customer ?? _customer,
      items: items ?? _items,
      specialInstructions: specialInstructions ?? _specialInstructions,
      orderTime: orderTime ?? _orderTime,
      status: status ?? _status,
    );
  }
}

class OrderItem {
  final Drink _drink;
  final int _quantity;

  OrderItem({
    required Drink drink,
    required int quantity,
  })  : _drink = drink,
        _quantity = quantity > 0 ? quantity : 1;

  Drink get drink => _drink;
  int get quantity => _quantity;

  double get totalPrice => _drink.calculatePrice(quantity: _quantity);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          runtimeType == other.runtimeType &&
          _drink == other._drink &&
          _quantity == other._quantity;

  @override
  int get hashCode => Object.hash(_drink, _quantity);

  @override
  String toString() => 'OrderItem{drink: $_drink, quantity: $_quantity}';

  OrderItem copyWith({
    Drink? drink,
    int? quantity,
  }) {
    return OrderItem(
      drink: drink ?? _drink,
      quantity: quantity ?? _quantity,
    );
  }
}

enum OrderStatus {
  pending('Preparing'),
  completed('Completed'),
  cancelled('Cancelled');

  const OrderStatus(this.englishName);
  final String englishName;
}