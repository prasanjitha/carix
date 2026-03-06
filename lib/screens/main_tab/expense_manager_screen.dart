import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class ExpenseManagerScreen extends StatefulWidget {
  const ExpenseManagerScreen({super.key});

  @override
  State<ExpenseManagerScreen> createState() => _ExpenseManagerScreenState();
}

class _ExpenseManagerScreenState extends State<ExpenseManagerScreen> {
  String _selectedFilter = 'All';

  static const List<String> _filters = ['All', 'Repairs', 'Services', 'Wash'];

  static const List<_TransactionItem> _transactions = [
    _TransactionItem(
      title: 'Car Wash at AutoMiraj',
      dateLabel: 'Oct 12, 2023',
      categoryLabel: 'Maintenance',
      categoryKey: 'Wash',
      amountLabel: 'Rs. 2,500',
      status: _TransactionStatus.verified,
      icon: Icons.local_car_wash,
      iconColor: AppColors.primary,
      iconBackground: Color(0xFFDDF7FA),
    ),
    _TransactionItem(
      title: 'Tire Replacement',
      dateLabel: 'Oct 10, 2023',
      categoryLabel: 'Repairs',
      categoryKey: 'Repairs',
      amountLabel: 'Rs. 18,000',
      status: _TransactionStatus.pending,
      icon: Icons.tire_repair,
      iconColor: Color(0xFFEA580C),
      iconBackground: Color(0xFFFFEBD1),
    ),
    _TransactionItem(
      title: 'Full Tank Refuel',
      dateLabel: 'Oct 08, 2023',
      categoryLabel: 'Fuel',
      categoryKey: 'Services',
      amountLabel: 'Rs. 12,400',
      status: _TransactionStatus.verified,
      icon: Icons.local_gas_station,
      iconColor: Color(0xFF2563EB),
      iconBackground: Color(0xFFDDEAFE),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleTransactions = _selectedFilter == 'All'
        ? _transactions
        : _transactions
              .where((item) => item.categoryKey == _selectedFilter)
              .toList();

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
                  const _ExpenseHeader(),
                  const SizedBox(height: 24),
                  const _MonthlyExpenseCard(),
                  const SizedBox(height: 20),
                  const _RecurringExpensesCard(),
                  const SizedBox(height: 20),
                  _ExpenseFilterChips(
                    filters: _filters,
                    selectedFilter: _selectedFilter,
                    onSelected: (filter) =>
                        setState(() => _selectedFilter = filter),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...visibleTransactions.map(
                    (transaction) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _TransactionCard(transaction: transaction),
                    ),
                  ),
                  const SizedBox(height: 4),
                  _ExpenseInsightStrip(
                    costPerKm: 'Rs. 11.80',
                    topCategory: _topCategory(visibleTransactions),
                  ),
                  const SizedBox(height: 78),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _topCategory(List<_TransactionItem> transactions) {
    if (transactions.isEmpty) {
      return 'Repairs';
    }

    final counts = <String, int>{};
    for (final transaction in transactions) {
      counts.update(
        transaction.categoryLabel,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    String winner = 'Repairs';
    int maxCount = -1;
    counts.forEach((category, count) {
      if (count > maxCount) {
        winner = category;
        maxCount = count;
      }
    });
    return winner;
  }
}

class _ExpenseHeader extends StatelessWidget {
  const _ExpenseHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Text(
            'Expense Manager',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _HeaderActionButton(icon: Icons.picture_as_pdf),
      ],
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;

  const _HeaderActionButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _MonthlyExpenseCard extends StatelessWidget {
  const _MonthlyExpenseCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.08),
                AppColors.cyan.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: AppColors.cyan.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL MONTHLY EXPENSE',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 13,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Rs. 48,750',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.cyan.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: AppColors.cyan,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    '81% of budget used',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Limit: Rs. 60,000',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Stack(
                children: [
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 10,
                    width:
                        MediaQuery.of(context).size.width *
                        0.81 *
                        0.8, // Approximation
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.cyan,
                          Color(0xFF6366F1),
                        ], // Cyan to Indigo/Blue
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyan.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Warning: Spending is higher than usual this month.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecurringExpensesCard extends StatelessWidget {
  const _RecurringExpensesCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  AppColors.accent.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: AppColors.accent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recurring Expenses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '3 scheduled payments this week',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white24,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpenseFilterChips extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;

  const _ExpenseFilterChips({
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((filter) {
          final selected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onSelected(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 12,
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
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.6),
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
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

class _TransactionCard extends StatelessWidget {
  final _TransactionItem transaction;

  const _TransactionCard({required this.transaction});

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
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.08),
                AppColors.primary.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: transaction.iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: transaction.iconColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  transaction.icon,
                  color: transaction.iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${transaction.dateLabel} \u2022 ${transaction.categoryLabel}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.amountLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _StatusTag(status: transaction.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final _TransactionStatus status;

  const _StatusTag({required this.status});

  @override
  Widget build(BuildContext context) {
    final isVerified = status == _TransactionStatus.verified;
    return Text(
      isVerified ? 'VERIFIED' : 'PENDING',
      style: TextStyle(
        color: isVerified ? AppColors.cyan : Colors.white30,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _ExpenseInsightStrip extends StatelessWidget {
  final String costPerKm;
  final String topCategory;

  const _ExpenseInsightStrip({
    required this.costPerKm,
    required this.topCategory,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _InsightValueBlock(
                  label: 'COST PER KM',
                  value: costPerKm,
                  valueColor: AppColors.primary,
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _InsightValueBlock(
                  label: 'TOP CATEGORY',
                  value: topCategory,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Insights',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightValueBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _InsightValueBlock({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _TransactionItem {
  final String title;
  final String dateLabel;
  final String categoryLabel;
  final String categoryKey;
  final String amountLabel;
  final _TransactionStatus status;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  const _TransactionItem({
    required this.title,
    required this.dateLabel,
    required this.categoryLabel,
    required this.categoryKey,
    required this.amountLabel,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });
}

enum _TransactionStatus { verified, pending }
