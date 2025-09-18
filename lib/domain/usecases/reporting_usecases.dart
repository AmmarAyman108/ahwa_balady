import '../entities/order.dart';
import '../repositories/repositories.dart';

class DrinkSalesData {
  final String drinkName;
  final int totalQuantity;
  final double totalRevenue;
  final int orderCount;

  DrinkSalesData({
    required this.drinkName,
    required this.totalQuantity,
    required this.totalRevenue,
    required this.orderCount,
  });

  double get averageOrderQuantity => orderCount > 0 ? totalQuantity / orderCount : 0;
  double get averageRevenuePerOrder => orderCount > 0 ? totalRevenue / orderCount : 0;
}

class DailySalesReport {
  final DateTime date;
  final List<DrinkSalesData> drinkSales;
  final double totalRevenue;
  final int totalOrders;
  final int totalItemsSold;

  DailySalesReport({
    required this.date,
    required this.drinkSales,
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalItemsSold,
  });

  List<DrinkSalesData> get topSellingDrinks {
    final sortedDrinks = List<DrinkSalesData>.from(drinkSales);
    sortedDrinks.sort((a, b) => b.totalQuantity.compareTo(a.totalQuantity));
    return sortedDrinks.take(5).toList();
  }

  double get averageOrderValue => totalOrders > 0 ? totalRevenue / totalOrders : 0;
}

class GenerateDailySalesReportUseCase {
  final OrderRepository _orderRepository;

  GenerateDailySalesReportUseCase(this._orderRepository);

  Future<DailySalesReport> execute(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final orders = await _orderRepository.getOrdersByDateRange(startOfDay, endOfDay);
    final completedOrders = orders.where((order) => order.status == OrderStatus.completed).toList();
    
    final drinkSalesMap = <String, DrinkSalesData>{};
    double totalRevenue = 0;
    int totalItemsSold = 0;
    
    for (final order in completedOrders) {
      totalRevenue += order.totalAmount;
      
      for (final item in order.items) {
        totalItemsSold += item.quantity;
        final drinkName = item.drink.displayName;
        
        if (drinkSalesMap.containsKey(drinkName)) {
          final existingData = drinkSalesMap[drinkName]!;
          drinkSalesMap[drinkName] = DrinkSalesData(
            drinkName: drinkName,
            totalQuantity: existingData.totalQuantity + item.quantity,
            totalRevenue: existingData.totalRevenue + item.totalPrice,
            orderCount: existingData.orderCount + 1,
          );
        } else {
          drinkSalesMap[drinkName] = DrinkSalesData(
            drinkName: drinkName,
            totalQuantity: item.quantity,
            totalRevenue: item.totalPrice,
            orderCount: 1,
          );
        }
      }
    }
    
    return DailySalesReport(
      date: date,
      drinkSales: drinkSalesMap.values.toList(),
      totalRevenue: totalRevenue,
      totalOrders: completedOrders.length,
      totalItemsSold: totalItemsSold,
    );
  }
}

class GetTopSellingDrinksUseCase {
  final OrderRepository _orderRepository;

  GetTopSellingDrinksUseCase(this._orderRepository);

  Future<List<DrinkSalesData>> execute({DateTime? startDate, DateTime? endDate, int limit = 10}) async {
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 30));
    final end = endDate ?? DateTime.now();
    
    final orders = await _orderRepository.getOrdersByDateRange(start, end);
    final completedOrders = orders.where((order) => order.status == OrderStatus.completed).toList();
    
    final drinkSalesMap = <String, DrinkSalesData>{};
    
    for (final order in completedOrders) {
      for (final item in order.items) {
        final drinkName = item.drink.displayName;
        
        if (drinkSalesMap.containsKey(drinkName)) {
          final existingData = drinkSalesMap[drinkName]!;
          drinkSalesMap[drinkName] = DrinkSalesData(
            drinkName: drinkName,
            totalQuantity: existingData.totalQuantity + item.quantity,
            totalRevenue: existingData.totalRevenue + item.totalPrice,
            orderCount: existingData.orderCount + 1,
          );
        } else {
          drinkSalesMap[drinkName] = DrinkSalesData(
            drinkName: drinkName,
            totalQuantity: item.quantity,
            totalRevenue: item.totalPrice,
            orderCount: 1,
          );
        }
      }
    }
    
    final sortedDrinks = drinkSalesMap.values.toList();
    sortedDrinks.sort((a, b) => b.totalQuantity.compareTo(a.totalQuantity));
    
    return sortedDrinks.take(limit).toList();
  }
}