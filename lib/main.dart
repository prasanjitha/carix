import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/vehicle_model.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding/onboarding_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(VehicleModelAdapter());

  // Open Boxes
  await Hive.openBox<VehicleModel>('vehicle_box');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carix',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const OnboardingWrapper(),
    );
  }
}
