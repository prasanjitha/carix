import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_gradient_background.dart';
import '../main_tab/main_tab_screen.dart';
import 'login_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../generated/assets.dart';

class BiometricLoginScreen extends StatefulWidget {
  final bool isLoggedIn;
  const BiometricLoginScreen({super.key, required this.isLoggedIn});

  @override
  State<BiometricLoginScreen> createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  bool _isCheckingSupport = true;

  @override
  void initState() {
    super.initState();
    _checkSupportAndAuthenticate();
  }

  Future<void> _checkSupportAndAuthenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics
          .timeout(const Duration(seconds: 2), onTimeout: () => false);
      final bool isDeviceSupported = await auth.isDeviceSupported().timeout(
        const Duration(seconds: 2),
        onTimeout: () => false,
      );
      final List<BiometricType> availableBiometrics = await auth
          .getAvailableBiometrics()
          .timeout(
            const Duration(seconds: 2),
            onTimeout: () => <BiometricType>[],
          );

      if (!canAuthenticateWithBiometrics ||
          !isDeviceSupported ||
          availableBiometrics.isEmpty) {
        _handleNoBiometricSupport();
        return;
      }

      if (mounted) {
        setState(() {
          _isCheckingSupport = false;
        });
      }

      // Small delay to ensure UI is ready before system prompt
      await Future.delayed(const Duration(milliseconds: 500));
      _authenticate();
    } catch (e) {
      debugPrint('Biometric check error: $e');
      _handleNoBiometricSupport();
    }
  }

  void _handleNoBiometricSupport() {
    if (mounted) {
      if (widget.isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainTabScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access your Carix dashboard',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }

    if (authenticated && mounted) {
      final userBox = Hive.box('user_box');
      await userBox.put('isLoggedIn', true);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainTabScreen()),
        );
      }
    }
  }

  void _usePassword() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingSupport) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        body: Center(
          child: Hero(
            tag: 'logo',
            child: Image.asset(Assets.logoCarix, height: 80, width: 80),
          ),
        ),
      );
    }
    return AppGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with glow
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
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
                  const SizedBox(height: 40),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Quick access with biometrics',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 60),
                  // Biometric Icon Button
                  GestureDetector(
                    onTap: _isAuthenticating ? null : _authenticate,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.2),
                            AppColors.primary.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.fingerprint_rounded,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  // Fallback to Password
                  TextButton(
                    onPressed: _usePassword,
                    child: Text(
                      'Use Password Instead',
                      style: TextStyle(
                        color: AppColors.primary.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
