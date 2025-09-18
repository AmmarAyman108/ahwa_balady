import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/order_usecases.dart';
import '../../domain/usecases/reporting_usecases.dart';
import '../../data/repositories/repository_impl.dart';
import '../../data/datasources/local_data_source.dart';
import '../../presentation/providers/order_provider.dart';

class DependencyInjection {
  static late final OrderRepository _orderRepository;
  static late final CustomerRepository _customerRepository;
  static late final OrderProvider _orderProvider;

  static void setup() {
    final orderDataSource = LocalOrderDataSource();
    final customerDataSource = LocalCustomerDataSource();

    _orderRepository = OrderRepositoryImpl(orderDataSource);
    _customerRepository = CustomerRepositoryImpl(customerDataSource);

    final addOrderUseCase = AddOrderUseCase(_orderRepository, _customerRepository);
    final getPendingOrdersUseCase = GetPendingOrdersUseCase(_orderRepository);
    final completeOrderUseCase = CompleteOrderUseCase(_orderRepository);
    final generateDailySalesReportUseCase = GenerateDailySalesReportUseCase(_orderRepository);
    final getTopSellingDrinksUseCase = GetTopSellingDrinksUseCase(_orderRepository);

    _orderProvider = OrderProvider(
      addOrderUseCase,
      getPendingOrdersUseCase,
      completeOrderUseCase,
      generateDailySalesReportUseCase,
      getTopSellingDrinksUseCase,
    );
  }

  static OrderProvider get orderProvider => _orderProvider;
}