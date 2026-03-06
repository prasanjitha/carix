import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _alertLeadTime = '14 Days Before';
  bool _autoSync = true;
  bool _soundAndVibration = true;
  String _serviceSensitivity = 'Balanced';
  double _budgetThreshold = 500;

  String _fuelUnit = 'km/L';
  String _currency = 'USD (\$)';
  String _distanceUnit = 'KM';

  int _rating = 5;

  static const List<String> _alertLeadOptions = [
    '7 Days Before',
    '14 Days Before',
    '21 Days Before',
    '30 Days Before',
  ];

  static const List<String> _currencyOptions = [
    'USD (\$)',
    'LKR (Rs.)',
    'EUR (€)',
  ];

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SettingsHeader(),
                  const SizedBox(height: 32),
                  const _PremiumFeatureCard(),
                  const SizedBox(height: 24),
                  const _SectionLabel('QUICK ACTIONS'),
                  const SizedBox(height: 12),
                  const _TripLogCard(),
                  const SizedBox(height: 24),
                  const _SectionLabel('CLOUD SERVICES'),
                  const SizedBox(height: 12),
                  _CloudBackupCard(
                    autoSync: _autoSync,
                    onAutoSyncChanged: (value) =>
                        setState(() => _autoSync = value),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('NOTIFICATION SETTINGS'),
                  const SizedBox(height: 12),
                  _NotificationSettingsCard(
                    alertLeadTime: _alertLeadTime,
                    alertLeadOptions: _alertLeadOptions,
                    onAlertLeadChanged: (value) {
                      if (value != null) {
                        setState(() => _alertLeadTime = value);
                      }
                    },
                    soundAndVibration: _soundAndVibration,
                    onSoundAndVibrationChanged: (value) =>
                        setState(() => _soundAndVibration = value),
                    serviceSensitivity: _serviceSensitivity,
                    onServiceSensitivityChanged: (value) =>
                        setState(() => _serviceSensitivity = value),
                    budgetThreshold: _budgetThreshold,
                    onBudgetThresholdChanged: (value) =>
                        setState(() => _budgetThreshold = value),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('APP PREFERENCES'),
                  const SizedBox(height: 12),
                  _AppPreferencesCard(
                    fuelUnit: _fuelUnit,
                    onFuelUnitChanged: (value) =>
                        setState(() => _fuelUnit = value),
                    currency: _currency,
                    currencyOptions: _currencyOptions,
                    onCurrencyChanged: (value) {
                      if (value != null) {
                        setState(() => _currency = value);
                      }
                    },
                    distanceUnit: _distanceUnit,
                    onDistanceChanged: (value) =>
                        setState(() => _distanceUnit = value),
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('SUPPORT'),
                  const SizedBox(height: 12),
                  _SupportAndLinksCard(
                    rating: _rating,
                    onRatingChanged: (value) => setState(() => _rating = value),
                  ),
                  const SizedBox(height: 32),
                  const _FooterBlock(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Text(
              'Settings & Tools',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Align(alignment: Alignment.centerRight, child: _HeaderAvatar()),
        ],
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.15),
            AppColors.primary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
    );
  }
}

