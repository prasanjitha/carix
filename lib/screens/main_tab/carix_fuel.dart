import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CarixFuelScreen extends StatefulWidget {
  const CarixFuelScreen({super.key});

  @override
  State<CarixFuelScreen> createState() => _CarixFuelScreenState();
}

class _CarixFuelScreenState extends State<CarixFuelScreen> {
  int _selectedFuelTypeCard = 1;
  int _selectedMonthIndex = 5;

  static const List<_FuelPrice> _fuelPrices = [
    _FuelPrice(label: 'Petrol 92', price: 371.00),
    _FuelPrice(label: 'Petrol 95', price: 392.00),
  ];

  static const List<_FuelMonthData> _months = [
    _FuelMonthData(
      month: 'AUG',
      costBar: 0.42,
      efficiencyBar: 0.24,
      efficiencyKmL: 12.1,
      monthlySpend: 21400,
      estRange: 368,
      rangeProgress: 0.62,
      costPerKm: 34.20,
      lastFillAmount: 6900,
      lastFillDate: '06 Aug',
      lastFillLiters: 21.4,
    ),
    _FuelMonthData(
      month: 'SEP',
      costBar: 0.56,
      efficiencyBar: 0.22,
      efficiencyKmL: 11.8,
      monthlySpend: 22950,
      estRange: 352,
      rangeProgress: 0.58,
      costPerKm: 35.05,
      lastFillAmount: 7200,
      lastFillDate: '17 Sep',
      lastFillLiters: 22.0,
    ),
    _FuelMonthData(
      month: 'OCT',
      costBar: 0.66,
      efficiencyBar: 0.56,
      efficiencyKmL: 13.6,
      monthlySpend: 24100,
      estRange: 395,
      rangeProgress: 0.71,
      costPerKm: 33.10,
      lastFillAmount: 7600,
      lastFillDate: '14 Oct',
      lastFillLiters: 22.1,
    ),
    _FuelMonthData(
      month: 'NOV',
      costBar: 0.50,
      efficiencyBar: 0.24,
      efficiencyKmL: 12.4,
      monthlySpend: 23800,
      estRange: 381,
      rangeProgress: 0.66,
      costPerKm: 33.95,
      lastFillAmount: 7400,
      lastFillDate: '09 Nov',
      lastFillLiters: 22.5,
    ),
    _FuelMonthData(
      month: 'DEC',
      costBar: 0.75,
      efficiencyBar: 0.74,
      efficiencyKmL: 14.0,
      monthlySpend: 25500,
      estRange: 408,
      rangeProgress: 0.82,
      costPerKm: 32.70,
      lastFillAmount: 7850,
      lastFillDate: '19 Dec',
      lastFillLiters: 22.8,
    ),
    _FuelMonthData(
      month: 'JAN',
      costBar: 0.86,
      efficiencyBar: 0.86,
      efficiencyKmL: 14.2,
      monthlySpend: 26500,
      estRange: 420,
      rangeProgress: 0.86,
      costPerKm: 32.50,
      lastFillAmount: 8000,
      lastFillDate: '21 Jan',
      lastFillLiters: 22.3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedMonth = _months[_selectedMonthIndex];
    final gaugeValue = (selectedMonth.efficiencyKmL / 20).clamp(0.0, 1.0);

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
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildFuelPriceCards(),
                  const SizedBox(height: 32),
                  _buildLiveEfficiencyCard(selectedMonth, gaugeValue),
                  const SizedBox(height: 24),
                  _buildMetricsGrid(selectedMonth),
                  const SizedBox(height: 24),
                  _buildInsightBanner(),
                  const SizedBox(height: 24),
                  _buildTrendCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FUEL & EFFICIENCY',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Fuel Metrics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
      ],
    );
  }

  Widget _buildFuelPriceCards() {
    return Row(
      children: List.generate(_fuelPrices.length, (index) {
        final fuel = _fuelPrices[index];
        final selected = _selectedFuelTypeCard == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == 0 ? 12 : 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => setState(() => _selectedFuelTypeCard = index),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.1),
                        width: 1.5,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 25,
                                spreadRadius: 4,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fuel.label,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              'Rs. ',
                              style: TextStyle(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              fuel.price.toInt().toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '/ Liter',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 11,
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
        );
      }),
    );
  }

  Widget _buildLiveEfficiencyCard(
    _FuelMonthData selectedMonth,
    double gaugeValue,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Efficiency Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.cyan.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Text(
                      'LIVE',
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Glow
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.15),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 190,
                      height: 190,
                      child: CircularProgressIndicator(
                        value: gaugeValue,
                        strokeWidth: 12,
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.cyan,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedMonth.efficiencyKmL.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KM/L',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF059669).withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.cyan, size: 18),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Efficiency is 5% higher than average.',
                        style: TextStyle(
                          color: Color(0xFFA7F3D0),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(_FuelMonthData month) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.local_activity_outlined,
                title: 'Cost / KM',
                value: 'Rs. ${month.costPerKm.toStringAsFixed(2)}',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.local_gas_station_outlined,
                title: 'Last Fill',
                value: 'Rs. ${month.lastFillAmount}',
                subtitle:
                    '${month.lastFillDate} • ${month.lastFillLiters.toStringAsFixed(1)}L',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.calendar_month,
                title: 'Monthly Spend',
                value: 'Rs. ${month.monthlySpend}',
                subtitle: '+8% vs last month',
                subtitleColor: const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.map,
                title: 'Est. Range',
                value: '${month.estRange} km',
                progress: month.rangeProgress,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.primary.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_motion,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Best Performance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'AI INSIGHT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    const TextSpan(text: 'Vehicle achieved max efficiency '),
                    TextSpan(
                      text: '(15.5 km/L)',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const TextSpan(text: ' using fuel from '),
                    const TextSpan(
                      text: 'Ceypetco – Colombo 07 Station.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Efficiency Trend',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Last 6 Months (km/L)',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildLegendDot(AppColors.primary, 'Cost'),
                  const SizedBox(width: 16),
                  _buildLegendDot(AppColors.cyan, 'KM/L'),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 200,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(_months.length, (index) {
                    final month = _months[index];
                    final active = _selectedMonthIndex == index;

                    return Expanded(
                      child: InkWell(
                        onTap: () =>
                            setState(() => _selectedMonthIndex = index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    // Base Bar
                                    Container(
                                      width: 28,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.05,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    // Cost Bar
                                    Container(
                                      width: 28,
                                      height: 200 * month.costBar,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primary.withValues(
                                              alpha: active ? 0.8 : 0.3,
                                            ),
                                            AppColors.primary.withValues(
                                              alpha: active ? 0.4 : 0.1,
                                            ),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                        boxShadow: active
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.3),
                                                  blurRadius: 10,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                                    // Efficiency Bar (Inner)
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: 14,
                                      height: 200 * month.efficiencyBar,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.cyan.withValues(
                                              alpha: active ? 1.0 : 0.4,
                                            ),
                                            AppColors.cyan.withValues(
                                              alpha: active ? 0.6 : 0.2,
                                            ),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                month.month,
                                style: TextStyle(
                                  color: active
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.4),
                                  fontSize: 11,
                                  fontWeight: active
                                      ? FontWeight.w900
                                      : FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 6),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color subtitleColor;
  final double? progress;

  const _MetricCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.subtitleColor = const Color(0xFF94A3B8),
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 144,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const Spacer(),
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: subtitleColor == const Color(0xFF94A3B8)
                        ? Colors.white.withValues(alpha: 0.4)
                        : subtitleColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ] else if (progress != null) ...[
                Stack(
                  children: [
                    Container(
                      height: 5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Container(
                      height: 5,
                      width: 100 * progress!, // Simplified for example
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.cyan, Color(0xFF0EA5E9)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FuelPrice {
  final String label;
  final double price;

  const _FuelPrice({required this.label, required this.price});
}

class _FuelMonthData {
  final String month;
  final double costBar;
  final double efficiencyBar;
  final double efficiencyKmL;
  final int monthlySpend;
  final int estRange;
  final double rangeProgress;
  final double costPerKm;
  final int lastFillAmount;
  final String lastFillDate;
  final double lastFillLiters;

  const _FuelMonthData({
    required this.month,
    required this.costBar,
    required this.efficiencyBar,
    required this.efficiencyKmL,
    required this.monthlySpend,
    required this.estRange,
    required this.rangeProgress,
    required this.costPerKm,
    required this.lastFillAmount,
    required this.lastFillDate,
    required this.lastFillLiters,
  });
}
