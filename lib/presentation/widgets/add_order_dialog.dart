import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/drink.dart';
import '../providers/order_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class AddOrderDialog extends StatefulWidget {
  const AddOrderDialog({super.key});

  @override
  State<AddOrderDialog> createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<AddOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _specialInstructionsController = TextEditingController();
  final _uuid = const Uuid();

  final List<OrderItemInput> _orderItems = [];

  @override
  void initState() {
    super.initState();
    _addNewItem();
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _specialInstructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 8,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: 400,
          ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enhanced Header with rounded top corners
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Add New Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content area with proper scrolling
            Flexible(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced Customer Name Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextFormField(
                          controller: _customerNameController,
                          decoration: InputDecoration(
                            labelText: 'Customer Name',
                            hintText: 'Enter customer name',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.primary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter customer name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Enhanced Drinks Section Header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_cafe,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Drinks',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: _addNewItem,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Add Drink',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._orderItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return _buildOrderItemCard(item, index);
                      }),
                      const SizedBox(height: 20),
                      // Enhanced Special Instructions Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextFormField(
                          controller: _specialInstructionsController,
                          decoration: InputDecoration(
                            labelText: 'Special Instructions (Optional)',
                            hintText: 'e.g., extra sugar, no ice, make it hot',
                            prefixIcon: Icon(
                              Icons.edit_note,
                              color: AppColors.primary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            labelStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                          ),
                          maxLines: 3,
                          minLines: 2,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Enhanced Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1.5,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => Navigator.of(context).pop(),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryDark,
                                  ],
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: _submitOrder,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.shopping_cart_checkout,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Add Order',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ), // Close Dialog widget
  ); // Close PopScope widget
  }

  Widget _buildOrderItemCard(OrderItemInput item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Drink Type Dropdown - Enhanced with better overflow handling
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: item.drinkType,
                      isExpanded: true, // This prevents overflow
                      decoration: InputDecoration(
                        labelText: 'Drink Type',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      items: AppConstants.drinkTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis, // Handle text overflow
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          item.drinkType = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a drink type';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Quantity Field - Enhanced
                SizedBox(
                  width: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextFormField(
                      initialValue: item.quantity.toString(),
                      decoration: InputDecoration(
                        labelText: 'Qty',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: InputBorder.none,
                        labelStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        item.quantity = int.tryParse(value) ?? 1;
                      },
                      validator: (value) {
                        final quantity = int.tryParse(value ?? '');
                        if (quantity == null || quantity < 1) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Delete Button - Enhanced
                Container(
                  decoration: BoxDecoration(
                    color: _orderItems.length > 1 
                        ? AppColors.error.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: _orderItems.length > 1 
                          ? AppColors.error
                          : Colors.grey[400],
                      size: 20,
                    ),
                    onPressed: _orderItems.length > 1 ? () => _removeItem(index) : null,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ),
              ],
            ),
            if (item.drinkType != null) _buildDrinkOptions(item),
          ],
        ),
      ),
    );
  }

  /// Enhanced drink options builder supporting all drink types
  /// Follows Single Responsibility Principle - each case handles one drink type
  Widget _buildDrinkOptions(OrderItemInput item) {
    switch (item.drinkType) {
      case 'Tea':
        return _buildTeaOptions(item);
      case 'Turkish Coffee':
        return _buildTurkishCoffeeOptions(item);
      case 'Hibiscus Tea':
        return _buildHibiscusTeaOptions(item);
      case 'Milk Tea':
        return _buildMilkTeaOptions(item);
      case 'Sa7lab':
        return _buildSa7labOptions(item);
      case 'Green Tea':
      case 'Mint Tea':
      case 'Anise Tea':
      case 'Hot Chocolate':
        return _buildSpecialtyDrinkOptions(item);
      case 'Black Coffee':
      case 'Cappuccino':
      case 'Latte':
      case 'Americano':
      case 'Espresso':
      case 'Iced Coffee':
      case 'Frappe':
        return _buildEspressoDrinkOptions(item);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTeaOptions(OrderItemInput item) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('With Mint'),
                value: item.withMint,
                onChanged: (bool? value) {
                  setState(() {
                    item.withMint = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Extra Sugar'),
                value: item.extraSugar,
                onChanged: (bool? value) {
                  setState(() {
                    item.extraSugar = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTurkishCoffeeOptions(OrderItemInput item) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        DropdownButtonFormField<SugarLevel>(
          value: item.sugarLevel,
          decoration: const InputDecoration(
            labelText: 'Sugar Level',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: SugarLevel.values.map((SugarLevel level) {
            return DropdownMenuItem<SugarLevel>(
              value: level,
              child: Text(level.englishName),
            );
          }).toList(),
          onChanged: (SugarLevel? newValue) {
            setState(() {
              item.sugarLevel = newValue ?? SugarLevel.medium;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('With Cardamom'),
          value: item.withCardamom,
          onChanged: (bool? value) {
            setState(() {
              item.withCardamom = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildHibiscusTeaOptions(OrderItemInput item) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Hot'),
                value: true,
                groupValue: item.hot,
                onChanged: (bool? value) {
                  setState(() {
                    item.hot = value ?? true;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Cold'),
                value: false,
                groupValue: item.hot,
                onChanged: (bool? value) {
                  setState(() {
                    item.hot = !(value ?? false);
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        CheckboxListTile(
          title: const Text('With Lemon'),
          value: item.withLemon,
          onChanged: (bool? value) {
            setState(() {
              item.withLemon = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildMilkTeaOptions(OrderItemInput item) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        DropdownButtonFormField<MilkTeaFlavor>(
          value: item.milkTeaFlavor,
          decoration: const InputDecoration(
            labelText: 'Flavor',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: MilkTeaFlavor.values.map((MilkTeaFlavor flavor) {
            return DropdownMenuItem<MilkTeaFlavor>(
              value: flavor,
              child: Text(flavor.englishName),
            );
          }).toList(),
          onChanged: (MilkTeaFlavor? newValue) {
            setState(() {
              item.milkTeaFlavor = newValue ?? MilkTeaFlavor.original;
            });
          },
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Extra Milk'),
                value: item.extraMilk,
                onChanged: (bool? value) {
                  setState(() {
                    item.extraMilk = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<SugarLevel>(
                value: item.sugarLevel,
                decoration: const InputDecoration(
                  labelText: 'Sugar',
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                items: SugarLevel.values.map((SugarLevel level) {
                  return DropdownMenuItem<SugarLevel>(
                    value: level,
                    child: Text(level.englishName),
                  );
                }).toList(),
                onChanged: (SugarLevel? newValue) {
                  setState(() {
                    item.sugarLevel = newValue ?? SugarLevel.medium;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSa7labOptions(OrderItemInput item) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        CheckboxListTile(
          title: const Text('With Nuts'),
          value: item.withNuts,
          onChanged: (bool? value) {
            setState(() {
              item.withNuts = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Cinnamon'),
                value: item.withCinnamon,
                onChanged: (bool? value) {
                  setState(() {
                    item.withCinnamon = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Coconut'),
                value: item.withCoconut,
                onChanged: (bool? value) {
                  setState(() {
                    item.withCoconut = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        DropdownButtonFormField<SugarLevel>(
          value: item.sugarLevel,
          decoration: const InputDecoration(
            labelText: 'Sugar Level',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: SugarLevel.values.map((SugarLevel level) {
            return DropdownMenuItem<SugarLevel>(
              value: level,
              child: Text(level.englishName),
            );
          }).toList(),
          onChanged: (SugarLevel? newValue) {
            setState(() {
              item.sugarLevel = newValue ?? SugarLevel.medium;
            });
          },
        ),
      ],
    );
  }

  Widget _buildEspressoDrinkOptions(OrderItemInput item) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Extra Shot'),
                value: item.extraShot,
                onChanged: (bool? value) {
                  setState(() {
                    item.extraShot = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<MilkType>(
                value: item.milkType,
                decoration: const InputDecoration(
                  labelText: 'Milk',
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                items: MilkType.values.map((MilkType type) {
                  return DropdownMenuItem<MilkType>(
                    value: type,
                    child: Text(type.englishName),
                  );
                }).toList(),
                onChanged: (MilkType? newValue) {
                  setState(() {
                    item.milkType = newValue ?? MilkType.regular;
                  });
                },
              ),
            ),
          ],
        ),
        DropdownButtonFormField<SugarLevel>(
          value: item.sugarLevel,
          decoration: const InputDecoration(
            labelText: 'Sugar Level',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: SugarLevel.values.map((SugarLevel level) {
            return DropdownMenuItem<SugarLevel>(
              value: level,
              child: Text(level.englishName),
            );
          }).toList(),
          onChanged: (SugarLevel? newValue) {
            setState(() {
              item.sugarLevel = newValue ?? SugarLevel.medium;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSpecialtyDrinkOptions(OrderItemInput item) {
    return Column(
      children: [
        SizedBox(height: 8.h),
        DropdownButtonFormField<SugarLevel>(
          value: item.sugarLevel,
          decoration: const InputDecoration(
            labelText: 'Sugar Level',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: SugarLevel.values.map((SugarLevel level) {
            return DropdownMenuItem<SugarLevel>(
              value: level,
              child: Text(level.englishName),
            );
          }).toList(),
          onChanged: (SugarLevel? newValue) {
            setState(() {
              item.sugarLevel = newValue ?? SugarLevel.medium;
            });
          },
        ),
        if (item.drinkType == 'Hot Chocolate')
          CheckboxListTile(
            title: const Text('With Marshmallows'),
            value: item.additions.contains('Marshmallows'),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  if (!item.additions.contains('Marshmallows')) {
                    item.additions.add('Marshmallows');
                  }
                } else {
                  item.additions.remove('Marshmallows');
                }
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
      ],
    );
  }

  void _addNewItem() {
    setState(() {
      _orderItems.add(OrderItemInput());
    });
  }

  void _removeItem(int index) {
    setState(() {
      _orderItems.removeAt(index);
    });
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      final validItems = _orderItems.where((item) => item.drinkType != null).toList();
      
      if (validItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(' Please add at least one drink')),
        );
        return;
      }

      final customer = Customer(name: _customerNameController.text.trim());
      final orderItems = validItems.map((item) => item.toOrderItem()).toList();
      
      final order = Order(
        id: _uuid.v4(),
        customer: customer,
        items: orderItems,
        specialInstructions: _specialInstructionsController.text.trim(),
      );

      context.read<OrderProvider>().addOrder(order);
      Navigator.of(context).pop();
    }
  }
}

/// Enhanced order item input class supporting all drink types
/// Follows Single Responsibility Principle - handles one order item
class OrderItemInput {
  String? drinkType;
  int quantity = 1;
  
  // Tea options
  bool withMint = false;
  bool extraSugar = false;
  
  // Turkish Coffee options
  SugarLevel sugarLevel = SugarLevel.medium;
  bool withCardamom = false;
  
  // Hibiscus Tea options
  bool hot = true;
  bool withLemon = false;
  
  // Milk Tea options
  MilkTeaFlavor milkTeaFlavor = MilkTeaFlavor.original;
  bool extraMilk = false;
  
  // Sa7lab options
  bool withNuts = true;
  bool withCinnamon = false;
  bool withCoconut = false;
  
  // Espresso drinks options
  bool extraShot = false;
  MilkType milkType = MilkType.regular;
  
  // Specialty drinks options
  List<String> additions = [];

  OrderItem toOrderItem() {
    final drinkId = const Uuid().v4();
    final basePrice = AppConstants.basePrices[drinkType] ?? 0.0;
    
    Drink drink;
    switch (drinkType) {
      case 'Tea':
        drink = Shai(
          id: drinkId,
          name: drinkType!,
          price: basePrice,
          withMint: withMint,
          extraSugar: extraSugar,
        );
        break;
      case 'Turkish Coffee':
        drink = TurkishCoffee(
          id: drinkId,
          name: drinkType!,
          price: basePrice,
          sugarLevel: sugarLevel,
          withCardamom: withCardamom,
        );
        break;
      case 'Hibiscus Tea':
        drink = HibiscusTea(
          id: drinkId,
          name: drinkType!,
          price: basePrice,
          hot: hot,
          withLemon: withLemon,
        );
        break;
      case 'Milk Tea':
        drink = MilkTea(
          id: drinkId,
          name: drinkType!,
          price: basePrice,
          flavor: milkTeaFlavor,
          extraMilk: extraMilk,
          sugarLevel: sugarLevel,
        );
        break;
      case 'Sa7lab':
        drink = Sa7lab(
          id: drinkId,
          name: drinkType!,
          price: basePrice,
          withNuts: withNuts,
          withCinnamon: withCinnamon,
          withCoconut: withCoconut,
          sugarLevel: sugarLevel,
        );
        break;
      case 'Green Tea':
      case 'Mint Tea':
      case 'Anise Tea':
      case 'Hot Chocolate':
        drink = SpecialtyDrink(
          id: drinkId,
          name: drinkType!,
          price: basePrice,
          specialtyType: _getSpecialtyType(drinkType!),
          additions: additions,
          sugarLevel: sugarLevel,
        );
        break;
      case 'Black Coffee':
      case 'Cappuccino':
      case 'Latte':
      case 'Americano':
      case 'Espresso':
      case 'Iced Coffee':
      case 'Frappe':
        drink = EspressoDrink(
          id: drinkId,
          name: drinkType!,
          price: basePrice,
          espressoType: _getEspressoType(drinkType!),
          sugarLevel: sugarLevel,
          extraShot: extraShot,
          milkType: milkType,
        );
        break;
      default:
        throw ArgumentError('Unknown drink type: $drinkType');
    }

    return OrderItem(drink: drink, quantity: quantity);
  }
  
  /// Helper method to get specialty type from drink name
  SpecialtyType _getSpecialtyType(String drinkName) {
    switch (drinkName) {
      case 'Green Tea': return SpecialtyType.greenTea;
      case 'Mint Tea': return SpecialtyType.mintTea;
      case 'Anise Tea': return SpecialtyType.aniseTea;
      case 'Hot Chocolate': return SpecialtyType.hotChocolate;
      default: return SpecialtyType.greenTea;
    }
  }
  
  /// Helper method to get espresso type from drink name
  EspressoType _getEspressoType(String drinkName) {
    switch (drinkName) {
      case 'Black Coffee': return EspressoType.blackCoffee;
      case 'Cappuccino': return EspressoType.cappuccino;
      case 'Latte': return EspressoType.latte;
      case 'Americano': return EspressoType.americano;
      case 'Espresso': return EspressoType.espresso;
      case 'Iced Coffee': return EspressoType.icedCoffee;
      case 'Frappe': return EspressoType.frappe;
      default: return EspressoType.espresso;
    }
  }
}