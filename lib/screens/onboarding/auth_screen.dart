import 'package:flutter/material.dart';
import '../../generated/assets.dart';
import '../../theme/app_colors.dart';

import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login_screen.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onNext;

  const AuthScreen({super.key, required this.onNext});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _createAccount() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      final fToast = FToast();
      fToast.init(context);

      Widget toast = ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: AppColors.primary, size: 20),
                SizedBox(width: 10.0),
                Text(
                  'Please fill all required fields',
                  style: TextStyle(
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
      return;
    }

    final userBox = Hive.box('user_box');
    userBox.put('fullName', name);
    userBox.put('email', email);
    userBox.put('password', password); // Added for login check
    userBox.put('isLoggedIn', true);

    widget.onNext();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customShadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4), // තව ටිකක් තද කළා
        blurRadius: 20,
        spreadRadius: -2, // Shadow එක පැතිරෙන එක පාලනය කරන්න
        offset: const Offset(0, 10),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),

          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // පසුබිම transparent කරලා shadow එකක් විතරක් දෙන්න
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(
                    255,
                    4,
                    103,
                    128,
                  ).withValues(alpha: 0.3),
                  blurRadius: 50,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Image.asset(Assets.logoCarix, fit: BoxFit.contain),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Smart Vehicle Partner',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 5.0),
          const Text(
            'Join Carix Family',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your vehicle like a pro.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 32),

          // --- Google Login Button with Shadow ---
          Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              // Background එක සම්පූර්ණ සුදු වෙනුවට ලාවට transparent කරන්න
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: 0.1,
                ), // ඉතා ලා සුදු border එකක්
                width: 1,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                // Google Login Logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors
                    .transparent, // Container එකේ පාට පේන්න මෙතන transparent කරන්න
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Icon එක (ඔයාගේ assets පාවිච්චි කරන්න)
                  Image.asset(Assets.googleIcon, height: 22),
                  const SizedBox(width: 15),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.divider)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: AppColors.textSecondary.withAlpha(127),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Expanded(child: Divider(color: AppColors.divider)),
            ],
          ),
          const SizedBox(height: 24),

          // --- TextFields with Shadow ---
          _buildShadowTextField(
            shadow: customShadow,
            child: TextField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Full Name',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.white70,
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFE11D48),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildShadowTextField(
            shadow: customShadow,
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.white,
              ), // Type කරන අකුරු සුදු පාටින්
              decoration: InputDecoration(
                hintText: 'Email Address',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: Colors.white70,
                ),
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ), // Background එක ලාවට විනිවිද පේනවා
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFE11D48),
                    width: 1.5,
                  ), // Focus වුණාම රතු/රෝස පාට border එක
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildShadowTextField(
            shadow: customShadow,
            child: TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              style: const TextStyle(color: Colors.white), // අකුරු සුදු පාටින්
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.white70,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.white.withValues(
                  alpha: 0.05,
                ), // ලාවට විනිවිද පේන විදිහට
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.white.withAlpha(20),
                  ), // ඉතා ලා බෝඩර් එකක්
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withAlpha(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFFE11D48),
                    width: 1.5,
                  ), // Focus වුණාම රතු/රෝස පාට border එක
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Create Account Button (Gradient)
          Container(
            height: 60, // උස fixed කරගන්න පුළුවන්
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFFE11D48), Color(0xFFF97316)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE11D48).withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8), // යටට වැඩිපුර shadow එක වැටෙන්න
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _createAccount,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white.withValues(
                  alpha: 0.3,
                ), // Click කරනකොට එන ripple color එක
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'CREATE ACCOUNT',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
          // Login Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Terms of Service  •  Privacy Policy\n© 2026 Carix Inc. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Shadow එක දාන්න Helper Method එකක් (Code එක clean වෙන්න)
  Widget _buildShadowTextField({
    required List<BoxShadow> shadow,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          16,
        ), // බටන් එකේ වගේම රවුම් ගතිය වැඩි කළා
        boxShadow: shadow,
      ),
      child: child,
    );
  }
}
