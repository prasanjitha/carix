import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../theme/app_colors.dart';
import '../../utils/formatters.dart';

class AddVehicleScreen extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onNext;
  final Map<String, dynamic>? initialData;

  const AddVehicleScreen({super.key, required this.onNext, this.initialData});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _modelNameController = TextEditingController();
  final TextEditingController _avgKmlController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  String _selectedBrand = '';
  String _selectedFuelType = '';
  Color _selectedColor =
      Colors.white; // Defaulting to first in list (actually white is in list)
  String _selectedVehicleType = 'Car'; // Default selection

  final List<Map<String, dynamic>> _vehicleTypes = [
    {'name': 'Car', 'icon': Icons.directions_car},
    {'name': 'Bike', 'icon': Icons.motorcycle},
    {'name': 'Bus', 'icon': Icons.directions_bus},
    {'name': 'Three-Wheel', 'icon': Icons.electric_rickshaw},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null && widget.initialData!.isNotEmpty) {
      final data = widget.initialData!;
      _vehicleNumberController.text = data['vehicleNumber'] ?? '';
      _modelNameController.text = data['modelName'] ?? '';

      final rawAvgKml = data['avgKml']?.toString() ?? '';
      _avgKmlController.text = ThousandsSeparatorInputFormatter.formatString(
        rawAvgKml,
      );

      _nicknameController.text = data['nickname'] ?? '';
      _selectedBrand = data['brand'] ?? '';
      _selectedFuelType = data['fuelType'] ?? '';
      _selectedVehicleType = data['vehicleType'] ?? 'Car';
      if (data['colorHex'] != null) {
        _selectedColor = Color(int.parse(data['colorHex'], radix: 16));
      }
    }
  }

  final List<Map<String, dynamic>> _carBrands = [
    // Japanese Brands (Most Popular in LK)
    {'name': 'Toyota', 'icon': Icons.directions_car},
    {'name': 'Honda', 'icon': Icons.directions_car_filled},
    {'name': 'Nissan', 'icon': Icons.directions_car},
    {'name': 'Suzuki', 'icon': Icons.directions_car},
    {'name': 'Mitsubishi', 'icon': Icons.directions_car},
    {'name': 'Mazda', 'icon': Icons.directions_car_outlined},
    {'name': 'Subaru', 'icon': Icons.directions_car_sharp},
    {'name': 'Lexus', 'icon': Icons.directions_car},

    // European & Luxury Brands
    {'name': 'Mercedes', 'icon': Icons.directions_car_sharp},
    {'name': 'BMW', 'icon': Icons.directions_car_outlined},
    {'name': 'Audi', 'icon': Icons.directions_car},
    {'name': 'Volkswagen', 'icon': Icons.directions_car},
    {'name': 'Volvo', 'icon': Icons.security},
    {'name': 'Land Rover', 'icon': Icons.terrain},
    {'name': 'Jaguar', 'icon': Icons.directions_car},
    {'name': 'Porsche', 'icon': Icons.speed},
    {'name': 'Peugeot', 'icon': Icons.directions_car},

    // Korean Brands
    {'name': 'Hyundai', 'icon': Icons.directions_car},
    {'name': 'Kia', 'icon': Icons.directions_car},

    // American & EV Brands
    {'name': 'Tesla', 'icon': Icons.electric_car},
    {'name': 'Ford', 'icon': Icons.directions_car},
    {'name': 'Chevrolet', 'icon': Icons.directions_car},
    {'name': 'Jeep', 'icon': Icons.time_to_leave},

    // Chinese Brands (Rising in LK)
    {'name': 'MG', 'icon': Icons.directions_car},
    {'name': 'BYD', 'icon': Icons.electric_car},
    {'name': 'DFSK', 'icon': Icons.directions_car},
    {'name': 'Changan', 'icon': Icons.directions_car},

    // Indian Brands
    {'name': 'Tata', 'icon': Icons.directions_car},
    {'name': 'Mahindra', 'icon': Icons.directions_car},
  ];

  final List<Map<String, dynamic>> _busBrands = [
    {'name': 'Leyland', 'icon': Icons.directions_bus},
    {'name': 'Tata', 'icon': Icons.directions_bus_filled},
    {'name': 'Mitsubishi', 'icon': Icons.directions_bus},
    {'name': 'Isuzu', 'icon': Icons.directions_bus},
  ];

  final List<Map<String, dynamic>> _threeWheelBrands = [
    {'name': 'Bajaj', 'icon': Icons.electric_rickshaw},
    {'name': 'TVS', 'icon': Icons.electric_rickshaw},
    {'name': 'Piaggio', 'icon': Icons.electric_rickshaw},
  ];

  final List<Map<String, dynamic>> _bikeBrands = [
    // Popular Indian Brands (Highest usage in LK)
    {'name': 'Bajaj', 'icon': Icons.motorcycle},
    {'name': 'TVS', 'icon': Icons.motorcycle_sharp},
    {'name': 'Hero', 'icon': Icons.motorcycle},
    {'name': 'Yamaha', 'icon': Icons.motorcycle_outlined}, // India & Japan
    {'name': 'Honda', 'icon': Icons.two_wheeler},
    {'name': 'Suzuki', 'icon': Icons.two_wheeler},

    // High-end & Performance
    {'name': 'Kawasaki', 'icon': Icons.motorcycle},
    {'name': 'KTM', 'icon': Icons.motorcycle},
    {'name': 'Royal Enfield', 'icon': Icons.motorcycle},
    {'name': 'BMW', 'icon': Icons.two_wheeler},
    {'name': 'Ducati', 'icon': Icons.motorcycle},
    {'name': 'Triumph', 'icon': Icons.motorcycle},
    {'name': 'Harley-Davidson', 'icon': Icons.motorcycle},

    // Electric Bikes & Scooters
    {'name': 'Ather', 'icon': Icons.electric_moped},
    {'name': 'Ola', 'icon': Icons.electric_bike},
    {'name': 'NIU', 'icon': Icons.moped},
  ];

  List<Map<String, dynamic>> get _currentBrands {
    switch (_selectedVehicleType) {
      case 'Bike':
        return _bikeBrands;
      case 'Bus':
        return _busBrands;
      case 'Three-Wheel':
        return _threeWheelBrands;
      case 'Car':
      default:
        return _carBrands;
    }
  }

  final List<Map<String, String>> _fuelTypesAll = [
    {'name': 'Petrol', 'icon': '⛽'},
    {'name': 'Diesel', 'icon': '🛢'},
    {'name': 'Electric', 'icon': '⚡'},
    {'name': 'Hybrid', 'icon': '🔋'},
  ];

  List<Map<String, String>> get _currentFuelTypes {
    switch (_selectedVehicleType) {
      case 'Bike':
        return _fuelTypesAll
            .where((f) => ['Petrol', 'Electric'].contains(f['name']))
            .toList();
      case 'Three-Wheel':
        return _fuelTypesAll
            .where((f) => ['Petrol', 'Diesel', 'Electric'].contains(f['name']))
            .toList();
      case 'Bus':
        return _fuelTypesAll
            .where((f) => ['Diesel', 'Electric'].contains(f['name']))
            .toList();
      case 'Car':
      default:
        return _fuelTypesAll;
    }
  }

  final List<Color> _vehicleColors = [
    // Basics & Pearl Shades
    Colors.white, // Pure White
    const Color(0xFFB71C1C), // Candy Apple Red
    const Color(0xFF880E4F), // Wine Red / Maroon
    const Color(0xFFFF4500), // Orange Red (Sports Look)
    const Color(0xFFFF8C00), // Dark Orange
    // Blues & Greens
    const Color(0xFF0D47A1), // Royal Blue
    const Color(0xFF1A237E), // Midnight Blue
    const Color(0xFF00ACC1), // Electric Cyan / Teal
    const Color(0xFF004D40), // British Racing Green
    const Color(0xFF1B5E20), // Dark Emerald Green
    const Color(0xFFF5F5F5), // Pearl White (Metallic)
    Colors.black, // Jet Black
    const Color(0xFF212121), // Matte Black
    // Greys & Silvers
    const Color(0xFFC0C0C0), // Silver Metallic
    const Color(0xFF808080), // Classic Grey
    const Color(0xFF37474F), // Gunmetal Grey / Blue Grey
    const Color(0xFF263238), // Anthracite (තද අළු පාට)
    // Reds & Oranges
    // Luxury & Special Shades
    const Color(0xFFFFD700), // Champagne Gold
    const Color(0xFF4E342E), // Coffee Brown
    const Color(0xFF6A1B9A), // Deep Purple
    const Color(0xFFF5F5DC), // Beige / Ivory
    const Color(0xFFE0E0E0), // Platinum Silver
  ];

  void _showCustomToast(String message) {
    final fToast = FToast();
    fToast.init(context);

    final isSuccess = message.toLowerCase().contains('success');
    final gradientColors = isSuccess
        ? [
            const Color(0xFF10B981).withValues(alpha: 0.35),
            const Color(0xFF059669).withValues(alpha: 0.15),
          ]
        : [
            AppColors.primary.withValues(alpha: 0.35),
            AppColors.primary.withValues(alpha: 0.15),
          ];
    final borderColor = isSuccess
        ? const Color(0xFF10B981).withValues(alpha: 0.3)
        : AppColors.primary.withValues(alpha: 0.3);

    Widget toast = ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10.0),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP_RIGHT,
      toastDuration: const Duration(seconds: 3),
    );
  }

  void _validateAndContinue() {
    final vehicleNumber = _vehicleNumberController.text.trim();
    final modelName = _modelNameController.text.trim();
    final avgKmlText = _avgKmlController.text.trim();
    final nickname = _nicknameController.text.trim();

    if (vehicleNumber.isEmpty) {
      _showCustomToast('Vehicle Number is required');
      return;
    }
    if (_selectedBrand.isEmpty) {
      _showCustomToast('Brand is required');
      return;
    }
    if (modelName.isEmpty) {
      _showCustomToast('Model Name is required');
      return;
    }
    if (_selectedFuelType.isEmpty) {
      _showCustomToast('Fuel Type is required');
      return;
    }
    if (avgKmlText.isEmpty) {
      _showCustomToast('Avg. KM/L is required');
      return;
    }

    double? avgKml = double.tryParse(avgKmlText.replaceAll(',', ''));
    if (avgKml == null) {
      _showCustomToast('Valid Avg. KM/L is required');
      return;
    }

    final data = {
      'vehicleNumber': 'WP $vehicleNumber', // Assuming prefix is handled
      'brand': _selectedBrand,
      'modelName': modelName,
      'fuelType': _selectedFuelType,
      'avgKml': avgKml,
      'nickname': nickname.isEmpty ? 'My $_selectedVehicleType' : nickname,
      'colorHex': _selectedColor.toARGB32().toRadixString(16).padLeft(8, '0'),
      'vehicleType': _selectedVehicleType,
    };

    widget.onNext(data);
  }

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    _modelNameController.dispose();
    _avgKmlController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Let\'s customize your smart dashboard.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Vehicle Number
          const Text(
            'Vehicle Number',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _vehicleNumberController,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 2.0,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. WP-KY-1234',
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontWeight: FontWeight.normal,
                letterSpacing: 0,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 12,
                  bottom: 12,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Text(
                    'WP',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cyan),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.03),
            ),
          ),
          const SizedBox(height: 24),

          // Vehicle Type
          const Text(
            'Vehicle Type',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _vehicleTypes.map((type) {
              final isSelected = _selectedVehicleType == type['name'];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedVehicleType = type['name'] as String;
                    // Reset selected brand and fuel type when vehicle type changes
                    _selectedBrand = '';
                    _selectedFuelType = '';
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.cyan.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.cyan
                          : Colors.white.withValues(alpha: 0.1),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        type['icon'] as IconData,
                        color: isSelected ? AppColors.cyan : Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        type['name'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Brand Selector
          const Text(
            'Select Brand',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _currentBrands.length,
              itemBuilder: (context, index) {
                final brand = _currentBrands[index];
                final isSelected = _selectedBrand == brand['name'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedBrand = brand['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 76,
                    margin: const EdgeInsets.only(right: 12, bottom: 8, top: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.cyan.withValues(alpha: 0.1)
                          : Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.cyan
                            : Colors.white.withValues(alpha: 0.1),
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.cyan.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          brand['icon'],
                          color: isSelected ? AppColors.cyan : Colors.white70,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          brand['name'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Model Name
          const Text(
            'Model Name',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _modelNameController,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. Camry Hybrid XLE',
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontWeight: FontWeight.normal,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cyan),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.03),
            ),
          ),
          const SizedBox(height: 24),

          // Fuel Type
          const Text(
            'Fuel Type',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _currentFuelTypes.map((type) {
              final isSelected = _selectedFuelType == type['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedFuelType = type['name']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.cyan.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.cyan
                          : Colors.white.withValues(alpha: 0.1),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.cyan.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 0),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(type['icon']!, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        type['name']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Odometer & Avg KM/L Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AVG. KM/L',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _avgKmlController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [ThousandsSeparatorInputFormatter()],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: '18.5',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.cyan),
                          ),
                          filled: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Vehicle Nickname
          const Text(
            'Vehicle Nickname',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nicknameController,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'e.g. Blue Thunder',
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontWeight: FontWeight.normal,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cyan),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.03),
            ),
          ),
          const SizedBox(height: 24),

          // Vehicle Color
          const Text(
            'Vehicle Color',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height:
                45, // Container එකේ උස (Circle එකේ radius එකට වඩා ටිකක් වැඩිපුර)
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _vehicleColors.length,
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ), // දෙපැත්තෙන් පොඩි ඉඩක්
              itemBuilder: (context, index) {
                final color = _vehicleColors[index];
                final isSelected = _selectedColor == color;

                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 14),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppColors.cyan : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        // සුදු පාට එකට විතරක් border එකක් දාන්න
                        border: color == Colors.white
                            ? Border.all(color: Colors.white24)
                            : null,
                        // පොඩි shadow එකක් දැම්මම premium ලුක් එකක් එනවා
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: 18,
                              color: color == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                            )
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),

          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: AppColors.cyan,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: _validateAndContinue,
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Color(
                            0xFF0D1117,
                          ), // very dark background color for contrast
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
