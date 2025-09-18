/// Abstract base class for all drinks in the cafe
/// Follows Open-Closed Principle: open for extension, closed for modification
abstract class Drink {
  final String id;
  final String name;
  final double price;

  const Drink({
    required this.id,
    required this.name,
    required this.price,
  });

  /// Returns the display name with customizations
  String get displayName;
  
  /// Calculates final price including customizations and quantity
  double calculatePrice({required int quantity});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Drink &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Drink{id: $id, name: $name, price: $price}';
}

/// Traditional Tea implementation with customization options
class Shai extends Drink {
  final bool withMint;
  final bool extraSugar;

  const Shai({
    required super.id,
    required super.name,
    required super.price,
    this.withMint = false,
    this.extraSugar = false,
  });

  @override
  String get displayName => 'Tea${withMint ? ' with Mint' : ''}${extraSugar ? ' Extra Sweet' : ''}';

  @override
  double calculatePrice({required int quantity}) {
    double finalPrice = price;
    if (withMint) finalPrice += 2.0;
    if (extraSugar) finalPrice += 1.0;
    return finalPrice * quantity;
  }

  Shai copyWith({
    String? id,
    String? name,
    double? price,
    bool? withMint,
    bool? extraSugar,
  }) {
    return Shai(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      withMint: withMint ?? this.withMint,
      extraSugar: extraSugar ?? this.extraSugar,
    );
  }
}

/// Traditional Turkish Coffee with sugar levels and cardamom option
class TurkishCoffee extends Drink {
  final SugarLevel sugarLevel;
  final bool withCardamom;

  const TurkishCoffee({
    required super.id,
    required super.name,
    required super.price,
    this.sugarLevel = SugarLevel.medium,
    this.withCardamom = false,
  });

  @override
  String get displayName => 'Turkish Coffee ${sugarLevel.englishName}${withCardamom ? ' with Cardamom' : ''}';

  @override
  double calculatePrice({required int quantity}) {
    double finalPrice = price;
    if (withCardamom) finalPrice += 3.0;
    return finalPrice * quantity;
  }

  TurkishCoffee copyWith({
    String? id,
    String? name,
    double? price,
    SugarLevel? sugarLevel,
    bool? withCardamom,
  }) {
    return TurkishCoffee(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      withCardamom: withCardamom ?? this.withCardamom,
    );
  }
}

/// Hibiscus Tea with temperature and lemon options
class HibiscusTea extends Drink {
  final bool hot;
  final bool withLemon;

  const HibiscusTea({
    required super.id,
    required super.name,
    required super.price,
    this.hot = true,
    this.withLemon = false,
  });

  @override
  String get displayName => 'Hibiscus Tea ${hot ? 'Hot' : 'Cold'}${withLemon ? ' with Lemon' : ''}';

  @override
  double calculatePrice({required int quantity}) {
    double finalPrice = price;
    if (withLemon) finalPrice += 1.5;
    return finalPrice * quantity;
  }

  HibiscusTea copyWith({
    String? id,
    String? name,
    double? price,
    bool? hot,
    bool? withLemon,
  }) {
    return HibiscusTea(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      hot: hot ?? this.hot,
      withLemon: withLemon ?? this.withLemon,
    );
  }
}

/// Creamy Milk Tea with various flavor options
class MilkTea extends Drink {
  final MilkTeaFlavor flavor;
  final bool extraMilk;
  final SugarLevel sugarLevel;

  const MilkTea({
    required super.id,
    required super.name,
    required super.price,
    this.flavor = MilkTeaFlavor.original,
    this.extraMilk = false,
    this.sugarLevel = SugarLevel.medium,
  });

  @override
  String get displayName => 'Milk Tea ${flavor.englishName}${extraMilk ? ' Extra Milk' : ''} ${sugarLevel.englishName}';

  @override
  double calculatePrice({required int quantity}) {
    double finalPrice = price;
    if (extraMilk) finalPrice += 3.0;
    if (flavor != MilkTeaFlavor.original) finalPrice += 2.0;
    return finalPrice * quantity;
  }

  MilkTea copyWith({
    String? id,
    String? name,
    double? price,
    MilkTeaFlavor? flavor,
    bool? extraMilk,
    SugarLevel? sugarLevel,
  }) {
    return MilkTea(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      flavor: flavor ?? this.flavor,
      extraMilk: extraMilk ?? this.extraMilk,
      sugarLevel: sugarLevel ?? this.sugarLevel,
    );
  }
}

/// Traditional Egyptian hot milk drink with nuts and spices
class Sa7lab extends Drink {
  final bool withNuts;
  final bool withCinnamon;
  final bool withCoconut;
  final SugarLevel sugarLevel;

  const Sa7lab({
    required super.id,
    required super.name,
    required super.price,
    this.withNuts = true,
    this.withCinnamon = false,
    this.withCoconut = false,
    this.sugarLevel = SugarLevel.medium,
  });

  @override
  String get displayName {
    List<String> additions = [];
    if (withNuts) additions.add('Nuts');
    if (withCinnamon) additions.add('Cinnamon');
    if (withCoconut) additions.add('Coconut');
    
    String additionsStr = additions.isNotEmpty ? ' with ${additions.join(', ')}' : '';
    return 'Sa7lab$additionsStr ${sugarLevel.englishName}';
  }

