import 'dart:ui';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  bool _expiryAlerts = true;
  bool _soundNotifications = false;
  bool _pushNotifications = true;

  static const List<_DocumentItem> _documents = [
    _DocumentItem(
      title: 'Insurance',
      expiryLabel: 'Expires 2026-03-01',
      statusLabel: '7 Days Left!',
      statusType: _DocumentStatusType.warning,
      icon: Icons.security,
      iconColor: Color(0xFFF4B400),
      iconBackground: Color(0xFFFFF3D6),
    ),
    _DocumentItem(
      title: 'Driving License',
      expiryLabel: 'Expires 2028-10-15',
      statusLabel: '950 Days Left',
      statusType: _DocumentStatusType.success,
      icon: Icons.badge,
      iconColor: Color(0xFF22C55E),
      iconBackground: Color(0xFFE5F8EA),
    ),
    _DocumentItem(
      title: 'Eco Test',
      expiryLabel: 'Expired',
      statusLabel: 'Expired 2 days ago',
      statusType: _DocumentStatusType.danger,
      icon: Icons.eco,
      iconColor: Color(0xFFFF4D4F),
      iconBackground: Color(0xFFFFE8EA),
      expired: true,
      cardBorderColor: Color(0xFFFFCDD2),
      cardColor: Color(0xFFFFF8F9),
    ),
    _DocumentItem(
      title: 'Revenue License',
      expiryLabel: 'Expires 2024-05-15',
      statusLabel: '45 days left',
      statusType: _DocumentStatusType.success,
      icon: Icons.description,
      iconColor: Color(0xFF1D6DDC),
      iconBackground: Color(0xFFE3EEFF),
    ),
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
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyan.withValues(alpha: 0.1),
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
                  const _DocumentsHeader(),
                  const SizedBox(height: 14),
                  const _ExpiringAlertCard(),
                  const SizedBox(height: 24),
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Your Documents',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '4 TOTAL',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 14,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ..._documents.map(
                    (document) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _DocumentTile(document: document),
                    ),
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
}

class _DocumentsHeader extends StatelessWidget {
  const _DocumentsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Text(
            'Documents',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _RoundHeaderIcon(icon: Icons.search),
      ],
    );
  }
}

class _RoundHeaderIcon extends StatelessWidget {
  final IconData icon;

  const _RoundHeaderIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 44,
          height: 44,
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

class _ExpiringAlertCard extends StatelessWidget {
  const _ExpiringAlertCard();

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
                AppColors.primary.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 Document Expiring Soon',
                      style: TextStyle(
                        color: Color(0xFFFF8080), // Light Red for title
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Insurance expires in 7 days. Renew now to avoid penalties.',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Renew Insurance',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
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
}

class _DocumentTile extends StatelessWidget {
  final _DocumentItem document;

  const _DocumentTile({required this.document});

  @override
  Widget build(BuildContext context) {
    final themeColor = document.expired
        ? AppColors.primary
        : document.iconColor;

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
                themeColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: themeColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: document.iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: document.iconColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(document.icon, color: document.iconColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      document.expiryLabel,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 14,
                        fontStyle: document.expired
                            ? FontStyle.italic
                            : FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _DocumentStatusBadge(
                label: document.statusLabel,
                type: document.statusType,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentStatusBadge extends StatelessWidget {
  final String label;
  final _DocumentStatusType type;

  const _DocumentStatusBadge({required this.label, required this.type});

  @override
  Widget build(BuildContext context) {
    late final Color color;

    switch (type) {
      case _DocumentStatusType.warning:
        color = const Color(0xFFF4B400);
        break;
      case _DocumentStatusType.success:
        color = const Color(0xFF22C55E);
        break;
      case _DocumentStatusType.danger:
        color = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _PreferenceCard extends StatelessWidget {
  final List<Widget> children;

  const _PreferenceCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1)
                  Divider(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.1),
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferenceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PreferenceTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white70, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.cyan,
            activeTrackColor: AppColors.cyan.withValues(alpha: 0.2),
            inactiveThumbColor: Colors.white30,
            inactiveTrackColor: Colors.white10,
          ),
        ],
      ),
    );
  }
}

class _DocumentItem {
  final String title;
  final String expiryLabel;
  final String statusLabel;
  final _DocumentStatusType statusType;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final bool expired;
  final Color cardColor;
  final Color cardBorderColor;

  const _DocumentItem({
    required this.title,
    required this.expiryLabel,
    required this.statusLabel,
    required this.statusType,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    this.expired = false,
    this.cardColor = Colors.white,
    this.cardBorderColor = const Color(0xFFE7EDF6),
  });
}

enum _DocumentStatusType { warning, success, danger }
