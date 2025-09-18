import 'package:flutter/foundation.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/order_usecases.dart';
import '../../domain/usecases/reporting_usecases.dart';

class OrderProvider extends ChangeNotifier {
  final AddOrderUseCase _addOrderUseCase;
  final GetPendingOrdersUseCase _getPendingOrdersUseCase;
  final CompleteOrderUseCase _completeOrderUseCase;
  final GenerateDailySalesReportUseCase _generateDailySalesReportUseCase;
  final GetTopSellingDrinksUseCase _getTopSellingDrinksUseCase;

  OrderProvider(
    this._addOrderUseCase,
    this._getPendingOrdersUseCase,
    this._completeOrderUseCase,
    this._generateDailySalesReportUseCase,
    this._getTopSellingDrinksUseCase,
  );

  List<Order> _pendingOrders = [];
  DailySalesReport? _todaysReport;
  List<DrinkSalesData> _topSellingDrinks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get pendingOrders => _pendingOrders;
  DailySalesReport? get todaysReport => _todaysReport;
  List<DrinkSalesData> get topSellingDrinks => _topSellingDrinks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadPendingOrders() async {
    _setLoading(true);
    try {
      _pendingOrders = await _getPendingOrdersUseCase.execute();
      _clearError();
    } catch (e) {
      _setError('Error loading orders: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addOrder(Order order) async {
    _setLoading(true);
    try {
      await _addOrderUseCase.execute(order);
      await loadPendingOrders();
      _clearError();
    } catch (e) {
      _setError('Error adding order: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> completeOrder(String orderId) async {
    _setLoading(true);
    try {
      await _completeOrderUseCase.execute(orderId);
      await loadPendingOrders();
      await loadTodaysReport();
      _clearError();
    } catch (e) {
      _setError('Error completing order: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTodaysReport() async {
    _setLoading(true);
    try {
      _todaysReport = await _generateDailySalesReportUseCase.execute(DateTime.now());
      _clearError();
    } catch (e) {
      _setError('Error loading daily report: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTopSellingDrinks() async {
    _setLoading(true);
    try {
      _topSellingDrinks = await _getTopSellingDrinksUseCase.execute(limit: 5);
      _clearError();
    } catch (e) {
      _setError('Error loading best-selling drinks: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}