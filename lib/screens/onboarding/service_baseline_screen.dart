import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../main_tab/main_tab_screen.dart';

class ServiceBaselineScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ServiceBaselineScreen({super.key, required this.onBack});

  @override
  State<ServiceBaselineScreen> createState() => _ServiceBaselineScreenState();
}

class _ServiceBaselineScreenState extends State<ServiceBaselineScreen> {
  DateTime? _lastServiceDate;
  // ignore: unused_field
  int _odometerAtLastService = 0; // Used in UI text field
  int? _serviceCycle = 10000;
  // ignore: unused_field
  int _currentOdometer = 0; // Used in UI text field
  final TextEditingController _customCycleController = TextEditingController();

  final List<int?> _serviceCycles = [5000, 10000, 15000, 20000, null];

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
    }
  }

  @override
  void dispose() {
    _customCycleController.dispose();
    super.dispose();
  }

  void _finalizeAndStart() {
    // ignore: unused_local_variable
    final int finalCycle =
        _serviceCycle ?? int.tryParse(_customCycleController.text) ?? 10000;
    // Save to Hive logic (TODO)
    // Navigate to Home
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainTabScreen()),
    ); // Placeholder route
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
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) => setState(
                    () => _odometerAtLastService = int.tryParse(val) ?? 0,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'e.g. 45000',
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
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) =>
                      setState(() => _currentOdometer = int.tryParse(val) ?? 0),
                  decoration: const InputDecoration(
                    hintText: 'e.g. 48200',
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
