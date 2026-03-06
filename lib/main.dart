import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/vehicle_model.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding/biometric_login_screen.dart';
import 'screens/onboarding/onboarding_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(VehicleModelAdapter());

  // Open Boxes
  await Hive.openBox<VehicleModel>('vehicle_box');
  await Hive.openBox('user_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box('user_box');
    final email = userBox.get('email');
    final isLoggedIn = userBox.get('isLoggedIn', defaultValue: false);

    Widget homeWidget;

    if (email == null) {
      // User has not registered yet
      homeWidget = const OnboardingWrapper();
    } else {
      // User is registered, show Biometric screen (it will handle auto-bypass if unsupported)
      homeWidget = BiometricLoginScreen(isLoggedIn: isLoggedIn);
    }

    return MaterialApp(
      title: 'Carix',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: homeWidget,
    );
  }
}
