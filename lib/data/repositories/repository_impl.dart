import '../../domain/entities/order.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/data_sources.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource _dataSource;

  OrderRepositoryImpl(this._dataSource);

  @override
  Future<List<Order>> getAllOrders() => _dataSource.getAllOrders();

  @override
  Future<List<Order>> getPendingOrders() => _dataSource.getPendingOrders();

  @override
  Future<List<Order>> getCompletedOrders() => _dataSource.getCompletedOrders();

  @override
  Future<Order?> getOrderById(String id) => _dataSource.getOrderById(id);

  @override
  Future<void> addOrder(Order order) => _dataSource.addOrder(order);

  @override
  Future<void> updateOrder(Order order) => _dataSource.updateOrder(order);

  @override
  Future<void> deleteOrder(String id) => _dataSource.deleteOrder(id);

  @override
  Future<List<Order>> getOrdersByCustomer(Customer customer) =>
      _dataSource.getOrdersByCustomer(customer);

  @override
  Future<List<Order>> getOrdersByDateRange(DateTime start, DateTime end) =>
      _dataSource.getOrdersByDateRange(start, end);
}

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerDataSource _dataSource;

  CustomerRepositoryImpl(this._dataSource);

  @override
  Future<List<Customer>> getAllCustomers() => _dataSource.getAllCustomers();

  @override
  Future<Customer?> getCustomerByName(String name) => _dataSource.getCustomerByName(name);

  @override
  Future<void> addCustomer(Customer customer) => _dataSource.addCustomer(customer);

  @override
  Future<void> updateCustomer(Customer customer) => _dataSource.updateCustomer(customer);

  @override
  Future<void> deleteCustomer(String name) => _dataSource.deleteCustomer(name);

  @override
  Future<List<Customer>> getRegularCustomers() => _dataSource.getRegularCustomers();
}