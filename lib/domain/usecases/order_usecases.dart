import '../entities/order.dart';
import '../repositories/repositories.dart';

class AddOrderUseCase {
  final OrderRepository _orderRepository;
  final CustomerRepository _customerRepository;

  AddOrderUseCase(this._orderRepository, this._customerRepository);

  Future<void> execute(Order order) async {
    final existingCustomer = await _customerRepository.getCustomerByName(order.customer.name);
    
    if (existingCustomer == null) {
      await _customerRepository.addCustomer(order.customer);
    }
    
    await _orderRepository.addOrder(order);
  }
}

class GetPendingOrdersUseCase {
  final OrderRepository _orderRepository;

  GetPendingOrdersUseCase(this._orderRepository);

  Future<List<Order>> execute() async {
    return await _orderRepository.getPendingOrders();
  }
}

class CompleteOrderUseCase {
  final OrderRepository _orderRepository;

  CompleteOrderUseCase(this._orderRepository);

  Future<void> execute(String orderId) async {
    final order = await _orderRepository.getOrderById(orderId);
    if (order != null) {
      order.markAsCompleted();
      await _orderRepository.updateOrder(order);
    }
  }
}