  @override
  double calculatePrice({required int quantity}) {
    double finalPrice = price;
    if (withNuts) finalPrice += 3.0;
    if (withCinnamon) finalPrice += 1.0;
    if (withCoconut) finalPrice += 2.0;
    return finalPrice * quantity;
  }

  Sa7lab copyWith({
    String? id,
    String? name,
    double? price,
    bool? withNuts,
    bool? withCinnamon,
    bool? withCoconut,
    SugarLevel? sugarLevel,
  }) {
    return Sa7lab(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      withNuts: withNuts ?? this.withNuts,
      withCinnamon: withCinnamon ?? this.withCinnamon,
      withCoconut: withCoconut ?? this.withCoconut,
      sugarLevel: sugarLevel ?? this.sugarLevel,
    );
  }
}

/// Premium coffee drinks with espresso base
class EspressoDrink extends Drink {
  final EspressoType espressoType;
  final SugarLevel sugarLevel;
  final bool extraShot;
  final MilkType milkType;

  const EspressoDrink({
    required super.id,
    required super.name,
    required super.price,
    required this.espressoType,
    this.sugarLevel = SugarLevel.none,
    this.extraShot = false,
    this.milkType = MilkType.regular,
  });

  @override
  String get displayName {
    String base = espressoType.englishName;
    if (extraShot) base += ' Extra Shot';
    if (milkType != MilkType.regular) base += ' ${milkType.englishName} Milk';
    if (sugarLevel != SugarLevel.none) base += ' ${sugarLevel.englishName}';
    return base;
  }

  @override
  double calculatePrice({required int quantity}) {
    double finalPrice = price;
    if (extraShot) finalPrice += 4.0;
    if (milkType == MilkType.soy || milkType == MilkType.almond) finalPrice += 3.0;
    return finalPrice * quantity;
  }

  EspressoDrink copyWith({
    String? id,
    String? name,
    double? price,
    EspressoType? espressoType,
    SugarLevel? sugarLevel,
    bool? extraShot,
    MilkType? milkType,
  }) {
    return EspressoDrink(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      espressoType: espressoType ?? this.espressoType,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      extraShot: extraShot ?? this.extraShot,
      milkType: milkType ?? this.milkType,
    );
  }
}

/// Specialty drinks like hot chocolate and herbal teas
class SpecialtyDrink extends Drink {
  final SpecialtyType specialtyType;
  final List<String> additions;
  final SugarLevel sugarLevel;

  const SpecialtyDrink({
    required super.id,
    required super.name,
    required super.price,
    required this.specialtyType,
    this.additions = const [],
    this.sugarLevel = SugarLevel.medium,
  });

  @override
  String get displayName {
    String base = specialtyType.englishName;
    if (additions.isNotEmpty) base += ' with ${additions.join(', ')}';
    if (sugarLevel != SugarLevel.none) base += ' ${sugarLevel.englishName}';
    return base;
  }

  @override
  double calculatePrice({required int quantity}) {
    double finalPrice = price;
    finalPrice += additions.length * 1.5; // Each addition costs 1.5 EGP
    return finalPrice * quantity;
  }

  SpecialtyDrink copyWith({
    String? id,
    String? name,
    double? price,
    SpecialtyType? specialtyType,
    List<String>? additions,
    SugarLevel? sugarLevel,
  }) {
    return SpecialtyDrink(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      specialtyType: specialtyType ?? this.specialtyType,
      additions: additions ?? this.additions,
      sugarLevel: sugarLevel ?? this.sugarLevel,
    );
  }
}

// Enums for drink customization options

/// Sugar levels for all drinks that support sweetening
enum SugarLevel {
  none('No Sugar'),
  light('Light Sugar'),
  medium('Medium Sugar'),
  heavy('Heavy Sugar');

  const SugarLevel(this.englishName);
  final String englishName;
}

/// Milk tea flavor variations
enum MilkTeaFlavor {
  original('Original'),
  vanilla('Vanilla'),
  chocolate('Chocolate'),
  strawberry('Strawberry'),
  taro('Taro'),
  matcha('Matcha');

  const MilkTeaFlavor(this.englishName);
  final String englishName;
}

/// Types of espresso-based drinks
enum EspressoType {
  espresso('Espresso'),
  americano('Americano'),
  cappuccino('Cappuccino'),
  latte('Latte'),
  blackCoffee('Black Coffee'),
  icedCoffee('Iced Coffee'),
  frappe('Frappe');

  const EspressoType(this.englishName);
  final String englishName;
}

/// Types of milk for coffee drinks
enum MilkType {
  regular('Regular'),
  soy('Soy'),
  almond('Almond'),
  skimmed('Skimmed');

  const MilkType(this.englishName);
  final String englishName;
}

/// Specialty drink types
enum SpecialtyType {
  greenTea('Green Tea'),
  mintTea('Mint Tea'),
  aniseTea('Anise Tea'),
  hotChocolate('Hot Chocolate');

  const SpecialtyType(this.englishName);
  final String englishName;
}