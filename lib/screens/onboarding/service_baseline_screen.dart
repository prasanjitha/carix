import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../theme/app_colors.dart';
import '../../utils/formatters.dart';
import '../main_tab/main_tab_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/vehicle_model.dart';

class ServiceBaselineScreen extends StatefulWidget {
  final Map<String, dynamic> step1Data;
  final Map<String, dynamic>? initialData;
  final VoidCallback onBack;
  final ValueChanged<Map<String, dynamic>> onDataChanged;

  const ServiceBaselineScreen({
    super.key,
    required this.step1Data,
    this.initialData,
    required this.onBack,
    required this.onDataChanged,
  });

  @override
  State<ServiceBaselineScreen> createState() => _ServiceBaselineScreenState();
}

class _ServiceBaselineScreenState extends State<ServiceBaselineScreen> {
  DateTime? _lastServiceDate;
  int? _odometerAtLastService;
  int? _serviceCycle = 10000;
  int? _currentOdometer;
  final TextEditingController _odometerAtLastServiceController =
      TextEditingController();
  final TextEditingController _currentOdometerController =
      TextEditingController();
  final TextEditingController _customCycleController = TextEditingController();

  final List<int?> _serviceCycles = [5000, 10000, 15000, 20000, null];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null && widget.initialData!.isNotEmpty) {
      final data = widget.initialData!;
      _lastServiceDate = data['lastServiceDate'];
      _odometerAtLastService = data['odometerAtLastService'];
      _serviceCycle = data['serviceCycle'];
      _currentOdometer = data['currentOdometer'];

      _odometerAtLastServiceController.text =
          ThousandsSeparatorInputFormatter.formatWithDecimals(
            _odometerAtLastService?.toString() ?? '',
          );
      _currentOdometerController.text =
          ThousandsSeparatorInputFormatter.formatWithDecimals(
            _currentOdometer?.toString() ?? '',
          );
      _customCycleController.text =
          ThousandsSeparatorInputFormatter.formatWithDecimals(
            data['customCycle']?.toString() ?? '',
          );
    }

    _odometerAtLastServiceController.addListener(() {
      _odometerAtLastService = int.tryParse(
        _odometerAtLastServiceController.text.replaceAll(',', ''),
      );
      _updateParentData();
    });
    _currentOdometerController.addListener(() {
      _currentOdometer = int.tryParse(
        _currentOdometerController.text.replaceAll(',', ''),
      );
      _updateParentData();
    });
    _customCycleController.addListener(_updateParentData);
  }

  void _updateParentData() {
    widget.onDataChanged({
      'lastServiceDate': _lastServiceDate,
      'odometerAtLastService': _odometerAtLastService,
      'serviceCycle': _serviceCycle,
      'currentOdometer': _currentOdometer,
      'customCycle': int.tryParse(
        _customCycleController.text.replaceAll(',', ''),
      ),
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _lastServiceDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.cyan,
              onPrimary: Colors.black,
              surface: AppColors.background,
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _lastServiceDate) {
      setState(() {
        _lastServiceDate = picked;
      });
      _updateParentData();
    }
  }

  @override
  void dispose() {
    _odometerAtLastServiceController.dispose();
    _currentOdometerController.dispose();
    _customCycleController.dispose();
    super.dispose();
  }

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

  void _finalizeAndStart() {
    if (_lastServiceDate == null) {
      _showCustomToast('Last Service Date is required');
      return;
    }

    _odometerAtLastService = int.tryParse(
      _odometerAtLastServiceController.text.replaceAll(',', '').trim(),
    );
    if (_odometerAtLastService == null) {
      _showCustomToast('Odometer at Last Service is required');
      return;
    }

    int finalCycle =
        _serviceCycle ??
        int.tryParse(_customCycleController.text.replaceAll(',', '').trim()) ??
        0;
    if (finalCycle <= 0) {
      _showCustomToast('Valid Service Cycle is required');
      return;
    }

    _currentOdometer = int.tryParse(
      _currentOdometerController.text.replaceAll(',', '').trim(),
    );
    if (_currentOdometer == null) {
      _showCustomToast('Current Odometer is required');
      return;
    }

    final data = widget.step1Data;
    final vehicle = VehicleModel(
      vehicleNumber: data['vehicleNumber'],
      brand: data['brand'],
      modelName: data['modelName'],
      fuelType: data['fuelType'],
      odometer:
          _currentOdometer!, // Using current odometer as the main odometer
      avgKml: data['avgKml'],
      nickname: data['nickname'],
      colorHex: data['colorHex'],
      lastServiceDate: _lastServiceDate,
      odometerAtLastService: _odometerAtLastService,
      serviceCycleKm: finalCycle,
    );

    final vehicleBox = Hive.box<VehicleModel>('vehicle_box');
    vehicleBox.put('current_vehicle', vehicle);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainTabScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customShadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4),
        blurRadius: 20,
        spreadRadius: -2,
        offset: const Offset(0, 10),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Baseline Setup',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Calibrate your service tracking engine for accurate reminders.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: customShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Last Service Date
                const Text(
                  'Last Service Date *',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: 'mm/dd/yyyy',
                      suffixIcon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white70,
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                    ),
                    child: Text(
                      _lastServiceDate == null
                          ? 'mm/dd/yyyy'
                          : '${_lastServiceDate!.month}/${_lastServiceDate!.day}/${_lastServiceDate!.year}',
                      style: TextStyle(
                        color: _lastServiceDate == null
                            ? Colors.white38
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Odometer at Last Service
                const Text(
                  'Odometer at Last Service *',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _odometerAtLastServiceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [ThousandsSeparatorInputFormatter()],
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'e.g. 45,000',
                    suffixText: 'km',
                  ),
                ),
                const SizedBox(height: 24),

                // Service Cycle
                const Text(
                  'Service Cycle *',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int?>(
                  value: _serviceCycle,
                  dropdownColor: const Color(0xFF16213E),
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white70,
                  ),
                  decoration: const InputDecoration(filled: true),
                  items: _serviceCycles.map((cycle) {
                    return DropdownMenuItem<int?>(
                      value: cycle,
                      child: Text(cycle == null ? 'Custom' : '$cycle km'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _serviceCycle = val);
                    _updateParentData();
                  },
                ),
                if (_serviceCycle == null) ...[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _customCycleController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 8000',
                      suffixText: 'km',
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                const Text(
                  'Current Odometer *',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _currentOdometerController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [ThousandsSeparatorInputFormatter()],
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'e.g. 48,200',
                    suffixText: 'km',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Info Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE11D48).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE11D48).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info, color: Color(0xFFE11D48)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Accurate data ensures we notify you at the perfect time for your next service.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                  color: Colors.white.withValues(alpha: 0.05),
                ),
                child: IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: widget.onBack,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
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
                  child: ElevatedButton(
                    onPressed: _finalizeAndStart,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'FINALIZE & START',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