class _PremiumFeatureCard extends StatelessWidget {
  const _PremiumFeatureCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.08),
                const Color(0xFFEAB308).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFEAB308).withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAB308).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFEAB308).withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: Color(0xFFEAB308),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PREMIUM FEATURE',
                          style: TextStyle(
                            color: Color(0xFFEAB308),
                            fontSize: 12,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Generate Vehicle Resume',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Create a professional PDF service history to increase resale value.',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      const Color(0xFFEAB308).withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFEAB308).withValues(alpha: 0.2),
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFFEAB308),
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.picture_as_pdf, size: 20),
                  label: const Text(
                    'Export PDF',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripLogCard extends StatelessWidget {
  const _TripLogCard();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.map_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trip Log Manager',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Track mileage, fuel, tolls & expenses',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white24),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: AppColors.primary,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Start New',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.05),
                        Colors.white.withValues(alpha: 0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white70,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'View Past',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CloudBackupCard extends StatelessWidget {
  final bool autoSync;
  final ValueChanged<bool> onAutoSyncChanged;

  const _CloudBackupCard({
    required this.autoSync,
    required this.onAutoSyncChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.cyan.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.cloud_done_rounded,
                  color: AppColors.cyan,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cloud Backup & Sync',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Last Sync: 2 hours ago',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Auto-Sync',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: autoSync,
                onChanged: onAutoSyncChanged,
                activeColor: AppColors.cyan,
                activeTrackColor: AppColors.cyan.withValues(alpha: 0.15),
                inactiveThumbColor: Colors.white30,
                inactiveTrackColor: Colors.white10,
              ),
            ],
          ),
          Divider(height: 24, color: Colors.white.withValues(alpha: 0.1)),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Backup Now',
              style: TextStyle(
                color: AppColors.cyan,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationSettingsCard extends StatelessWidget {
  final String alertLeadTime;
  final List<String> alertLeadOptions;
  final ValueChanged<String?> onAlertLeadChanged;
  final bool soundAndVibration;
  final ValueChanged<bool> onSoundAndVibrationChanged;
  final String serviceSensitivity;
  final ValueChanged<String> onServiceSensitivityChanged;
  final double budgetThreshold;
  final ValueChanged<double> onBudgetThresholdChanged;

  const _NotificationSettingsCard({
    required this.alertLeadTime,
    required this.alertLeadOptions,
    required this.onAlertLeadChanged,
    required this.soundAndVibration,
    required this.onSoundAndVibrationChanged,
    required this.serviceSensitivity,
    required this.onServiceSensitivityChanged,
    required this.budgetThreshold,
    required this.onBudgetThresholdChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Alert Lead Time', style: _FieldLabel.textStyle),
          const SizedBox(height: 10),
          _DropdownField(
            value: alertLeadTime,
            items: alertLeadOptions,
            onChanged: onAlertLeadChanged,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text('Sound & Vibration', style: _FieldLabel.textStyle),
              ),
              Switch(
                value: soundAndVibration,
                onChanged: onSoundAndVibrationChanged,
                activeColor: AppColors.cyan,
                activeTrackColor: AppColors.cyan.withValues(alpha: 0.15),
                inactiveThumbColor: Colors.white30,
                inactiveTrackColor: Colors.white10,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Service Reminder Sensitivity',
            style: _FieldLabel.textStyle,
          ),
          const SizedBox(height: 10),
          _SegmentedControl(
            options: const ['Strict', 'Balanced', 'Relaxed'],
            selected: serviceSensitivity,
            onSelected: onServiceSensitivityChanged,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Budget Alert Threshold',
                  style: _FieldLabel.textStyle,
                ),
              ),
              Text(
                '\$${budgetThreshold.round()}',
                style: const TextStyle(
                  color: AppColors.cyan,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.cyan,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
              thumbColor: AppColors.cyan,
              overlayColor: AppColors.cyan.withValues(alpha: 0.1),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 8,
                elevation: 4,
              ),
              trackHeight: 4,
            ),
            child: Slider(
              value: budgetThreshold,
              min: 100,
              max: 1000,
              onChanged: onBudgetThresholdChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppPreferencesCard extends StatelessWidget {
  final String fuelUnit;
  final ValueChanged<String> onFuelUnitChanged;
  final String currency;
  final List<String> currencyOptions;
  final ValueChanged<String?> onCurrencyChanged;
  final String distanceUnit;
  final ValueChanged<String> onDistanceChanged;

  const _AppPreferencesCard({
    required this.fuelUnit,
    required this.onFuelUnitChanged,
    required this.currency,
    required this.currencyOptions,
    required this.onCurrencyChanged,
    required this.distanceUnit,
    required this.onDistanceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Fuel Unit', style: _FieldLabel.textStyle),
          const SizedBox(height: 10),
          _SegmentedControl(
            options: const ['km/L', 'MPG', 'L/100km'],
            selected: fuelUnit,
            onSelected: onFuelUnitChanged,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Currency', style: _FieldLabel.textStyle),
                    const SizedBox(height: 10),
                    _DropdownField(
                      value: currency,
                      items: currencyOptions,
                      onChanged: onCurrencyChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Distance', style: _FieldLabel.textStyle),
                    const SizedBox(height: 10),
                    _SegmentedControl(
                      options: const ['KM', 'MI'],
                      selected: distanceUnit,
                      onSelected: onDistanceChanged,
                    ),
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

class _SupportAndLinksCard extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const _SupportAndLinksCard({
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        children: [
          const _SupportListTile(
            icon: Icons.bug_report_rounded,
            title: 'Report a Bug',
          ),
          Divider(height: 24, color: Colors.white.withValues(alpha: 0.1)),
          const _SupportListTile(
            icon: Icons.lightbulb_rounded,
            title: 'Request Feature',
          ),
          Divider(height: 24, color: Colors.white.withValues(alpha: 0.1)),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Rate Carix',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  final value = index + 1;
                  return IconButton(
                    onPressed: () => onRatingChanged(value),
                    iconSize: 24,
                    splashRadius: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32),
                    icon: Icon(
                      value <= rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: AppColors.cyan,
                    ),
                  );
                }),
              ),
            ],
          ),
          Divider(height: 24, color: Colors.white.withValues(alpha: 0.1)),
          const _SupportListTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & FAQ',
          ),
          Divider(height: 24, color: Colors.white.withValues(alpha: 0.1)),
          const _SupportListTile(
            icon: Icons.contact_support_rounded,
            title: 'Contact Support',
          ),
        ],
      ),
    );
  }
}

class _SupportListTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SupportListTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white54, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: Colors.white24),
      ],
    );
  }
}

class _FooterBlock extends StatelessWidget {
  const _FooterBlock();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            'Version v1.0.0',
            style: TextStyle(
              color: Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Privacy Policy',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                'Terms of Service',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '© 2024 CARIX AUTOMOTIVE SYSTEMS',
            style: TextStyle(
              color: Colors.white12,
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 12,
        letterSpacing: 2,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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

class _FieldLabel {
  static const textStyle = TextStyle(
    color: Colors.white70,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
}

class _DropdownField extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white38,
          ),
          dropdownColor: AppColors.surface,
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList();
          },
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const _SegmentedControl({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: options.map((option) {
          final isSelected = option == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(option),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white38,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
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
