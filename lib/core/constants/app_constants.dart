/// Application-wide constants and configuration
/// Centralizes all app constants following clean architecture principles
class AppConstants {
  // App Information
  static const String appName = 'Ahwa Manager';
  static const String appVersion = '1.0.0';
  
  /// Available drink types in the cafe
  /// Each drink type has its own specific customization options
  static const List<String> drinkTypes = [
    'Tea',                    // Traditional tea with mint and sugar options
    'Turkish Coffee',         // Turkish coffee with sugar levels and cardamom
    'Hibiscus Tea',          // Hot/cold hibiscus with lemon option
    'Milk Tea',              // Creamy milk tea with various flavors
    'Sa7lab',                // Traditional hot milk drink with nuts
    'Green Tea',             // Healthy green tea with honey option
    'Black Coffee',          // Strong black coffee with sugar options
    'Cappuccino',            // Italian coffee with milk foam
    'Latte',                 // Espresso with steamed milk
    'Americano',             // Diluted espresso
    'Espresso',              // Strong shot of coffee
    'Hot Chocolate',         // Rich chocolate drink with marshmallows
    'Iced Coffee',           // Cold coffee with ice and milk
    'Frappe',                // Blended iced coffee drink
    'Mint Tea',              // Fresh mint tea
    'Anise Tea',             // Traditional anise flavor
  ];
  
  /// Base prices for each drink type (in Egyptian Pounds)
  /// Prices can be modified based on customizations
  static const Map<String, double> basePrices = {
    'Tea': 5.0,
    'Turkish Coffee': 12.0,
    'Hibiscus Tea': 8.0,
    'Milk Tea': 15.0,
    'Sa7lab': 18.0,
    'Green Tea': 10.0,
    'Black Coffee': 8.0,
    'Cappuccino': 20.0,
    'Latte': 22.0,
    'Americano': 15.0,
    'Espresso': 12.0,
    'Hot Chocolate': 16.0,
    'Iced Coffee': 14.0,
    'Frappe': 18.0,
    'Mint Tea': 6.0,
    'Anise Tea': 7.0,
  };
  
  // UI Constants
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 8.0;
  static const double defaultBorderRadius = 12.0;
  
  // Business Logic Constants
  static const int maxOrderItems = 20;
  static const int minQuantity = 1;
  static const int maxQuantity = 10;
}