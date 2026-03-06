import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class UniversalEntryScreen extends StatefulWidget {
  final String initialTab;

  const UniversalEntryScreen({super.key, this.initialTab = 'Overview'});

  @override
  State<UniversalEntryScreen> createState() => _UniversalEntryScreenState();
}

class _UniversalEntryScreenState extends State<UniversalEntryScreen> {
  String _selectedTab = 'Overview';
  String _healthFilterMode = 'Fluids & Filters';
  String _serviceMode = 'Full Service';
  String _documentType = 'License';
  final Map<String, bool> _serviceItems = {
    'Replace Engine Oil': true,
    'Replace Air Filter': true,
    'Replace Transmission Fluid': true,
    'Replace Brake Pads': true,
    'Replace Battery': true,
    'Replace Tires': true,
  };

  static const List<String> _tabs = [
    'Overview',
    'Health',
    'Fuel',
    'Service',
    'Docs',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = _tabs.contains(widget.initialTab)
        ? widget.initialTab
        : 'Overview';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.8, -0.5),
                  radius: 1.8,
                  colors: [Color(0xFF1E293B), AppColors.background],
                ),
              ),
            ),
          ),

          // Glow Orbs
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 12),
                      _buildTopTabs(),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: SingleChildScrollView(
                      key: ValueKey<String>(_selectedTab),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: _buildSelectedView(),
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            _selectedTab == 'Fuel'
                ? 'Fuel Entry'
                : _selectedTab == 'Docs'
                ? 'Document Entry'
                : 'Universal Entry Center',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: const Icon(Icons.more_vert, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildTopTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tabs.map((tab) {
          final selected = tab == _selectedTab;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      _tabIcon(tab),
                      size: 16,
                      color: selected ? Colors.white : Colors.white60,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tab,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white60,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _tabIcon(String tab) {
    switch (tab) {
      case 'Health':
        return Icons.favorite;
      case 'Fuel':
        return Icons.local_gas_station;
      case 'Service':
        return Icons.build;
      case 'Docs':
        return Icons.description;
      case 'Overview':
      default:
        return Icons.dashboard;
    }
  }

  Widget _buildSelectedView() {
    switch (_selectedTab) {
      case 'Health':
        return _buildHealthView();
      case 'Fuel':
        return _buildFuelView();
      case 'Service':
        return _buildServiceView();
      case 'Docs':
        return _buildDocsView();
      case 'Overview':
      default:
        return _buildExpenseView();
    }
  }

  Widget _buildHealthView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vehicle Health Setup',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        const _FieldLabel('Current Odometer (km) *'),
        const SizedBox(height: 6),
        const _InputField(hint: 'e.g. 45000', trailing: Icons.speed),
        const SizedBox(height: 12),
        _SegmentedToggle(
          options: const ['Fluids & Filters', 'Mechanical & Parts'],
          selected: _healthFilterMode,
          onSelect: (value) => setState(() => _healthFilterMode = value),
        ),
        const SizedBox(height: 12),
        const _HealthMaintenanceCard(
          icon: Icons.oil_barrel,
          title: 'Engine Oil',
          subtitle: 'Scheduled maintenance interval',
          value: '10,000 km',
        ),
        const SizedBox(height: 10),
        const _HealthMaintenanceCard(
          icon: Icons.tune,
          title: 'Transmission Fluid',
          subtitle: 'Service frequency',
          value: '80,000 km',
        ),
        const SizedBox(height: 10),
        const _HealthMaintenanceCard(
          icon: Icons.air,
          title: 'Air Filter',
          subtitle: 'Replacement cycle',
          value: '15,000 km',
        ),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(
              child: Text(
                'Maintenance History\nPreview',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              'Mechanical & Parts details\nbelow',
              style: TextStyle(color: AppColors.cyan, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const _HistoryTile(
          icon: Icons.change_history,
          title: 'Brake Pads',
          leftLabel: 'LAST REPLACED (KM)',
          leftValue: '22,500',
          rightLabel: 'TYPICAL LIFE (KM)',
          rightValue: '25,000',
        ),
        const SizedBox(height: 10),
        const _HistoryTile(
          icon: Icons.battery_charging_full,
          title: 'Battery',
          leftLabel: 'INSTALL DATE',
          leftValue: 'mm/dd/yyyy',
          rightLabel: 'WARRANTY (MONTHS)',
          rightValue: '24',
        ),
        const SizedBox(height: 10),
        const _HistoryTile(
          icon: Icons.tire_repair,
          title: 'Tires Set',
          leftLabel: 'INSTALL ODOMETER',
          leftValue: '38,000',
          rightLabel: 'INSTALL DATE',
          rightValue: 'mm/dd/yyyy',
        ),
      ],
    );
  }

  Widget _buildFuelView() {
    return Column(
      children: const [
        _FuelPriceSettingsCard(),
        SizedBox(height: 12),
        _AddFuelBillCard(),
        SizedBox(height: 12),
        _FuelInsightBanner(),
      ],
    );
  }

  Widget _buildServiceView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SegmentedToggle(
          options: const ['Full Service', 'Normal Service'],
          selected: _serviceMode,
          onSelect: (value) => setState(() => _serviceMode = value),
        ),
        const SizedBox(height: 14),
        const Text(
          'SERVICE ITEMS',
          style: TextStyle(
            color: AppColors.cyan,
            fontSize: 14,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ..._serviceItems.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ServiceChecklistItem(
              label: entry.key,
              checked: entry.value,
              onChanged: (value) =>
                  setState(() => _serviceItems[entry.key] = value),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const _FieldLabel('TOTAL SERVICE COST'),
        const SizedBox(height: 6),
        const _InputField(hint: '\$ 0.00'),
        const SizedBox(height: 10),
        Row(
          children: const [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('SERVICE DATE'),
                  SizedBox(height: 6),
                  _InputField(
                    hint: 'Oct 24, 2023',
                    trailing: Icons.calendar_today,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FieldLabel('ODOMETER'),
                  SizedBox(height: 6),
                  _InputField(hint: '42,500 KM'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocsView() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('DOCUMENT TYPE'),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _DropdownLikeField(
                  value: _documentType,
                  onTap: () {
                    final next = _documentType == 'License'
                        ? 'Insurance'
                        : _documentType == 'Insurance'
                        ? 'Eco Test'
                        : 'License';
                    setState(() => _documentType = next);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _FieldLabel('EXPIRY DATE'),
          const SizedBox(height: 6),
          const _InputField(
            hint: 'Oct 24, 2024',
            trailing: Icons.calendar_today,
          ),
          const SizedBox(height: 12),
          const _FieldLabel('UPLOAD DOCUMENT PHOTO'),
          const SizedBox(height: 8),
          const _UploadDashedBox(),
        ],
      ),
    );
  }

  Widget _buildExpenseView() {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _FieldLabel('EXPENSE TITLE'),
          SizedBox(height: 6),
          _InputField(hint: 'Example: Car Wash, Parking, Repair'),
          SizedBox(height: 12),
          _FieldLabel('CATEGORY'),
          SizedBox(height: 6),
          _DropdownLikeField(value: 'Repairs'),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _FieldLabel('AMOUNT (RS.)'),
                    SizedBox(height: 6),
                    _InputField(hint: '0.00'),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _FieldLabel('DATE'),
                    SizedBox(height: 6),
                    _InputField(
                      hint: 'Oct 24, 2023',
                      trailing: Icons.calendar_today,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _FieldLabel('OPTIONAL NOTES'),
          SizedBox(height: 6),
          _InputField(hint: 'Add any additional details here...', maxLines: 4),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  foregroundColor: Colors.white70,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                icon: const Icon(Icons.close_rounded, size: 20),
                label: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.primary,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.check_circle_rounded, size: 20),
                label: const Text(
                  'Save Entry',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        letterSpacing: 1,
        fontWeight: FontWeight.w800,
        fontSize: 13,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String hint;
  final IconData? trailing;
  final int maxLines;

  const _InputField({required this.hint, this.trailing, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: maxLines > 1 ? 12 : 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              hint,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: maxLines,
            ),
          ),
          if (trailing != null) Icon(trailing, size: 20, color: Colors.white38),
        ],
      ),
    );
  }
}

class _DropdownLikeField extends StatelessWidget {
  final String value;
  final VoidCallback? onTap;

  const _DropdownLikeField({required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelect;

  const _SegmentedToggle({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 140),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white54,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HealthMaintenanceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String value;

  const _HealthMaintenanceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.cyan.withValues(alpha: 0.15),
                      AppColors.cyan.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cyan.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(icon, color: AppColors.cyan, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DropdownLikeField(value: value),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  const _HistoryTile({
    required this.icon,
    required this.title,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white54, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leftLabel,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _InputField(hint: leftValue),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rightLabel,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 5),
                    _InputField(hint: rightValue),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FuelPriceSettingsCard extends StatelessWidget {
  const _FuelPriceSettingsCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.settings, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Configure fuel rates for auto-calc',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.expand_less,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('OCTANE 92 (RS/L)'),
                    SizedBox(height: 6),
                    _InputField(hint: '0.00'),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel('OCTANE 95 (RS/L)'),
                    SizedBox(height: 6),
                    _InputField(hint: '0.00'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddFuelBillCard extends StatelessWidget {
  const _AddFuelBillCard();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.local_gas_station_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Add Today\'s Fuel Bill',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _FieldLabel('Cost (Rs.)'),
          SizedBox(height: 6),
          _InputField(hint: 'Rs   Enter amount'),
          SizedBox(height: 10),
          _FieldLabel('Odometer at Fueling (km)'),
          SizedBox(height: 6),
          _InputField(hint: 'e.g. 45,230'),
          SizedBox(height: 10),
          _FieldLabel('Fuel Shed Name'),
          SizedBox(height: 6),
          _InputField(hint: 'Lanka IOC, Ceypetco...'),
          SizedBox(height: 10),
          _FieldLabel('Date'),
          SizedBox(height: 6),
          _InputField(hint: '10/24/2023', trailing: Icons.calendar_today),
        ],
      ),
    );
  }
}

class _FuelInsightBanner extends StatelessWidget {
  const _FuelInsightBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'FUEL INSIGHTS',
            style: TextStyle(
              color: AppColors.cyan,
              letterSpacing: 2,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Optimize your consumption',
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceChecklistItem extends StatelessWidget {
  final String label;
  final bool checked;
  final ValueChanged<bool> onChanged;

  const _ServiceChecklistItem({
    required this.label,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.build_circle_outlined, color: AppColors.cyan),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!checked),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: checked
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.1),
              child: Icon(
                checked ? Icons.check : Icons.circle_outlined,
                color: checked ? Colors.white : Colors.white38,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadDashedBox extends StatelessWidget {
  const _UploadDashedBox();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(
        color: Colors.white.withValues(alpha: 0.2),
        strokeWidth: 2,
        radius: 24,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 46,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(
                Icons.camera_alt,
                color: AppColors.primary,
                size: 38,
              ),
            ),
            const SizedBox(height: 12),
            const Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.2,
                ),
                children: [
                  TextSpan(
                    text: 'Upload a file ',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: 'or drag and drop'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'PNG, JPG, PDF up to 10MB',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    const dashWidth = 8.0;
    const dashSpace = 6.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, nextDistance), paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        radius != oldDelegate.radius;
  }
}
