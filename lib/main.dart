import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: BookMyEventApp()));
}

class BookMyEventApp extends StatelessWidget {
  const BookMyEventApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookMyEvent',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.luxuryTheme,
      home: const SplashScreen(),
    );
  }
}
