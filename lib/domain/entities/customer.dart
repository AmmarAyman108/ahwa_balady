class Customer {
  final String _name;
  final DateTime _registrationDate;

  Customer({
    required String name,
    DateTime? registrationDate,
  })  : _name = name.trim(),
        _registrationDate = registrationDate ?? DateTime.now();

  String get name => _name;
  DateTime get registrationDate => _registrationDate;

  bool get isRegularCustomer {
    final daysDifference = DateTime.now().difference(_registrationDate).inDays;
    return daysDifference > 30;
  }

  String get greetingMessage {
    if (isRegularCustomer) {
      return 'Welcome back, $_name!';
    }
    return 'Hello, $_name!';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer &&
          runtimeType == other.runtimeType &&
          _name == other._name;

  @override
  int get hashCode => _name.hashCode;

  @override
  String toString() => 'Customer{name: $_name, registrationDate: $_registrationDate}';

  Customer copyWith({
    String? name,
    DateTime? registrationDate,
  }) {
    return Customer(
      name: name ?? _name,
      registrationDate: registrationDate ?? _registrationDate,
    );
  }
}