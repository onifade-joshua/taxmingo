// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/themes.dart';
import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/dashboard/dashboard_page.dart';
import 'presentation/providers/tax_provider.dart';
import 'presentation/providers/transaction_provider.dart';
import 'presentation/providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaxProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'TaxMingo - Nigerian Tax Manager',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash screen delay

    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.checkAuthStatus();

      // Navigate based on authentication status
      if (authProvider.isAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardPage()),
        );
      } else {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 15,
                  ),
                ],
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 60,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),

            // App Name
            const Text(
              'TaxMingo',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Nigerian Tax Manager',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 50),

            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
