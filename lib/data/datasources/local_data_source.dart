import '../../domain/entities/order.dart';
import '../../domain/entities/customer.dart';
import '../datasources/data_sources.dart';

class LocalOrderDataSource implements OrderDataSource {
  final List<Order> _orders = [];

  @override
  Future<List<Order>> getAllOrders() async {
    return List.from(_orders);
  }

  @override
  Future<List<Order>> getPendingOrders() async {
    return _orders.where((order) => order.status == OrderStatus.pending).toList();
  }

  @override
  Future<List<Order>> getCompletedOrders() async {
    return _orders.where((order) => order.status == OrderStatus.completed).toList();
  }

  @override
  Future<Order?> getOrderById(String id) async {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addOrder(Order order) async {
    _orders.add(order);
  }

  @override
  Future<void> updateOrder(Order order) async {
    final index = _orders.indexWhere((o) => o.id == order.id);
    if (index != -1) {
      _orders[index] = order;
    }
  }

  @override
  Future<void> deleteOrder(String id) async {
    _orders.removeWhere((order) => order.id == id);
  }

  @override
  Future<List<Order>> getOrdersByCustomer(Customer customer) async {
    return _orders.where((order) => order.customer.name == customer.name).toList();
  }

  @override
  Future<List<Order>> getOrdersByDateRange(DateTime start, DateTime end) async {
    return _orders.where((order) {
      return order.orderTime.isAfter(start) && order.orderTime.isBefore(end);
    }).toList();
  }
}

class LocalCustomerDataSource implements CustomerDataSource {
  final List<Customer> _customers = [];

  @override
  Future<List<Customer>> getAllCustomers() async {
    return List.from(_customers);
  }

  @override
  Future<Customer?> getCustomerByName(String name) async {
    try {
      return _customers.firstWhere((customer) => customer.name == name);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addCustomer(Customer customer) async {
    final existingIndex = _customers.indexWhere((c) => c.name == customer.name);
    if (existingIndex == -1) {
      _customers.add(customer);
    }
  }

  @override
  Future<void> updateCustomer(Customer customer) async {
    final index = _customers.indexWhere((c) => c.name == customer.name);
    if (index != -1) {
      _customers[index] = customer;
    }
  }

  @override
  Future<void> deleteCustomer(String name) async {
    _customers.removeWhere((customer) => customer.name == name);
  }

  @override
  Future<List<Customer>> getRegularCustomers() async {
    return _customers.where((customer) => customer.isRegularCustomer).toList();
  }
}