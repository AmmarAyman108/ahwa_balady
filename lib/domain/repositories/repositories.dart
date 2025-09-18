import '../entities/order.dart';
import '../entities/customer.dart';

abstract class OrderRepository {
  Future<List<Order>> getAllOrders();
  Future<List<Order>> getPendingOrders();
  Future<List<Order>> getCompletedOrders();
  Future<Order?> getOrderById(String id);
  Future<void> addOrder(Order order);
  Future<void> updateOrder(Order order);
  Future<void> deleteOrder(String id);
  Future<List<Order>> getOrdersByCustomer(Customer customer);
  Future<List<Order>> getOrdersByDateRange(DateTime start, DateTime end);
}

abstract class CustomerRepository {
  Future<List<Customer>> getAllCustomers();
  Future<Customer?> getCustomerByName(String name);
  Future<void> addCustomer(Customer customer);
  Future<void> updateCustomer(Customer customer);
  Future<void> deleteCustomer(String name);
  Future<List<Customer>> getRegularCustomers();
}